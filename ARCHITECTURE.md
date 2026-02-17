# CKAN System Architecture — Complete Overview

## High-Level Data Flow

```
┌──────────────────────────────────────────────────────────────────┐
│                    TRAINING (Python)                              │
│  ────────────────────────────────────────────────────────────    │
│                                                                   │
│  Raw images → quantize → CKANConv2d → pool → flatten → KAN MLP   │
│                           ↑                                       │
│                   Uses KANLinear from Kanele                      │
│                   (B-spline computation)                          │
│                                                                   │
│  Output: config.json + trained_model.pt                          │
└──────────────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────────────┐
│                 EXPORT (Python → Hardware)                        │
│  ────────────────────────────────────────────────────────────    │
│                                                                   │
│  Trained splines → evaluate at all quantized inputs → .mem files │
│                                                                   │
│  Output: kan_lut_conv*.mem, mlp_lut_*.mem, conv*_meta.json       │
└──────────────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────────────┐
│            VERILOG GENERATION (Python → Verilog)                  │
│  ────────────────────────────────────────────────────────────    │
│                                                                   │
│  config.json → calculate dimensions → generate CKAN_Model.v      │
│                                                                   │
│  Output: CKAN_Model_Custom.v (parameterized top module)          │
└──────────────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────────────┐
│                  HARDWARE (Verilog → FPGA)                        │
│  ────────────────────────────────────────────────────────────    │
│                                                                   │
│  Pixel stream → CKAN_Layer 1 → CKAN_Layer 2 → Flatten            │
│                     ↓               ↓                             │
│                 Conv + Pool     Conv + Pool                       │
│                     ↓               ↓                             │
│                 KAN_LUT_ROM     KAN_LUT_ROM                       │
│                 (kan_lut_conv0.mem) (kan_lut_conv1.mem)          │
│                                                                   │
│  Flattened vector → Kanele MLP (VHDL) → class logits             │
│                        ↓                                          │
│                    KAN LUT ROMs                                   │
│                    (mlp_lut_*.mem)                                │
│                                                                   │
│  Output: Bitstream for FPGA                                      │
└──────────────────────────────────────────────────────────────────┘
```

## Component Relationships

### Python Layer (Training & Export)

```
CKANConv2d.py
├─ forward():  unfold → KANLinear.forward() → fold
└─ Uses:       KANQuant.KANLinear (B-splines, quantization, pruning)

CKAN_Model.py
├─ CKANConv2d × N layers
├─ Flatten (torch.flatten)
└─ KANLinear × M MLP layers

CKAN_Export.py
├─ export_ckan_conv(): evaluate splines → kan_lut_conv*.mem
└─ export_mlp():       evaluate splines → mlp_lut_*.mem

generate_verilog.py
├─ Read config.json
├─ Calculate spatial dimensions
└─ Generate CKAN_Model_Custom.v
```

### Verilog Layer (Hardware)

```
CKAN_Model_Custom.v (auto-generated)
├─ CKAN_Layer #(...) layer1
├─ CKAN_Layer #(...) layer2
└─ Flatten #(...) flatten_inst

CKAN_Layer.v
├─ Conv2D_KAN #(...) conv_layer
│   ├─ ImageBufferChnl (sliding window)
│   └─ ConvolChnl_KAN
│       └─ Conv_MIC_KAN × Cout
│           └─ Conv_SIC_KAN × Cin
│               └─ KAN_LUT_ROM (trained splines)
└─ MaxPool2D #(...) pool_layer
    ├─ ImageBufferChnl (reused for pool windows)
    └─ MaxPooling × Channels

Flatten.v
└─ Register file → parallel output bus
```

---

## File Mapping: Python ↔ Verilog

| Python Concept | Python File | Verilog Module | Hardware Function |
|---|---|---|---|
| `nn.Unfold` | CKANConv2d.py | `ImageBufferChnl` | Extract KxK windows |
| `KANLinear` | KANQuant.py | `Conv_SIC_KAN` | Apply B-spline per pixel |
| B-spline weight | `spline_weight` tensor | `KAN_LUT_ROM` | ROM with .mem file |
| MaxPool2d | (torch.nn functional) | `MaxPool2D` | Max over PxP window |
| Flatten | `torch.flatten` | `Flatten` | Collect spatial → vector |
| Output quantizer | `QuantBrevitasActivation` | `OUT_WIDTH` register | Truncate/saturate |

---

## Parameter Flow

```
train_ckan.py
    config = {
        "conv_layers": [
            {"in_channels": 1, "out_channels": 2, "kernel_size": 3, ...}
        ]
    }
    ↓ (saved during training)
config.json
    ↓ (read by generator)
generate_verilog.py
    L1_INPUT_CHANNELS  = 1
    L1_OUTPUT_CHANNELS = 2
    KERNEL_SIZE        = 3
    ↓ (written to .v file)
CKAN_Model_Custom.v
    parameter L1_INPUT_CHANNELS  = 1;
    parameter L1_OUTPUT_CHANNELS = 2;
    parameter KERNEL_SIZE        = 3;
    ↓ (synthesized by Vivado)
FPGA bitstream
```

**Zero manual parameter editing required!**

---

## Memory (LUT) Format

Python evaluation:
```python
# For function_id=12, evaluate B-spline at all 256 input values:
input_values = [0, 1, 2, ..., 255]  # 8-bit quantized
lut_values = [spline(v) for v in input_values]  # evaluate learned spline
lut_hex = [f"{int(v):02X}" for v in lut_values]  # quantize to hex
```

Verilog ROM:
```verilog
// kan_lut_conv0.mem:
// Address = {function_id, input_value}
03  ← function 0, input 0
F2  ← function 0, input 1
...
1A  ← function 0, input 255
05  ← function 1, input 0
...

// Runtime lookup:
assign lut_out = rom[{func_id, pixel_value}];  // O(1), no math
```

---

## CLI Workflow Summary

```bash
# 1. Train
cd experiments/ckan_mnist
python train_ckan.py
# → saves config.json, checkpoints

# 2. Export
python convert_ckan.py
# → generates .mem files in firmware/mem/

# 3. Generate Verilog
python ../../src/generate_verilog.py \
    --model_dir models/20250218_033000 \
    --output_dir firmware/verilog
# → creates CKAN_Model_Custom.v

# 4. Synthesize
cd firmware/verilog
vivado -mode batch -source ../../src/templates/vivado/build_full.tcl
# → generates bitstream

# Done! Deploy to FPGA.
```

No manual Verilog editing. Config-driven end-to-end.
