"""
CKAN_Export — Export trained CKAN model to hardware files.

Generates:
  1. kan_lut_trained.mem  — Single .mem file for the Verilog KAN_LUT_ROM
     containing all Cout×Cin×K×K learned B-spline functions for the
     CKAN conv layer(s).  Addressed as {function_id, input_value}.

  2. MLP firmware         — Uses Kanele's KAN_LUT / KAN_LUT_MNIST to
     export the KAN MLP layers as VHDL + .mem files.

Function ordering in the CKAN .mem matches the Verilog addressing:
    function_id(out_ch, in_ch, pos) =
        out_ch * Cin * K² + in_ch * K² + pos

Each function block has 2^DATA_WIDTH entries (one per quantized input value).
"""

import os
import json
import torch
import torch.nn.functional as F
import numpy as np
from math import ceil, log2


class CKANExport:
    """Export a trained CKANModel to Verilog-compatible .mem files."""

    def __init__(self, model, config, device):
        """
        Args:
            model:  trained CKANModel instance (eval mode)
            config: the same config dict used for training
            device: 'cpu' or 'cuda'
        """
        self.model = model
        self.config = config
        self.device = device
        self.is_cuda = device == "cuda" if isinstance(device, str) else device.type == "cuda"
        self.model.eval()

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------
    def export_ckan_conv(self, output_dir, conv_layer_idx=0):
        """
        Export one CKANConv2d layer to a single .mem file for KAN_LUT_ROM.

        Args:
            output_dir:     directory to write the .mem file into
            conv_layer_idx: which conv layer to export (default 0)
        """
        os.makedirs(output_dir, exist_ok=True)
        conv = self.model.conv_layers[conv_layer_idx]
        kan = conv.kan  # the underlying KANLinear

        in_features = kan.in_features
        out_features = kan.out_features
        data_width = conv.in_precision
        value_width = conv.out_precision
        num_inputs = 1 << data_width  # 2^DATA_WIDTH

        # Get the quantized input state space
        if conv_layer_idx == 0:
            input_state_space = self.model.input_layer.get_state_space(self.is_cuda)
        else:
            prev_conv = self.model.conv_layers[conv_layer_idx - 1]
            input_state_space = prev_conv.kan.output_quantizer.get_state_space(self.is_cuda)

        input_state_space = input_state_space.to(self.device)

        # Get scale factor for quantizing outputs to integers
        scale, bits = kan.output_quantizer.get_scale_factor_bits(self.is_cuda)
        bin_state_space = kan.output_quantizer.get_bin_state_space(self.is_cuda).to(self.device)
        min_state = int(bin_state_space.min())
        max_state = int(bin_state_space.max())

        # Build x: [num_inputs, in_features] — replicate the input state space
        # for all input features (same values, tiled)
        x = input_state_space.unsqueeze(0).repeat(in_features, 1).T.to(self.device)

        # Evaluate B-spline bases
        spline_bases = kan.b_splines(x)  # [num_inputs, in_features, grid_size+order]

        # Total functions = out_features * in_features
        num_functions = out_features * in_features
        print(f"[CKAN Export] Conv layer {conv_layer_idx}: "
              f"{num_functions} functions, {num_inputs} entries each, "
              f"{data_width}-bit input, {value_width}-bit output")

        # Build truth table for every (out_ch, in_idx) pair
        # Ordering: function_id = out_ch * in_features + in_idx
        mem_lines = []
        for func_id in range(num_functions):
            out_ch = func_id // in_features
            in_idx = func_id % in_features

            # Evaluate the learned function for this edge
            base_out = kan.base_activation(x)[:, in_idx] * kan.base_weight[out_ch, in_idx]
            spline_out = F.linear(
                spline_bases[:, in_idx, :],
                kan.scaled_spline_weight[out_ch, in_idx, :],
            )
            combined = kan.spline_selector[out_ch, in_idx] * (base_out + spline_out)

            # Quantize to integer
            lut_values = (combined / scale).round().to(torch.int).tolist()
            lut_values = np.clip(lut_values, min_state, max_state).tolist()

            # Convert to hex
            for v in lut_values:
                mem_lines.append(self._int_to_hex(v, value_width))

        # Write single .mem file
        mem_path = os.path.join(output_dir, f"kan_lut_conv{conv_layer_idx}.mem")
        with open(mem_path, "w") as f:
            f.write("\n".join(mem_lines))

        print(f"[CKAN Export] Wrote {mem_path} "
              f"({len(mem_lines)} entries, {num_functions} functions)")

        # Write metadata for Verilog parameterisation
        meta = {
            "conv_layer_idx": conv_layer_idx,
            "kernel_size": conv.kernel_size,
            "in_channels": conv.in_channels,
            "out_channels": conv.out_channels,
            "stride": conv.stride,
            "data_width": data_width,
            "value_width": value_width,
            "num_functions": num_functions,
            "num_entries_per_function": num_inputs,
            "func_bits": int(ceil(log2(num_functions))) if num_functions > 1 else 1,
        }
        meta_path = os.path.join(output_dir, f"conv{conv_layer_idx}_meta.json")
        with open(meta_path, "w") as f:
            json.dump(meta, f, indent=2)
        print(f"[CKAN Export] Wrote {meta_path}")

        return meta

    def export_mlp_firmware(self, clock_period=1.2, n_add=4, fpga_part="xcvu9p-flgb2104-2-i", latency=8):
        """
        Export the complete MLP firmware using Kanele's KAN_LUT infrastructure.
        
        This generates:
        - VHDL source files (KAN.vhd, PkgKAN.vhd, PkgLUT.vhd, LUT_*.vhd)
        - .mem files for LUT initialization
        - Vivado build scripts (.tcl)
        - Simulation testbenches (optional)
        
        Uses KAN_LUT.generate_firmware() which handles everything automatically.
        
        Args:
            clock_period: target clock period in ns (for timing constraints)
            n_add: adder tree configuration
            fpga_part: target FPGA part number
            latency: pipeline latency for simulation
        """
        from KAN_LUT import KAN_LUT
        
        print("[CKAN Export] Generating MLP firmware using Kanele's KAN_LUT...")
        
        # Build config for KAN_LUT (MLP-only portion)
        mlp_config = {
            "layers": self.config["mlp_layers"],
            "layers_bitwidth": self.config["mlp_bitwidth"],
            "grid_size": self.config["grid_size"],
            "spline_order": self.config["spline_order"],
            "grid_eps": self.config["grid_eps"],
            "grid_range": self.config["grid_range"],
            "base_activation": self.config["base_activation"],
        }
        
        # Create checkpoint with MLP state
        mlp_checkpoint = {"model_state_dict": {}}
        for i, mlp_layer in enumerate(self.model.mlp_layers):
            for key, value in mlp_layer.state_dict().items():
                mlp_checkpoint["model_state_dict"][f"layers.{i}.{key}"] = value
        
        # Rebuild the input layer for MLP
        # (first MLP layer input comes from the flattened conv output)
        last_conv = self.model.conv_layers[-1]
        mlp_input_quantizer = last_conv.kan.output_quantizer
        
        # Create temporary directory for KAN_LUT (it expects a model_dir structure)
        import tempfile
        import shutil
        
        with tempfile.TemporaryDirectory() as tmp_dir:
            # KAN_LUT writes to tmp_dir/firmware/
            kan_lut = KAN_LUT(
                model_dir=tmp_dir,
                checkpoint=mlp_checkpoint,
                config=mlp_config,
                input_layer=mlp_input_quantizer,
                device=self.device
            )
            
            # Generate complete firmware (VHDL + .mem + TCL + optional sim)
            kan_lut.generate_firmware(
                clock_period=clock_period,
                n_add=n_add,
                fpga_part=fpga_part,
                latency=latency
            )
            
            # Copy generated firmware to our output location
            src_firmware = os.path.join(tmp_dir, "firmware")
            dst_firmware = os.path.join(os.path.dirname(self.model.conv_layers[0].kan.state_dict().__repr__()), "..", "mlp_firmware")
            
            # Better: use a fixed output path
            if hasattr(self, 'output_dir'):
                dst_firmware = os.path.join(self.output_dir, "mlp_firmware")
            
            if os.path.exists(src_firmware):
                shutil.copytree(src_firmware, dst_firmware, dirs_exist_ok=True)
                print(f"[CKAN Export] ✓ MLP firmware copied to {dst_firmware}")
                print(f"[CKAN Export]   Contains: VHDL sources, .mem files, Vivado scripts")
            else:
                print(f"[CKAN Export] ⚠ Warning: firmware directory not found")
        
        return dst_firmware

    # ------------------------------------------------------------------
    # Helpers
    # ------------------------------------------------------------------
    @staticmethod
    def _int_to_hex(value: int, bits: int) -> str:
        lo = -(1 << (bits - 1))
        hi = (1 << (bits - 1)) - 1
        v = min(max(value, lo), hi)
        mask = (1 << bits) - 1
        return f"{v & mask:0{(bits + 3) // 4}X}"
