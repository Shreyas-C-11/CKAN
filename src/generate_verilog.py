"""
generate_verilog.py — Auto-generate Verilog top module from Python config

Reads config.json from a trained model directory and generates:
  1. CKAN_Model_Custom.v — parameterized top module matching your exact config
  2. CKAN_Model_DUT.v    — simulation wrapper with hardcoded widths
  3. tb_dut.v            — self-checking testbench

Usage:
    python generate_verilog.py --model_dir models/20250112_123456 --output_dir firmware/verilog
"""

import json
import os
import argparse
from math import ceil


def calc_conv_out_size(in_size, kernel_size, stride):
    """Calculate output spatial dimension after convolution."""
    return (in_size - kernel_size) // stride + 1


def calc_pool_out_size(in_size, pool_size, pool_stride):
    """Calculate output spatial dimension after pooling."""
    return (in_size - pool_size) // pool_stride + 1


def generate_ckan_model_verilog(config, output_path):
    """
    Generate CKAN_Model_Custom.v from config.
    
    Args:
        config: dict with keys image_height, image_width, conv_layers, mlp_layers, etc.
        output_path: where to write the .v file
    """
    
    # Extract config
    img_h = config["image_height"]
    img_w = config["image_width"]
    conv_layers = config["conv_layers"]
    pool_size = config.get("pool_size", 2)
    pool_stride = config.get("pool_stride", 2)
    
    num_layers = len(conv_layers)
    
    # Calculate dimensions for each layer
    layer_dims = []
    curr_h, curr_w = img_h, img_w
    
    for i, layer in enumerate(conv_layers):
        k = layer["kernel_size"]
        stride = layer.get("stride", 1)
        cin = layer["in_channels"]
        cout = layer["out_channels"]
        
        # After conv
        conv_h = calc_conv_out_size(curr_h, k, stride)
        conv_w = calc_conv_out_size(curr_w, k, stride)
        
        # After pool
        pool_h = calc_pool_out_size(conv_h, pool_size, pool_stride)
        pool_w = calc_pool_out_size(conv_w, pool_size, pool_stride)
        
        layer_dims.append({
            "idx": i,
            "in_channels": cin,
            "out_channels": cout,
            "kernel_size": k,
            "stride": stride,
            "in_h": curr_h,
            "in_w": curr_w,
            "conv_h": conv_h,
            "conv_w": conv_w,
            "pool_h": pool_h,
            "pool_w": pool_w,
            "data_width": layer["in_precision"],
            "value_width": layer["out_precision"],
        })
        
        curr_h, curr_w = pool_h, pool_w
    
    # Final flatten size — use OUT_WIDTH (= VALUE_WIDTH) for flatten calculation
    last_layer = layer_dims[-1]
    out_width = conv_layers[-1]["out_precision"]
    flat_size = last_layer["pool_h"] * last_layer["pool_w"] * last_layer["out_channels"]
    flat_out_width = flat_size * out_width
    
    # =========================================================================
    # Generate CKAN_Model_Custom.v
    # =========================================================================
    verilog = f"""//=====================================================
// Module: CKAN_Model_Custom
// Description:
//   Auto-generated from config.json
//   {num_layers}-layer CKAN CNN model
//   Generated for: {img_h}\u00d7{img_w} input
//=====================================================

module CKAN_Model_Custom #(
    // ---------------- Image Parameters ----------------
    parameter IMG_WIDTH        = {img_w},
    parameter IMG_HEIGHT       = {img_h},

"""
    
    # Layer-specific parameters
    for i, dims in enumerate(layer_dims):
        idx = i + 1
        verilog += f"""    // ---------------- Layer {idx} Parameters ----------------
    parameter L{idx}_KERNEL_SIZE      = {dims['kernel_size']},
    parameter L{idx}_CONV_STRIDE      = {dims['stride']},
    parameter L{idx}_INPUT_CHANNELS   = {dims['in_channels']},
    parameter L{idx}_OUTPUT_CHANNELS  = {dims['out_channels']},
    parameter L{idx}_DATA_WIDTH       = {dims['data_width']},
    parameter L{idx}_VALUE_WIDTH      = {dims['value_width']},
    parameter L{idx}_MEM_FILE         = "kan_lut_conv{i}.mem",
"""
    
    verilog += f"""
    // ---------------- Shared Parameters ----------------
    parameter OUT_WIDTH        = {out_width},

    // ---------------- Shared Pool Parameters ----------------
    parameter POOL_SIZE        = {pool_size},
    parameter POOL_STRIDE      = {pool_stride},
    parameter SIGNED_DATA      = 1,

    // ---------------- Derived Parameters ----------------
"""
    
    # Add derived dimension parameters
    for i, dims in enumerate(layer_dims):
        idx = i + 1
        verilog += f"""    parameter L{idx}_CONV_OUT_W = {dims['conv_w']},
    parameter L{idx}_CONV_OUT_H = {dims['conv_h']},
    parameter L{idx}_POOL_OUT_W = {dims['pool_w']},
    parameter L{idx}_POOL_OUT_H = {dims['pool_h']},
"""
    
    verilog += f"""
    parameter FLAT_OUT_WIDTH = {flat_out_width}
)(
    // ---------------- I/O Ports ----------------
    input  wire                                     clock,
    input  wire                                     sreset_n,
    input  wire                                     data_valid,
    input  wire [L1_INPUT_CHANNELS*L1_DATA_WIDTH-1:0] data_in,

    // ---------------- Final Output ----------------
    output wire [FLAT_OUT_WIDTH-1:0]                flat_out,
    output wire                                     flat_valid
"""
    
    # Add intermediate taps
    for i in range(num_layers):
        idx = i + 1
        verilog += f""",
    output wire [L{idx}_OUTPUT_CHANNELS*L{idx}_VALUE_WIDTH-1:0]  l{idx}_pool_out,
    output wire                                     l{idx}_pool_valid"""
    
    verilog += """
);

    //=====================================================
    // Internal signals
    //=====================================================
"""
    
    # Generate internal signal declarations
    for i in range(num_layers):
        idx = i + 1
        verilog += f"""    wire [L{idx}_OUTPUT_CHANNELS*L{idx}_VALUE_WIDTH-1:0] l{idx}_conv_out;
    wire                                    l{idx}_conv_valid;
"""
    
    # Generate layer instantiations
    for i, dims in enumerate(layer_dims):
        idx = i + 1
        prev_idx = idx - 1
        
        # Determine input source
        if idx == 1:
            data_valid_src = "data_valid"
            data_in_src = "data_in"
            in_w = img_w
            in_h = img_h
        else:
            data_valid_src = f"l{prev_idx}_pool_valid"
            data_in_src = f"l{prev_idx}_pool_out"
            in_w = f"L{prev_idx}_POOL_OUT_W"
            in_h = f"L{prev_idx}_POOL_OUT_H"
        
        verilog += f"""
    //=====================================================
    // Layer {idx}: CKAN Conv + Pool
    //=====================================================
    CKAN_Layer #(
        .KERNEL_SIZE     (L{idx}_KERNEL_SIZE),
        .IMG_WIDTH       ({in_w}),
        .IMG_HEIGHT      ({in_h}),
        .CONV_STRIDE     (L{idx}_CONV_STRIDE),
        .INPUT_CHANNELS  (L{idx}_INPUT_CHANNELS),
        .OUTPUT_CHANNELS (L{idx}_OUTPUT_CHANNELS),
        .DATA_WIDTH      (L{idx}_DATA_WIDTH),
        .VALUE_WIDTH     (L{idx}_VALUE_WIDTH),
        .OUT_WIDTH       (OUT_WIDTH),
        .POOL_SIZE       (POOL_SIZE),
        .POOL_STRIDE     (POOL_STRIDE),
        .SIGNED_DATA     (SIGNED_DATA),
        .MEM_FILE        (L{idx}_MEM_FILE)
    ) layer{idx} (
        .clock      (clock),
        .sreset_n   (sreset_n),
        .data_valid ({data_valid_src}),
        .data_in    ({data_in_src}),
        .pool_out   (l{idx}_pool_out),
        .pool_valid (l{idx}_pool_valid),
        .conv_out   (l{idx}_conv_out),
        .conv_valid (l{idx}_conv_valid)
    );
"""
    
    # Flatten
    last_idx = num_layers
    verilog += f"""
    //=====================================================
    // Flatten
    //=====================================================
    Flatten #(
        .CHANNELS   (L{last_idx}_OUTPUT_CHANNELS),
        .DATA_WIDTH (L{last_idx}_VALUE_WIDTH),
        .COLUMN_NUM (L{last_idx}_POOL_OUT_W),
        .ROW_NUM    (L{last_idx}_POOL_OUT_H)
    ) flatten_inst (
        .clock      (clock),
        .sreset_n   (sreset_n),
        .data_valid (l{last_idx}_pool_valid),
        .data_in    (l{last_idx}_pool_out),
        .flat_out   (flat_out),
        .flat_valid (flat_valid)
    );

endmodule
"""
    
    # Write to file
    os.makedirs(os.path.dirname(output_path) if os.path.dirname(output_path) else ".", exist_ok=True)
    with open(output_path, 'w') as f:
        f.write(verilog)
    
    print(f"✓ Generated {output_path}")
    
    # =========================================================================
    # Generate CKAN_Model_DUT.v — simulation wrapper
    # =========================================================================
    l1 = layer_dims[0]
    dut_data_in_width = l1["in_channels"] * l1["data_width"]
    
    dut = f"""//=====================================================
// Module: CKAN_Model_DUT
// Description:
//   - Design-Under-Test wrapper
//   - {img_h}\u00d7{img_w} input ({l1['in_channels']} channel, {l1['data_width']}-bit pixels)
//   - OUT_WIDTH == VALUE_WIDTH (saturated conv output)
//   - Per-layer LUT files: {', '.join(f'kan_lut_conv{i}.mem' for i in range(num_layers))}
//   - Architecture:
"""
    for i, dims in enumerate(layer_dims):
        idx = i + 1
        dut += f"//       Layer {idx}: {dims['in_h']}\u00d7{dims['in_w']}\u00d7{dims['in_channels']} \u2192 Conv {dims['kernel_size']}\u00d7{dims['kernel_size']} \u2192 {dims['conv_h']}\u00d7{dims['conv_w']}\u00d7{dims['out_channels']} \u2192 Pool {pool_size}\u00d7{pool_size} \u2192 {dims['pool_h']}\u00d7{dims['pool_w']}\u00d7{dims['out_channels']}\n"
    dut += f"//       Flatten: {last_layer['pool_h']}\u00d7{last_layer['pool_w']}\u00d7{last_layer['out_channels']}\u00d7{out_width}b = {flat_out_width}-bit output vector\n"
    
    dut += f"""//=====================================================
module CKAN_Model_DUT (
    input  wire        clock,
    input  wire        sreset_n,
    input  wire        data_valid,
    input  wire [{dut_data_in_width - 1}:0]  pixel_in,       // {l1['in_channels']} channel \u00d7 {l1['data_width']} bits

    output wire [{flat_out_width - 1}:0] flat_out,      // {last_layer['pool_h']}\u00d7{last_layer['pool_w']}\u00d7{last_layer['out_channels']}\u00d7{out_width} = {flat_out_width} bits
    output wire         flat_valid,

    // Intermediate taps
"""
    
    for i, dims in enumerate(layer_dims):
        idx = i + 1
        tap_width = dims["out_channels"] * out_width
        comma = "," if i < num_layers - 1 else ""
        dut += f"""    output wire [{tap_width - 1}:0]  l{idx}_pool_out,   // {dims['out_channels']} channels \u00d7 {out_width} bits
    output wire         l{idx}_pool_valid{comma}
"""
    
    dut += f""");

    CKAN_Model_Custom #(
        // Image
        .IMG_WIDTH           ({img_w}),
        .IMG_HEIGHT          ({img_h}),

"""
    
    for i, dims in enumerate(layer_dims):
        idx = i + 1
        dut += f"""        // Layer {idx}
        .L{idx}_KERNEL_SIZE      ({dims['kernel_size']}),
        .L{idx}_CONV_STRIDE      ({dims['stride']}),
        .L{idx}_INPUT_CHANNELS   ({dims['in_channels']}),
        .L{idx}_OUTPUT_CHANNELS  ({dims['out_channels']}),
        .L{idx}_DATA_WIDTH       ({dims['data_width']}),
        .L{idx}_VALUE_WIDTH      ({dims['value_width']}),
        .L{idx}_MEM_FILE         ("kan_lut_conv{i}.mem"),

"""
    
    dut += f"""        // Shared CKAN (OUT_WIDTH == VALUE_WIDTH for saturated output)
        .OUT_WIDTH           ({out_width}),

        // Shared pool
        .POOL_SIZE           ({pool_size}),
        .POOL_STRIDE         ({pool_stride}),
        .SIGNED_DATA         (1)
    ) model_inst (
        .clock         (clock),
        .sreset_n      (sreset_n),
        .data_valid    (data_valid),
        .data_in       (pixel_in),
        .flat_out      (flat_out),
        .flat_valid    (flat_valid),
"""
    
    for i in range(num_layers):
        idx = i + 1
        comma = "," if i < num_layers - 1 else ""
        dut += f"""        .l{idx}_pool_out   (l{idx}_pool_out),
        .l{idx}_pool_valid (l{idx}_pool_valid){comma}
"""
    
    dut += """    );

endmodule
"""
    
    dut_path = os.path.join(os.path.dirname(output_path), "CKAN_Model_DUT.v")
    with open(dut_path, 'w') as f:
        f.write(dut)
    print(f"✓ Generated {dut_path}")
    
    # =========================================================================
    # Generate tb_dut.v — self-checking testbench
    # =========================================================================
    l1_pool_count = layer_dims[0]["pool_h"] * layer_dims[0]["pool_w"]
    l2_pool_count = layer_dims[-1]["pool_h"] * layer_dims[-1]["pool_w"] if num_layers >= 2 else 0
    
    # For all-ones LUT, each SIC sums K*K lookups of +1 = K*K
    # MIC sums across input channels: K*K * cin
    # Saturated to VALUE_WIDTH signed: clamped if needed
    l1_k = layer_dims[0]["kernel_size"]
    l1_cin = layer_dims[0]["in_channels"]
    l1_expected_val = l1_k * l1_k * l1_cin  # e.g. 9 for K=3, Cin=1
    
    if num_layers >= 2:
        l2_k = layer_dims[1]["kernel_size"]
        l2_cin = layer_dims[1]["in_channels"]
        l2_expected_val = l2_k * l2_k * l2_cin  # e.g. 18 for K=3, Cin=2
    
    l1_tap_width = layer_dims[0]["out_channels"] * out_width
    l1_expected_hex = ""
    for _ in range(layer_dims[0]["out_channels"]):
        l1_expected_hex = f"{l1_expected_val:02x}" + l1_expected_hex
    
    if num_layers >= 2:
        l2_tap_width = layer_dims[1]["out_channels"] * out_width
        l2_expected_hex = ""
        for _ in range(layer_dims[1]["out_channels"]):
            l2_expected_hex = f"{l2_expected_val:02x}" + l2_expected_hex

    tb = f"""`timescale 1ns / 1ps

//=====================================================
// Testbench: tb_dut (SIMPLE DEMO)
//
// Purpose:
//   Easy-to-trace simulation with predictable values.
//   All KAN LUT entries = 01 → every lookup returns +1.
//   Input pixel = 1 (constant).
//
// Expected hand-trace (all LUT entries = +1):
//   Layer 1 (Cin={l1_cin}, Cout={layer_dims[0]['out_channels']}, K={l1_k})
//     SIC: {l1_k}\u00d7{l1_k} pixels \u2192 {l1_k*l1_k} lookups \u2192 {l1_k*l1_k} \u00d7 (+1) = {l1_k*l1_k}
//     MIC: {l1_cin} channel(s) \u2192 sum = {l1_expected_val}
//     Pool 2\u00d72: max = {l1_expected_val}
"""
    if num_layers >= 2:
        tb += f"""//   Layer 2 (Cin={l2_cin}, Cout={layer_dims[1]['out_channels']}, K={l2_k})
//     SIC: {l2_k}\u00d7{l2_k} pixels \u2192 {l2_k*l2_k} lookups \u2192 {l2_k*l2_k} \u00d7 (+1) = {l2_k*l2_k}
//     MIC: {l2_cin} channels \u2192 sum = {l2_expected_val}
//     Pool 2\u00d72: max = {l2_expected_val}
"""
    tb += f"""//
// Expected output counts (one image):
//   L1 pool: {layer_dims[0]['pool_h']}\u00d7{layer_dims[0]['pool_w']} = {l1_pool_count} valid pulses
"""
    if num_layers >= 2:
        tb += f"//   L2 pool: {layer_dims[1]['pool_h']}\u00d7{layer_dims[1]['pool_w']} = {l2_pool_count} valid pulses\n"
    tb += f"""//   Flat:            1 valid pulse
//=====================================================

module tb_dut;

    //=====================================================
    // Parameters
    //=====================================================
    parameter CLK_PERIOD  = 8;        // 125 MHz clock
    parameter IMG_WIDTH   = {img_w};
    parameter IMG_HEIGHT  = {img_h};
    parameter TOTAL_PX    = IMG_WIDTH * IMG_HEIGHT;  // {img_w * img_h} pixels

    // Expected output counts
    parameter L1_POOL_EXPECTED = {l1_pool_count};  // {layer_dims[0]['pool_h']}\u00d7{layer_dims[0]['pool_w']}
"""
    if num_layers >= 2:
        tb += f"    parameter L2_POOL_EXPECTED = {l2_pool_count};   // {layer_dims[1]['pool_h']}\u00d7{layer_dims[1]['pool_w']}\n"
    tb += f"""    parameter FLAT_EXPECTED    = 1;

    //=====================================================
    // DUT I/O
    //=====================================================
    reg         clock;
    reg         sreset_n;
    reg         data_valid;
    reg  [{dut_data_in_width - 1}:0]  pixel_in;

    wire [{flat_out_width - 1}:0] flat_out;       // {flat_out_width} bits
    wire         flat_valid;
    wire [{l1_tap_width - 1}:0]  l1_pool_out;    // {layer_dims[0]['out_channels']} channels \u00d7 {out_width} bits
    wire         l1_pool_valid;
"""
    if num_layers >= 2:
        tb += f"""    wire [{l2_tap_width - 1}:0]  l2_pool_out;    // {layer_dims[1]['out_channels']} channels \u00d7 {out_width} bits
    wire         l2_pool_valid;
"""
    
    tb += f"""
    //=====================================================
    // DUT Instantiation
    //=====================================================
    CKAN_Model_DUT dut (
        .clock         (clock),
        .sreset_n      (sreset_n),
        .data_valid    (data_valid),
        .pixel_in      (pixel_in),
        .flat_out      (flat_out),
        .flat_valid    (flat_valid),
        .l1_pool_out   (l1_pool_out),
        .l1_pool_valid (l1_pool_valid)"""
    if num_layers >= 2:
        tb += """,
        .l2_pool_out   (l2_pool_out),
        .l2_pool_valid (l2_pool_valid)"""
    tb += f"""
    );

    //=====================================================
    // Clock Generation
    //=====================================================
    initial clock = 0;
    always #(CLK_PERIOD/2) clock = ~clock;

    //=====================================================
    // Event Counters
    //=====================================================
    integer l1_pool_count;
"""
    if num_layers >= 2:
        tb += "    integer l2_pool_count;\n"
    tb += f"""    integer flat_count;
    integer errors;

    //=====================================================
    // Monitor Layer 1 Pooled Output
    //   Expected: ch0 = {l1_expected_val}, ch1 = {l1_expected_val}
    //=====================================================
    always @(posedge clock) begin
        if (!sreset_n) begin
            l1_pool_count <= 0;
        end
        else if (l1_pool_valid) begin
            l1_pool_count <= l1_pool_count + 1;
            $display("[%0t] L1_POOL[%0d]: ch0=%0d ch1=%0d  (expect {l1_expected_val}, {l1_expected_val})",
                     $time, l1_pool_count,
                     $signed(l1_pool_out[{out_width - 1}:0]),
                     $signed(l1_pool_out[{l1_tap_width - 1}:{out_width}]));
        end
    end
"""
    
    if num_layers >= 2:
        tb += f"""
    //=====================================================
    // Monitor Layer 2 Pooled Output
    //   Expected: ch0 = {l2_expected_val}, ch1 = {l2_expected_val}
    //=====================================================
    always @(posedge clock) begin
        if (!sreset_n) begin
            l2_pool_count <= 0;
        end
        else if (l2_pool_valid) begin
            l2_pool_count <= l2_pool_count + 1;
            $display("[%0t] L2_POOL[%0d]: ch0=%0d ch1=%0d  (expect {l2_expected_val}, {l2_expected_val})",
                     $time, l2_pool_count,
                     $signed(l2_pool_out[{out_width - 1}:0]),
                     $signed(l2_pool_out[{l2_tap_width - 1}:{out_width}]));
        end
    end
"""
    
    tb += f"""
    //=====================================================
    // Monitor Flatten Output
    //=====================================================
    always @(posedge clock) begin
        if (!sreset_n) begin
            flat_count <= 0;
        end
        else if (flat_valid) begin
            flat_count <= flat_count + 1;
            $display("[%0t] ===== FLAT_VALID #%0d =====", $time, flat_count);
            $display("  flat_out[{out_width - 1}:0]     = 0x%h", flat_out[{out_width - 1}:0]);
            $display("  flat_out[{flat_out_width - 1}:{flat_out_width - out_width}] = 0x%h", flat_out[{flat_out_width - 1}:{flat_out_width - out_width}]);
        end
    end

    //=====================================================
    // Value Checker — verify expected outputs
    //=====================================================
    always @(posedge clock) begin
        // Check L1 pool values
        if (sreset_n && l1_pool_valid) begin
            if (^l1_pool_out === 1'bx) begin
                $display("[%0t] ERROR: l1_pool_out contains X/Z!", $time);
                errors = errors + 1;
            end
            else if (l1_pool_out !== {l1_tap_width}'h{l1_expected_hex}) begin
                $display("[%0t] MISMATCH: l1_pool_out = 0x%h, expected 0x{l1_expected_hex}", $time, l1_pool_out);
                errors = errors + 1;
            end
        end
"""
    
    if num_layers >= 2:
        tb += f"""
        // Check L2 pool values
        if (sreset_n && l2_pool_valid) begin
            if (^l2_pool_out === 1'bx) begin
                $display("[%0t] ERROR: l2_pool_out contains X/Z!", $time);
                errors = errors + 1;
            end
            else if (l2_pool_out !== {l2_tap_width}'h{l2_expected_hex}) begin
                $display("[%0t] MISMATCH: l2_pool_out = 0x%h, expected 0x{l2_expected_hex}", $time, l2_pool_out);
                errors = errors + 1;
            end
        end
"""
    
    tb += f"""
        // Check flat output
        if (sreset_n && flat_valid) begin
            if (^flat_out === 1'bx) begin
                $display("[%0t] ERROR: flat_out contains X/Z!", $time);
                errors = errors + 1;
            end
        end
    end

    //=====================================================
    // Main Stimulus — Feed ONE {img_h}\u00d7{img_w} image, all pixels = 1
    //=====================================================
    integer px;

    initial begin
        // ---- Waveform dump ----
        $dumpfile("tb_dut.vcd");
        $dumpvars(0, tb_dut);

        // ---- Initialize ----
        sreset_n   = 0;
        data_valid = 0;
        pixel_in   = 0;
        errors     = 0;

        // ---- Reset (5 cycles) ----
        repeat (5) @(posedge clock);
        sreset_n = 1;
        @(posedge clock);

        $display("========================================");
        $display(" SIMPLE DEMO — CKAN Model DUT");
        $display("========================================");
        $display(" Image:  {img_h}x{img_w} = {img_h * img_w} pixels, all = 1");
        $display(" LUTs:   all entries = +1");
        $display("----------------------------------------");
        $display(" Expected outputs:");
        $display("   L1 pool: ch0={l1_expected_val}, ch1={l1_expected_val}   ({l1_pool_count} outputs)");
"""
    if num_layers >= 2:
        tb += f"""        $display("   L2 pool: ch0={l2_expected_val}, ch1={l2_expected_val} ({l2_pool_count} outputs)");
"""
    tb += f"""        $display("   Flat:    1 output");
        $display("========================================");

        // ---- Feed {img_h * img_w} pixels (all = 1) ----
        for (px = 0; px < TOTAL_PX; px = px + 1) begin
            @(posedge clock);
            data_valid = 1;
            pixel_in   = {dut_data_in_width}'d1;
        end

        // ---- De-assert valid ----
        @(posedge clock);
        data_valid = 0;
        pixel_in   = 0;

        // ---- Wait for pipeline to flush ----
        $display("\\n--- Waiting for pipeline to flush ---");
        repeat (500) @(posedge clock);

        // ---- Summary ----
        $display("\\n========================================");
        $display(" Simulation Complete");
        $display("----------------------------------------");
        $display(" L1 pool outputs: %0d  (expected %0d)", l1_pool_count, L1_POOL_EXPECTED);
"""
    if num_layers >= 2:
        tb += f"""        $display(" L2 pool outputs: %0d  (expected %0d)", l2_pool_count, L2_POOL_EXPECTED);
"""
    tb += f"""        $display(" Flat outputs:    %0d  (expected %0d)", flat_count, FLAT_EXPECTED);
        $display(" Errors:          %0d", errors);
        $display("----------------------------------------");
        if (errors == 0 && l1_pool_count == L1_POOL_EXPECTED &&
"""
    if num_layers >= 2:
        tb += "            l2_pool_count == L2_POOL_EXPECTED &&\n"
    tb += f"""            flat_count == FLAT_EXPECTED)
            $display(" STATUS: PASS");
        else
            $display(" STATUS: FAIL");
        $display("========================================");

        $finish;
    end

    //=====================================================
    // Timeout watchdog (3 ms — enough for {img_h * img_w} pixels)
    //=====================================================
    initial begin
        #3000000;
        $display("ERROR: Simulation timed out!");
        $finish;
    end

endmodule
"""
    
    tb_path = os.path.join(os.path.dirname(output_path), "tb_dut.v")
    with open(tb_path, 'w') as f:
        f.write(tb)
    print(f"✓ Generated {tb_path}")
    
    # =========================================================================
    # Generate summary
    # =========================================================================
    summary = {
        "num_layers": num_layers,
        "input": f"{img_h}\u00d7{img_w}\u00d7{layer_dims[0]['in_channels']}",
        "output_flat_width": flat_out_width,
        "output_elements": flat_size,
        "layers": [
            {
                f"layer_{i+1}": {
                    "input": f"{d['in_h']}\u00d7{d['in_w']}\u00d7{d['in_channels']}",
                    "conv_out": f"{d['conv_h']}\u00d7{d['conv_w']}\u00d7{d['out_channels']}",
                    "pool_out": f"{d['pool_h']}\u00d7{d['pool_w']}\u00d7{d['out_channels']}",
                    "mem_file": f"kan_lut_conv{i}.mem",
                }
            }
            for i, d in enumerate(layer_dims)
        ]
    }
    
    summary_path = output_path.replace(".v", "_summary.json")
    with open(summary_path, 'w') as f:
        json.dump(summary, f, indent=2)
    
    print(f"✓ Generated {summary_path}")
    
    return summary


def main():
    parser = argparse.ArgumentParser(description="Generate Verilog from Python config")
    parser.add_argument("--model_dir", required=True, help="Model directory with config.json")
    parser.add_argument("--output_dir", default="firmware/verilog", help="Output directory for .v files")
    args = parser.parse_args()
    
    # Load config
    config_path = os.path.join(args.model_dir, "config.json")
    if not os.path.exists(config_path):
        raise FileNotFoundError(f"Config not found: {config_path}")
    
    with open(config_path, 'r') as f:
        config = json.load(f)
    
    print(f"Loaded config from {config_path}")
    
    # Add pool params if not present (defaults)
    config.setdefault("pool_size", 2)
    config.setdefault("pool_stride", 2)
    
    # Generate Verilog
    output_path = os.path.join(args.output_dir, "CKAN_Model_Custom.v")
    summary = generate_ckan_model_verilog(config, output_path)
    
    print("\n📊 Architecture Summary:")
    print(f"   Input:  {summary['input']}")
    for layer_info in summary['layers']:
        for k, v in layer_info.items():
            print(f"   {k}: {v['input']} → conv → {v['conv_out']} → pool → {v['pool_out']}  [{v['mem_file']}]")
    print(f"   Flatten: {summary['output_elements']} elements × OUT_WIDTH = {summary['output_flat_width']}-bit output")


if __name__ == "__main__":
    main()
