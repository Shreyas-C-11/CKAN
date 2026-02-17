"""
generate_verilog.py — Auto-generate Verilog top module from Python config

Reads config.json from a trained model directory and generates:
  1. CKAN_Model_Custom.v — parameterized top module matching your exact config
  2. Sets all Verilog parameters based on Python layer definitions

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
    
    # Final flatten size
    last_layer = layer_dims[-1]
    flat_size = last_layer["pool_h"] * last_layer["pool_w"] * last_layer["out_channels"]
    out_width = conv_layers[-1]["out_precision"]
    flat_out_width = flat_size * out_width
    
    # Generate Verilog
    verilog = f"""//=====================================================
// Module: CKAN_Model_Custom
// Description:
//   Auto-generated from config.json
//   {num_layers}-layer CKAN CNN model
//   Generated for: {img_h}×{img_w} input
//=====================================================

module CKAN_Model_Custom #(
    // ---------------- Image Parameters ----------------
    parameter IMG_WIDTH        = {img_w},
    parameter IMG_HEIGHT       = {img_h},

    // ---------------- Shared Conv Parameters ----------------
    parameter KERNEL_SIZE      = {conv_layers[0]['kernel_size']},
    parameter CONV_STRIDE      = {conv_layers[0].get('stride', 1)},

"""
    
    # Layer-specific parameters
    for i, dims in enumerate(layer_dims):
        idx = i + 1
        verilog += f"""    // ---------------- Layer {idx} Parameters ----------------
    parameter L{idx}_INPUT_CHANNELS  = {dims['in_channels']},
    parameter L{idx}_OUTPUT_CHANNELS = {dims['out_channels']},
    parameter L{idx}_DATA_WIDTH      = {dims['data_width']},
"""
    
    verilog += f"""
    // ---------------- Shared CKAN Parameters ----------------
    parameter VALUE_WIDTH      = {conv_layers[0]['out_precision']},
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
    output wire [L{idx}_OUTPUT_CHANNELS*OUT_WIDTH-1:0]  l{idx}_pool_out,
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
        verilog += f"""    wire [L{idx}_OUTPUT_CHANNELS*OUT_WIDTH-1:0] l{idx}_conv_out;
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
        .KERNEL_SIZE     (KERNEL_SIZE),
        .IMG_WIDTH       ({in_w}),
        .IMG_HEIGHT      ({in_h}),
        .CONV_STRIDE     (CONV_STRIDE),
        .INPUT_CHANNELS  (L{idx}_INPUT_CHANNELS),
        .OUTPUT_CHANNELS (L{idx}_OUTPUT_CHANNELS),
        .DATA_WIDTH      (L{idx}_DATA_WIDTH),
        .VALUE_WIDTH     (VALUE_WIDTH),
        .OUT_WIDTH       (OUT_WIDTH),
        .POOL_SIZE       (POOL_SIZE),
        .POOL_STRIDE     (POOL_STRIDE),
        .SIGNED_DATA     (SIGNED_DATA)
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
"""
    
    # Write to file
    os.makedirs(os.path.dirname(output_path) if os.path.dirname(output_path) else ".", exist_ok=True)
    with open(output_path, 'w') as f:
        f.write(verilog)
    
    print(f"✓ Generated {output_path}")
    
    # Also generate a summary
    summary = {
        "num_layers": num_layers,
        "input": f"{img_h}×{img_w}×{layer_dims[0]['in_channels']}",
        "output_flat_width": flat_out_width,
        "output_elements": flat_size,
        "layers": [
            {
                f"layer_{i+1}": {
                    "input": f"{d['in_h']}×{d['in_w']}×{d['in_channels']}",
                    "conv_out": f"{d['conv_h']}×{d['conv_w']}×{d['out_channels']}",
                    "pool_out": f"{d['pool_h']}×{d['pool_w']}×{d['out_channels']}",
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
    parser.add_argument("--output_dir", default="firmware/verilog", help="Output directory for .v file")
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
            print(f"   {k}: {v['input']} → conv → {v['conv_out']} → pool → {v['pool_out']}")
    print(f"   Flatten: {summary['output_elements']} elements × OUT_WIDTH = {summary['output_flat_width']}-bit output")


if __name__ == "__main__":
    main()
