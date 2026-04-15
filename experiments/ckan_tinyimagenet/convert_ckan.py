# -*- coding: utf-8 -*-
# convert_ckan.py — Convert a trained CKAN model to optimised split-ROM Verilog
#
# Usage:  python convert_ckan.py
#
# This follows the same export flow as the existing experiment folders.

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
models_root = "models/"

subdirs = sorted([
    d for d in os.listdir(models_root)
    if os.path.isdir(os.path.join(models_root, d))
])
if subdirs:
    model_dir = os.path.join(models_root, subdirs[-1])
    print(f"Found run directory: {model_dir}")
else:
    model_dir = models_root

files = [f for f in os.listdir(model_dir) if f.endswith('.pt')]
if not files:
    raise FileNotFoundError(f"No checkpoints in '{model_dir}'")
files.sort(key=lambda x: float(x.split('_acc')[1].split('_epoch')[0]), reverse=True)
best_ckpt = os.path.join(model_dir, files[0])
print(f"Using checkpoint: {best_ckpt}")

with open(os.path.join(model_dir, 'config.json'), 'r') as f:
    config = json.load(f)

checkpoint = torch.load(best_ckpt, map_location=device)

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

model = CKANModel(config, input_layer, device).to(device)
model.load_state_dict(checkpoint['model_state_dict'])
model.eval()

if 'val_accuracy' in checkpoint:
    print(f"Loaded model — val_acc: {checkpoint['val_accuracy']:.4f}")

firmware_dir = os.path.join(model_dir, 'firmware')
verilog_dir = os.path.join(firmware_dir, 'verilog')
os.makedirs(verilog_dir, exist_ok=True)

exporter = CKANExport(model, config, device)
exporter.output_dir = firmware_dir
exporter.export()

print(f"Export complete: {firmware_dir}")
