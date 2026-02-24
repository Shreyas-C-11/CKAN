# convert_ckan.py — Convert a trained CKAN model to Verilog .mem files
#
# Usage:  python convert_ckan.py
#
# Generates:
#   1. kan_lut_conv0.mem   — CKAN conv splines for Conv2D_KAN Verilog
#   2. mlp_lut_*.mem       — MLP connection LUTs for Kanele VHDL IP
#   3. conv0_meta.json     — Verilog parameters for the conv layer

import os, sys, json
import torch
import torch.nn as nn

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
    model_dir = os.path.join(models_root, subdirs[-1])  # latest by name (timestamp)
    print(f"Found run directory: {model_dir}")
else:
    model_dir = models_root  # fallback to models/ itself

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
bn_in = nn.BatchNorm1d(3 * 32 * 32)
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

# ─── Export ───────────────────────────────────────────────────────────
firmware_dir = os.path.join(model_dir, 'firmware')
exporter = CKANExport(model, config, device)
exporter.output_dir = firmware_dir  # Set output directory for MLP firmware

with torch.inference_mode():
    # 1. Export CKAN conv layer(s) → single .mem per layer + metadata
    for i in range(len(model.conv_layers)):
        exporter.export_ckan_conv(
            output_dir=os.path.join(firmware_dir, 'mem'),
            conv_layer_idx=i,
        )

    # 2. Export MLP layers → complete VHDL firmware (VHDL + .mem + TCL)
    mlp_fw_dir = exporter.export_mlp_firmware(
        clock_period=10.0,     # 100 MHz — PYNQ Z2 fabric clock
        n_add=4,               # adder tree config
        fpga_part="xc7z020clg400-1",  # Zynq-7020 (PYNQ Z2)
        latency=4              # pipeline depth (smaller model)
    )

print(f"\n✓ All firmware files generated:")
print(f"  CKAN Conv: {firmware_dir}/mem/  → kan_lut_conv*.mem + conv*_meta.json")
print(f"  MLP VHDL:  {mlp_fw_dir}/        → complete Kanele IP (VHDL+mem+TCL)")
print(f"\nNext steps:")
print(f"  1. Use generate_verilog.py to create CKAN_Model_Custom.v")
print(f"  2. Wire CKAN_Model_Custom.flat_out → MLP KAN.vhd input")
print(f"  3. Synthesize with Vivado")

