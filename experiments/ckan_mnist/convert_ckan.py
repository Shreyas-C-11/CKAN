# -*- coding: utf-8 -*-
# convert_ckan.py — Convert a trained CKAN model to optimised split-ROM Verilog
#
# Usage:  python convert_ckan.py
#
# Generates (Approach B — inline ROM values, NO .mem files):
#   firmware/verilog/     → full optimised Verilog hierarchy
#
# ROM data is hardcoded directly as localparam init strings inside each
# Conv_SIC module, eliminating ALL .mem files and $readmemh calls.
# This prevents Vivado project manager crashes from 100K+ file handles.

import os, sys, json, shutil
import torch
import torch.nn as nn
from math import ceil, log2

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', 'src'))

from CKAN_Model import CKANModel
from CKAN_Export import CKANExport
from quant import QuantBrevitasActivation, ScalarBiasScale

from brevitas.nn import QuantHardTanh
from brevitas.core.scaling import ParameterScaling
from brevitas.core.quant import QuantType

device = "cuda" if torch.cuda.is_available() else "cpu"

# ─── Find best checkpoint ────────────────────────────────────────────
models_root = "models/"

# Auto-discover latest run directory (e.g., models/20260220_150404/)
subdirs = sorted([d for d in os.listdir(models_root)
                  if os.path.isdir(os.path.join(models_root, d))])
if subdirs:
    model_dir = os.path.join(models_root, subdirs[-1])
    print(f"Found run directory: {model_dir}")
else:
    model_dir = models_root
    
# Auto-pick best accuracy checkpoint
files = [f for f in os.listdir(model_dir) if f.endswith('.pt')]
if not files:
    raise FileNotFoundError(f"No checkpoints in '{model_dir}'")
files.sort(key=lambda x: float(x.split('_acc')[1].split('_epoch')[0]),
           reverse=True)
best_ckpt = os.path.join(model_dir, files[0])
print(f"Using checkpoint: {best_ckpt}")

# ─── Load config ─────────────────────────────────────────────────────
with open(os.path.join(model_dir, 'config.json'), 'r') as f:
    config = json.load(f)

checkpoint = torch.load(best_ckpt, map_location=device)

# ─── Rebuild input layer ─────────────────────────────────────────────
img_h = config["image_height"]
img_w = config["image_width"]
in_channels = config["conv_layers"][0]["in_channels"]
bn_flat_dim = in_channels * img_h * img_w

bn_in = nn.BatchNorm1d(bn_flat_dim)
nn.init.constant_(bn_in.weight.data, 1)
nn.init.constant_(bn_in.bias.data, 0)
input_bias = ScalarBiasScale(scale=False, bias_init=-0.25)

input_layer = QuantBrevitasActivation(
    QuantHardTanh(
        bit_width=config["input_bitwidth"],
        max_val=1.0, min_val=-1.0,
        act_scaling_impl=ParameterScaling(1.33),
        quant_type=QuantType.INT,
        return_quant_tensor=False,
    ),
    pre_transforms=[bn_in, input_bias],
).to(device)

# ─── Rebuild & load model ────────────────────────────────────────────
model = CKANModel(config, input_layer, device).to(device)
model.load_state_dict(checkpoint['model_state_dict'])
model.eval()

if 'val_accuracy' in checkpoint:
    print(f"Loaded model — val_acc: {checkpoint['val_accuracy']:.4f}, "
          f"remaining: {checkpoint.get('remaining_fraction', 'N/A')}")

# ─── Output directories ──────────────────────────────────────────────
firmware_dir = os.path.join(model_dir, 'firmware')
verilog_dir = os.path.join(firmware_dir, 'verilog')

os.makedirs(verilog_dir, exist_ok=True)

# ─── Export ───────────────────────────────────────────────────────────
exporter = CKANExport(model, config, device)
exporter.output_dir = firmware_dir


def int_to_hex(value, bits):
    """Convert signed int to hex string for .mem file."""
    lo = -(1 << (bits - 1))
    hi = (1 << (bits - 1)) - 1
    v = min(max(value, lo), hi)
    mask = (1 << bits) - 1
    return f"{v & mask:0{(bits + 3) // 4}X}"


def calc_conv_out_size(in_size, kernel_size, stride):
    return (in_size - kernel_size) // stride + 1


def calc_pool_out_size(in_size, pool_size, pool_stride):
    return (in_size - pool_size) // pool_stride + 1


# =====================================================================
# STEP 1: Compute LUT values for all functions (store in memory)
# =====================================================================
print("\n" + "=" * 60)
print("STEP 1: Computing LUT values (inline — no .mem files)")
print("=" * 60)

layer_metas = []
# lut_data[layer_idx][(oc, ic, pix)] = list of int values
lut_data = {}

import numpy as np

with torch.inference_mode():
    for layer_idx in range(len(model.conv_layers)):
        conv = model.conv_layers[layer_idx]
        kan = conv.kan

        in_features = kan.in_features
        out_features = kan.out_features
        data_width = conv.in_precision
        value_width = conv.out_precision
        num_inputs = 1 << data_width

        k = conv.kernel_size
        cin = conv.in_channels
        cout = conv.out_channels

        # Get the quantized input state space
        if layer_idx == 0:
            input_state_space = model.input_layer.get_state_space(
                device == "cuda" if isinstance(device, str) else device.type == "cuda"
            )
        else:
            prev_conv = model.conv_layers[layer_idx - 1]
            input_state_space = prev_conv.kan.output_quantizer.get_state_space(
                device == "cuda" if isinstance(device, str) else device.type == "cuda"
            )

        input_state_space = input_state_space.to(device)

        # Get scale factor for quantizing outputs
        scale, bits = kan.output_quantizer.get_scale_factor_bits(
            device == "cuda" if isinstance(device, str) else device.type == "cuda"
        )
        bin_state_space = kan.output_quantizer.get_bin_state_space(
            device == "cuda" if isinstance(device, str) else device.type == "cuda"
        ).to(device)
        min_state = int(bin_state_space.min())
        max_state = int(bin_state_space.max())

        # Build x: [num_inputs, in_features]
        x = input_state_space.unsqueeze(0).repeat(in_features, 1).T.to(device)

        # Evaluate B-spline bases
        spline_bases = kan.b_splines(x)

        # Function ordering: func_id = out_ch * in_features + in_idx
        # where in_idx = in_ch * K² + pix_pos
        num_functions = out_features * in_features

        print(f"\n  Layer {layer_idx}: {cout}×{cin}×{k}×{k} = {num_functions} functions, "
              f"{num_inputs} entries each ({data_width}b→{value_width}b)")

        lut_data[layer_idx] = {}
        for func_id in range(num_functions):
            out_ch = func_id // in_features
            in_idx = func_id % in_features
            in_ch = in_idx // (k * k)
            pix = in_idx % (k * k)

            # Evaluate the learned function for this edge
            base_out = kan.base_activation(x)[:, in_idx] * kan.base_weight[out_ch, in_idx]
            spline_out = torch.matmul(
                spline_bases[:, in_idx, :],
                kan.scaled_spline_weight[out_ch, in_idx, :],
            )
            combined = kan.spline_selector[out_ch, in_idx] * (base_out + spline_out)

            # Quantize to integer
            lut_values = (combined / scale).round().to(torch.int).tolist()
            lut_values = np.clip(lut_values, min_state, max_state).tolist()

            lut_data[layer_idx][(out_ch, in_ch, pix)] = [int(v) for v in lut_values]

        meta = {
            "conv_layer_idx": layer_idx,
            "kernel_size": k,
            "in_channels": cin,
            "out_channels": cout,
            "stride": conv.stride,
            "data_width": data_width,
            "value_width": value_width,
            "num_functions": num_functions,
            "num_entries_per_function": num_inputs,
        }
        layer_metas.append(meta)

        print(f"  → {num_functions} LUT functions computed (inline, no .mem files)")


# =====================================================================
# STEP 2: Generate optimised Verilog (Approach A — unique SIC copies)
# =====================================================================
print("\n" + "=" * 60)
print("STEP 2: Generating optimised Verilog (Approach A)")
print("=" * 60)

conv_layers = config["conv_layers"]
num_layers = len(conv_layers)
pool_size = config.get("pool_size", 2)
pool_stride = config.get("pool_stride", 2)

# Calculate dimensions for each layer
layer_dims = []
curr_h, curr_w = img_h, img_w

for i, layer_cfg in enumerate(conv_layers):
    k = layer_cfg["kernel_size"]
    stride = layer_cfg.get("stride", 1)
    cin = layer_cfg["in_channels"]
    cout = layer_cfg["out_channels"]
    conv_h = calc_conv_out_size(curr_h, k, stride)
    conv_w = calc_conv_out_size(curr_w, k, stride)
    pool_h = calc_pool_out_size(conv_h, pool_size, pool_stride)
    pool_w = calc_pool_out_size(conv_w, pool_size, pool_stride)
    
    layer_dims.append({
        "idx": i,
        "in_channels": cin,
        "out_channels": cout,
        "kernel_size": k,
        "stride": stride,
        "in_h": curr_h, "in_w": curr_w,
        "conv_h": conv_h, "conv_w": conv_w,
        "pool_h": pool_h, "pool_w": pool_w,
        "data_width": layer_cfg["in_precision"],
        "value_width": layer_cfg["out_precision"],
    })
    curr_h, curr_w = pool_h, pool_w

last_layer = layer_dims[-1]
out_width = conv_layers[-1]["out_precision"]
flat_size = last_layer["pool_h"] * last_layer["pool_w"] * last_layer["out_channels"]
flat_out_width = flat_size * out_width


# ── 2a: (REMOVED — no .vh files needed, ROM data is inlined) ────────


def int_to_inithex(value, bits):
    """Convert signed int to hex string for Verilog init."""
    mask = (1 << bits) - 1
    return f"{value & mask:0{(bits + 3) // 4}X}"


# ── 2b: Generate unique Conv_SIC modules (Approach B — inline ROMs) ──
print("\n  Generating unique Conv_SIC modules (inline ROM data)...")

sic_count = 0
for layer_idx, dims in enumerate(layer_dims):
    k = dims["kernel_size"]
    cin = dims["in_channels"]
    cout = dims["out_channels"]
    dw = dims["data_width"]
    vw = dims["value_width"]
    N = k * k
    depth = 1 << dw

    for oc in range(cout):
        for ic in range(cin):
            module_name = f"Conv_SIC_l{layer_idx}_oc{oc}_ic{ic}"
            filepath = os.path.join(verilog_dir, f"{module_name}.v")

            grp_guard = max(ceil(log2(k)), 1) if k > 1 else 1
            grp_width = vw + grp_guard
            final_guard = grp_guard
            acc_width = grp_width + final_guard

            # Build inline ROM initialization strings for each pixel
            rom_init_blocks = []
            for pix in range(N):
                values = lut_data[layer_idx].get((oc, ic, pix), [0] * depth)
                # Build Verilog hex init string: mem[0]=val0, mem[1]=val1, ...
                hex_pairs = [int_to_inithex(v, vw) for v in values]
                rom_init_blocks.append(hex_pairs)

            with open(filepath, 'w') as f:
                f.write(f"""//=====================================================
// Module: {module_name}
// Auto-generated SIC for Layer {layer_idx}, OutCh {oc}, InCh {ic}
// {N} inline ROMs, {depth} entries × {vw}-bit each (NO .mem files)
//=====================================================
module {module_name} #(
    parameter KERNEL_SIZE = {k},
    parameter DATA_WIDTH  = {dw},
    parameter VALUE_WIDTH = {vw},
    parameter OUT_WIDTH   = {out_width}
)(
    input  wire clock,
    input  wire sreset_n,
    input  wire data_valid,
    input  wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_in,
    output reg  signed [OUT_WIDTH-1:0] conv_out,
    output reg                         conv_valid
);

    localparam N = KERNEL_SIZE * KERNEL_SIZE;
    localparam K = KERNEL_SIZE;
    localparam GRP_GUARD = {grp_guard};
    localparam GRP_WIDTH = VALUE_WIDTH + GRP_GUARD;
    localparam FINAL_GUARD = {final_guard};
    localparam ACC_WIDTH = GRP_WIDTH + FINAL_GUARD;

    // Unpack pixels
    wire [DATA_WIDTH-1:0] px [0:N-1];
    genvar gi;
    generate
        for (gi = 0; gi < N; gi = gi + 1)
            assign px[gi] = kernel_in[(gi+1)*DATA_WIDTH-1 -: DATA_WIDTH];
    endgenerate

    // Inline ROM LUT instances (data hardcoded — no .mem files)
    wire signed [VALUE_WIDTH-1:0] lut_out [0:N-1];

""")
                # Emit each ROM as a reg array with initial block
                for pix in range(N):
                    hex_pairs = rom_init_blocks[pix]
                    f.write(f"    // ROM for pixel {pix}\n")
                    f.write(f"    (* rom_style = \"distributed\" *)\n")
                    f.write(f"    reg signed [VALUE_WIDTH-1:0] rom_{pix} [0:{depth-1}];\n")
                    f.write(f"    assign lut_out[{pix}] = rom_{pix}[px[{pix}]];\n")
                    f.write(f"    initial begin\n")
                    for addr, hx in enumerate(hex_pairs):
                        f.write(f"        rom_{pix}[{addr}] = {vw}'h{hx};\n")
                    f.write(f"    end\n\n")

                f.write(f"""    // PIPELINE STAGE 1: Register LUT outputs
    reg signed [VALUE_WIDTH-1:0] lut_r [0:N-1];
    integer j;
    always @(posedge clock) begin
        if (!sreset_n)
            for (j = 0; j < N; j = j + 1)   lut_r[j] <= 0;
        else if (data_valid)
            for (j = 0; j < N; j = j + 1)   lut_r[j] <= lut_out[j];
    end

    // Group partial sums (COMBINATIONAL)
    reg signed [GRP_WIDTH-1:0] group_sum_comb [0:K-1];
    integer g, p;
    always @(*) begin
        for (g = 0; g < K; g = g + 1) begin
            group_sum_comb[g] = {{GRP_WIDTH{{1'b0}}}};
            for (p = 0; p < K; p = p + 1)
                group_sum_comb[g] = group_sum_comb[g] +
                    {{{{GRP_GUARD{{lut_r[g*K + p][VALUE_WIDTH-1]}}}}, lut_r[g*K + p]}};
        end
    end

    // PIPELINE STAGE 2: Register group sums
    reg signed [GRP_WIDTH-1:0] group_sum_r [0:K-1];
    always @(posedge clock) begin
        if (!sreset_n)
            for (g = 0; g < K; g = g + 1)   group_sum_r[g] <= 0;
        else
            for (g = 0; g < K; g = g + 1)   group_sum_r[g] <= group_sum_comb[g];
    end

    // Final sum (COMBINATIONAL)
    reg signed [ACC_WIDTH-1:0] final_sum;
    always @(*) begin
        final_sum = {{ACC_WIDTH{{1'b0}}}};
        for (g = 0; g < K; g = g + 1)
            final_sum = final_sum +
                {{{{FINAL_GUARD{{group_sum_r[g][GRP_WIDTH-1]}}}}, group_sum_r[g]}};
    end

    // Saturator
    localparam signed [ACC_WIDTH-1:0] SAT_MAX =
        {{{{(ACC_WIDTH-OUT_WIDTH+1){{1'b0}}}}, {{(OUT_WIDTH-1){{1'b1}}}}}};
    localparam signed [ACC_WIDTH-1:0] SAT_MIN =
        {{{{(ACC_WIDTH-OUT_WIDTH+1){{1'b1}}}}, {{(OUT_WIDTH-1){{1'b0}}}}}};

    wire signed [OUT_WIDTH-1:0] saturated;
    assign saturated = (final_sum > SAT_MAX) ? SAT_MAX[OUT_WIDTH-1:0] :
                       (final_sum < SAT_MIN) ? SAT_MIN[OUT_WIDTH-1:0] :
                       final_sum[OUT_WIDTH-1:0];

    // PIPELINE STAGE 3: Register output
    always @(posedge clock) begin
        if (!sreset_n)  conv_out <= 0;
        else            conv_out <= saturated;
    end

    // Valid pipeline (3 stages to match data path)
    reg [1:0] vpipe;
    always @(posedge clock) begin
        if (!sreset_n) begin
            vpipe      <= 2'b00;
            conv_valid <= 1'b0;
        end else begin
            vpipe      <= {{vpipe[0], data_valid}};
            conv_valid <= vpipe[1];
        end
    end

endmodule
""")
            sic_count += 1
            if sic_count % 500 == 0:
                print(f"    ... {sic_count} SIC modules generated")

print(f"    ✓ {sic_count} Conv_SIC modules generated (inline ROM data)")


# ── 2c: Generate Conv_MIC_opt modules (one per layer×out_ch) ─────────
print("\n  Generating Conv_MIC_opt modules...")

for layer_idx, dims in enumerate(layer_dims):
    k = dims["kernel_size"]
    cin = dims["in_channels"]
    cout = dims["out_channels"]
    dw = dims["data_width"]
    vw = dims["value_width"]
    N = k * k

    for oc in range(cout):
        module_name = f"Conv_MIC_l{layer_idx}_oc{oc}"
        filepath = os.path.join(verilog_dir, f"{module_name}.v")

        mic_acc_bits = max(ceil(log2(cin)), 1) if cin > 1 else 1

        with open(filepath, 'w') as f:
            f.write(f"""//=====================================================
// Module: {module_name}
// Auto-generated MIC for Layer {layer_idx}, OutCh {oc}
// {cin} SIC instances (one per input channel)
//=====================================================
module {module_name} #(
    parameter KERNEL_SIZE     = {k},
    parameter INPUT_CHANNELS  = {cin},
    parameter DATA_WIDTH      = {dw},
    parameter VALUE_WIDTH     = {vw},
    parameter OUT_WIDTH       = {out_width}
)(
    input  wire clock,
    input  wire sreset_n,
    input  wire data_valid,
    input  wire [INPUT_CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_in,
    output wire signed [OUT_WIDTH-1:0] conv_out,
    output wire                        conv_valid
);

    localparam N = KERNEL_SIZE * KERNEL_SIZE;
    wire signed [OUT_WIDTH-1:0] ch_out [0:{cin-1}];
    wire                        ch_valid [0:{cin-1}];

""")
            # Instantiate unique SIC modules per input channel
            for ic in range(cin):
                sic_name = f"Conv_SIC_l{layer_idx}_oc{oc}_ic{ic}"
                f.write(f"""    {sic_name} #(
        .KERNEL_SIZE (KERNEL_SIZE),
        .DATA_WIDTH  (DATA_WIDTH),
        .VALUE_WIDTH (VALUE_WIDTH),
        .OUT_WIDTH   (OUT_WIDTH)
    ) sic_{ic} (
        .clock      (clock),
        .sreset_n   (sreset_n),
        .data_valid (data_valid),
        .kernel_in  (kernel_in[({ic}+1)*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1 -:
                                KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH]),
        .conv_out   (ch_out[{ic}]),
        .conv_valid (ch_valid[{ic}])
    );

""")

            # Cross-channel accumulation
            f.write(f"""    // Cross-channel accumulation
    localparam MIC_ACC_BITS = {mic_acc_bits};
    localparam MIC_ACC_WIDTH = OUT_WIDTH + MIC_ACC_BITS;

    reg signed [MIC_ACC_WIDTH-1:0] sum_wide;
    integer j;
    always @(*) begin
        sum_wide = 0;
""")
            for ic in range(cin):
                f.write(f"        sum_wide = sum_wide + "
                        f"{{{{MIC_ACC_BITS{{ch_out[{ic}][OUT_WIDTH-1]}}}}, ch_out[{ic}]}};\n")

            f.write(f"""    end

    localparam signed [MIC_ACC_WIDTH-1:0] MIC_SAT_MAX =
        {{{{(MIC_ACC_BITS+1){{1'b0}}}}, {{(OUT_WIDTH-1){{1'b1}}}}}};
    localparam signed [MIC_ACC_WIDTH-1:0] MIC_SAT_MIN =
        {{{{(MIC_ACC_BITS+1){{1'b1}}}}, {{(OUT_WIDTH-1){{1'b0}}}}}};

    wire signed [OUT_WIDTH-1:0] sum_sat;
    assign sum_sat = (sum_wide > MIC_SAT_MAX) ? MIC_SAT_MAX[OUT_WIDTH-1:0] :
                     (sum_wide < MIC_SAT_MIN) ? MIC_SAT_MIN[OUT_WIDTH-1:0] :
                     sum_wide[OUT_WIDTH-1:0];

    assign conv_out = sum_sat;
    assign conv_valid = ch_valid[0];

endmodule
""")
        print(f"    ✓ {module_name}.v")


# ── 2d: Generate ConvolChnl_opt modules (one per layer) ──────────────
print("\n  Generating ConvolChnl_opt modules...")

for layer_idx, dims in enumerate(layer_dims):
    k = dims["kernel_size"]
    cin = dims["in_channels"]
    cout = dims["out_channels"]
    dw = dims["data_width"]
    vw = dims["value_width"]
    N = k * k
    
    module_name = f"ConvolChnl_l{layer_idx}"
    filepath = os.path.join(verilog_dir, f"{module_name}.v")
    
    with open(filepath, 'w') as f:
        f.write(f"""//=====================================================
// Module: {module_name}
// Auto-generated ConvolChnl for Layer {layer_idx}
// {cout} MIC instances (one per output channel)
//=====================================================
module {module_name} #(
    parameter KERNEL_SIZE     = {k},
    parameter INPUT_CHANNELS  = {cin},
    parameter OUTPUT_CHANNELS = {cout},
    parameter DATA_WIDTH      = {dw},
    parameter VALUE_WIDTH     = {vw},
    parameter OUT_WIDTH       = {out_width}
)(
    input  wire clock,
    input  wire sreset_n,
    input  wire data_valid,
    input  wire [INPUT_CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_in,
    output wire [OUTPUT_CHANNELS*OUT_WIDTH-1:0] conv_out,
    output wire conv_valid
);

    wire signed [OUT_WIDTH-1:0] ch_out [0:{cout-1}];
    wire                        ch_valid [0:{cout-1}];

""")
        for oc in range(cout):
            mic_name = f"Conv_MIC_l{layer_idx}_oc{oc}"
            f.write(f"""    {mic_name} #(
        .KERNEL_SIZE    (KERNEL_SIZE),
        .INPUT_CHANNELS (INPUT_CHANNELS),
        .DATA_WIDTH     (DATA_WIDTH),
        .VALUE_WIDTH    (VALUE_WIDTH),
        .OUT_WIDTH      (OUT_WIDTH)
    ) mic_{oc} (
        .clock      (clock),
        .sreset_n   (sreset_n),
        .data_valid (data_valid),
        .kernel_in  (kernel_in),
        .conv_out   (ch_out[{oc}]),
        .conv_valid (ch_valid[{oc}])
    );
    assign conv_out[({oc}+1)*OUT_WIDTH-1 -: OUT_WIDTH] = ch_out[{oc}];

""")

        f.write(f"""    assign conv_valid = ch_valid[0];

endmodule
""")
    print(f"    ✓ {module_name}.v")


# ── 2e: Generate CKAN_Model_Custom_opt.v (top-level) ─────────────────
print("\n  Generating top-level CKAN_Model_Custom_opt.v...")

top_path = os.path.join(verilog_dir, "CKAN_Model_Custom_opt.v")
with open(top_path, 'w') as f:
    f.write(f"""//=====================================================
// Module: CKAN_Model_Custom_opt
// Auto-generated optimised CKAN CNN ({num_layers}-layer)
// Split-ROM architecture (NO runtime func_base_id)
// Input: {img_h}×{img_w}×{layer_dims[0]['in_channels']}
//=====================================================
module CKAN_Model_Custom_opt #(
    parameter IMG_WIDTH  = {img_w},
    parameter IMG_HEIGHT = {img_h},
""")
    for i, dims in enumerate(layer_dims):
        idx = i + 1
        f.write(f"""
    // Layer {idx}
    parameter L{idx}_KERNEL_SIZE     = {dims['kernel_size']},
    parameter L{idx}_CONV_STRIDE     = {dims['stride']},
    parameter L{idx}_INPUT_CHANNELS  = {dims['in_channels']},
    parameter L{idx}_OUTPUT_CHANNELS = {dims['out_channels']},
    parameter L{idx}_DATA_WIDTH      = {dims['data_width']},
    parameter L{idx}_VALUE_WIDTH     = {dims['value_width']},
""")

    f.write(f"""
    // Shared
    parameter OUT_WIDTH   = {out_width},
    parameter POOL_SIZE   = {pool_size},
    parameter POOL_STRIDE = {pool_stride},
    parameter SIGNED_DATA = 1,
""")

    for i, dims in enumerate(layer_dims):
        idx = i + 1
        f.write(f"""    parameter L{idx}_CONV_OUT_W = {dims['conv_w']},
    parameter L{idx}_CONV_OUT_H = {dims['conv_h']},
    parameter L{idx}_POOL_OUT_W = {dims['pool_w']},
    parameter L{idx}_POOL_OUT_H = {dims['pool_h']},
""")

    f.write(f"""    parameter FLAT_OUT_WIDTH = {flat_out_width}
)(
    input  wire clock,
    input  wire sreset_n,
    input  wire data_valid,
    input  wire [L1_INPUT_CHANNELS*L1_DATA_WIDTH-1:0] data_in,
    output wire [FLAT_OUT_WIDTH-1:0] flat_out,
    output wire flat_valid
""")

    for i in range(num_layers):
        idx = i + 1
        f.write(f""",
    output wire [L{idx}_OUTPUT_CHANNELS*OUT_WIDTH-1:0] l{idx}_pool_out,
    output wire l{idx}_pool_valid""")

    f.write(f"""
);

""")

    # Internal signals
    for i in range(num_layers):
        idx = i + 1
        f.write(f"""    wire [L{idx}_OUTPUT_CHANNELS*OUT_WIDTH-1:0] l{idx}_conv_out;
    wire l{idx}_conv_valid;
""")

    # Layer instantiations
    for i, dims in enumerate(layer_dims):
        idx = i + 1
        convol_name = f"ConvolChnl_l{i}"

        if idx == 1:
            data_valid_src = "data_valid"
            data_in_src = "data_in"
            in_w = img_w
            in_h = img_h
        else:
            prev = idx - 1
            data_valid_src = f"l{prev}_pool_valid"
            data_in_src = f"l{prev}_pool_out"
            in_w = f"L{prev}_POOL_OUT_W"
            in_h = f"L{prev}_POOL_OUT_H"

        # Image buffer + ConvolChnl conv block
        f.write(f"""
    // ─── Layer {idx}: Conv + Pool ──────────────────────
    wire [L{idx}_INPUT_CHANNELS*L{idx}_KERNEL_SIZE*L{idx}_KERNEL_SIZE*L{idx}_DATA_WIDTH-1:0] l{idx}_kernel_window;
    wire l{idx}_kernel_valid;
    wire [L{idx}_INPUT_CHANNELS*L{idx}_DATA_WIDTH-1:0] l{idx}_buf_out;

    ImageBufferChnl #(
        .KERNEL_SIZE (L{idx}_KERNEL_SIZE),
        .DATA_WIDTH  (L{idx}_DATA_WIDTH),
        .COLUMN_NUM  ({in_w}),
        .ROW_NUM     ({in_h}),
        .STRIDE      (L{idx}_CONV_STRIDE),
        .CHANNELS    (L{idx}_INPUT_CHANNELS)
    ) l{idx}_imgbuf (
        .clock        (clock),
        .data_valid   ({data_valid_src}),
        .sreset_n     (sreset_n),
        .data_in      ({data_in_src}),
        .data_out     (l{idx}_buf_out),
        .kernel_out   (l{idx}_kernel_window),
        .kernel_valid (l{idx}_kernel_valid)
    );

    {convol_name} #(
        .KERNEL_SIZE     (L{idx}_KERNEL_SIZE),
        .INPUT_CHANNELS  (L{idx}_INPUT_CHANNELS),
        .OUTPUT_CHANNELS (L{idx}_OUTPUT_CHANNELS),
        .DATA_WIDTH      (L{idx}_DATA_WIDTH),
        .VALUE_WIDTH     (L{idx}_VALUE_WIDTH),
        .OUT_WIDTH       (OUT_WIDTH)
    ) l{idx}_conv (
        .clock      (clock),
        .sreset_n   (sreset_n),
        .data_valid (l{idx}_kernel_valid),
        .kernel_in  (l{idx}_kernel_window),
        .conv_out   (l{idx}_conv_out),
        .conv_valid (l{idx}_conv_valid)
    );

    MaxPool2D #(
        .POOL_SIZE   (POOL_SIZE),
        .POOL_STRIDE (POOL_STRIDE),
        .COLUMN_NUM  (L{idx}_CONV_OUT_W),
        .ROW_NUM     (L{idx}_CONV_OUT_H),
        .CHANNELS    (L{idx}_OUTPUT_CHANNELS),
        .DATA_WIDTH  (OUT_WIDTH),
        .SIGNED_DATA (SIGNED_DATA)
    ) l{idx}_pool (
        .clock      (clock),
        .sreset_n   (sreset_n),
        .data_valid (l{idx}_conv_valid),
        .data_in    (l{idx}_conv_out),
        .pool_out   (l{idx}_pool_out),
        .pool_valid (l{idx}_pool_valid)
    );
""")

    # Flatten
    last_idx = num_layers
    f.write(f"""
    // ─── Flatten ───────────────────────────────────────
    Flatten #(
        .CHANNELS   (L{last_idx}_OUTPUT_CHANNELS),
        .DATA_WIDTH (OUT_WIDTH),
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
""")

print(f"    ✓ CKAN_Model_Custom_opt.v")


# ── 2f: Copy shared RTL modules ──────────────────────────────────────
# NOTE: KAN_LUT_ROM_opt.v is NO LONGER needed — ROMs are inlined
print("\n  Copying shared RTL modules...")
rtl_root = os.path.join(os.path.dirname(__file__), '..', '..')
shared_modules = [
    "ImageBufferChnl.v",
    "ImageBuf_KernelSlider.v",
    "Line_Buffer.v",
    "Data_Buffer.v",
    "MaxPool2D.v",
    "MaxPooling.v",
    "Flatten.v",
]
for mod in shared_modules:
    src = os.path.join(rtl_root, mod)
    if os.path.exists(src):
        shutil.copy2(src, verilog_dir)
        print(f"    ✓ {mod}")
    else:
        print(f"    ⚠ {mod} not found at {src}")


# ── 2g: Write file manifest ──────────────────────────────────────────
manifest = {
    "architecture": "split_rom_approach_a",
    "description": "Optimised CKAN with per-function split ROMs (no runtime func_base_id)",
    "config": config,
    "layers": [],
}

total_roms = 0
total_lut6 = 0
for i, dims in enumerate(layer_dims):
    k = dims["kernel_size"]
    cin = dims["in_channels"]
    cout = dims["out_channels"]
    dw = dims["data_width"]
    vw = dims["value_width"]
    N = k * k
    n_roms = cout * cin * N
    n_lut6 = n_roms * vw  # 1 LUT6 per output bit
    total_roms += n_roms
    total_lut6 += n_lut6
    
    manifest["layers"].append({
        "layer": i,
        "input": f"{dims['in_h']}×{dims['in_w']}×{cin}",
        "output_conv": f"{dims['conv_h']}×{dims['conv_w']}×{cout}",
        "output_pool": f"{dims['pool_h']}×{dims['pool_w']}×{cout}",
        "rom_count": n_roms,
        "rom_depth": 1 << dw,
        "rom_width": vw,
        "estimated_lut6": n_lut6,
    })

manifest["total_roms"] = total_roms
manifest["total_lut6_rom_only"] = total_lut6
manifest["flat_output_bits"] = flat_out_width

manifest_path = os.path.join(verilog_dir, "build_manifest.json")
with open(manifest_path, "w") as f:
    json.dump(manifest, f, indent=2)
print(f"\n    ✓ build_manifest.json")


# =====================================================================
# STEP 3: Export MLP firmware (unchanged — uses Kanele VHDL IP)
# =====================================================================
print("\n" + "=" * 60)
print("STEP 3: Exporting MLP firmware")
print("=" * 60)

with torch.inference_mode():
    mlp_fw_dir = exporter.export_mlp_firmware(
        clock_period=10.0,
        n_add=4,
        fpga_part="xc7z020clg400-1",
        latency=8
    )

# =====================================================================
# Summary
# =====================================================================
print("\n" + "=" * 60)
print("✓ ALL FIRMWARE GENERATED")
print("=" * 60)
print(f"  Optimised Verilog: {verilog_dir}/")
print(f"  MLP VHDL:          {mlp_fw_dir}/")
print(f"")
print(f"  Total ROMs:        {total_roms} (values hardcoded in Verilog)")
print(f"  Estimated LUT6:    {total_lut6} (ROM only)")
print(f"  Flat output:       {flat_out_width} bits")
print(f"")
print(f"  Architecture: Inline ROM (NO .mem files, NO .vh files)")
print(f"  → ROM data is hardcoded inside each Conv_SIC module")
print(f"  → NO $readmemh calls — Vivado won't crash")
print(f"  → Pruned (all-zero) ROMs will be optimized away by synthesis")
print(f"")
print(f"Next steps:")
print(f"  1. Copy verilog/ folder to your Vivado project")
print(f"  2. Add all .v files to the sources")
print(f"  3. Wire CKAN_Model_Custom_opt.flat_out → MLP KAN.vhd input")
print(f"  4. Synthesize!")
