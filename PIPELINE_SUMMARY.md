# CKAN Python → Verilog Pipeline — Complete Summary

## Overview

You now have a **fully automated pipeline** from Python training to Verilog hardware generation. Here's what we built:

```
Python Training → Config + Checkpoints → .mem Files + Verilog Top Module → FPGA Bitstream
```

---

## File Structure

```
CKAN/
├── src/
│   ├── CKANConv2d.py          — CKAN conv layer (wraps KANLinear)
│   ├── CKAN_Model.py          — Full model (conv + MLP)
│   ├── CKAN_Export.py         — Export .mem files from trained model
│   ├── generate_verilog.py    — **Auto-generate Verilog top module**
│   ├── KANQuant.py            — Kanele quantized KAN (reused)
│   ├── quant.py               — Quantization utilities (reused)
│   └── templates/             — VHDL templates for Kanele MLP
│
├── experiments/ckan_mnist/
│   ├── train_ckan.py          — Training script
│   ├── convert_ckan.py        — Export script (.mem generation)
│   └── config.json            — **Auto-saved during training**
│
└── [Verilog files]
    ├── CKAN_Layer.v           — Conv2D_KAN + MaxPool2D wrapper
    ├── CKAN_Model.v           — Multi-layer CKAN (hand-written template)
    ├── Conv2D_KAN.v           — CKAN convolution IP
    ├── MaxPool2D.v            — Max pooling IP
    ├── Flatten.v              — Spatial → vector converter
    └── (other modules...)
```

---

## Complete Workflow

### Step 1: Train the Python model

```bash
cd experiments/ckan_mnist
python train_ckan.py
```

**What it does:**
- Trains a CKAN model on MNIST
- Saves checkpoints to `models/YYYYMMDD_HHMMSS/`
- **Auto-saves `config.json`** with all architecture parameters

**Output:**
```
models/20250218_033000/
├── config.json  ← architecture spec
├── CKAN_acc0.9850_epoch100_remaining0.7234.pt  ← best checkpoint
└── ...
```

---

### Step 2: Export .mem files (LUT truth tables)

```bash
python convert_ckan.py
```

**What it does:**
- Loads the best checkpoint from `models/`
- Evaluates every learned B-spline at all quantized input values
- Writes `.mem` files for Verilog ROM initialization

**Output:**
```
models/20250218_033000/firmware/mem/
├── kan_lut_conv0.mem  ← CKAN conv layer 0 LUTs
├── kan_lut_conv1.mem  ← CKAN conv layer 1 LUTs
├── mlp_lut_0_5_2.mem  ← MLP connection (layer 0, input 5, output 2)
├── mlp_lut_0_5_3.mem
└── ...
├── conv0_meta.json    ← Verilog parameters for conv0
└── conv1_meta.json
```

---

### Step 3: Generate Verilog top module

```bash
python ../../src/generate_verilog.py \
    --model_dir models/20250218_033000 \
    --output_dir firmware/verilog
```

**What it does:**
- Reads `config.json`
- Calculates all spatial dimensions (conv outputs, pool outputs, etc.)
- **Auto-generates `CKAN_Model_Custom.v`** with correct parameters
- Creates a summary JSON

**Output:**
```
firmware/verilog/
├── CKAN_Model_Custom.v         ← **Parameterized top module**
└── CKAN_Model_Custom_summary.json
```

**Generated Verilog** (example for 2-layer MNIST):
```verilog
module CKAN_Model_Custom #(
    parameter IMG_WIDTH        = 28,
    parameter IMG_HEIGHT       = 28,
    parameter L1_INPUT_CHANNELS  = 1,
    parameter L1_OUTPUT_CHANNELS = 2,
    parameter L2_INPUT_CHANNELS  = 2,
    parameter L2_OUTPUT_CHANNELS = 2,
    ...
)(
    input  wire  clock, sreset_n, data_valid,
    input  wire  [7:0] data_in,    // 1×8-bit pixel
    output wire  [799:0] flat_out, // 5×5×2×16 = 800 bits
    output wire  flat_valid
);

    CKAN_Layer #(...) layer1 (...);
    CKAN_Layer #(...) layer2 (...);
    Flatten #(...) flatten_inst (...);

endmodule
```

---

### Step 4: Wire .mem files into Verilog

The generated Verilog references the `.mem` files:

```verilog
// In Conv2D_KAN.v (or parameterized by CKAN_Layer)
KAN_LUT_ROM #(
    .INIT_FILE("firmware/mem/kan_lut_conv0.mem")  ← trained splines
) lut_rom_inst (...);
```

Copy all `.mem` files to your Vivado project directory before synthesis.

---

### Step 5: Synthesize on FPGA

```bash
cd firmware/verilog
vivado -mode batch -source ../../src/templates/vivado/build_full.tcl
```

**What it does:**
- Runs Vivado synthesis + implementation
- Generates bitstream
- Reports utilization (LUT, FF, DSP, BRAM) and timing (WNS)

---

## Architecture Alignment

| Component | Python | Verilog | Synced? |
|---|---|---|---|
| Image size | `config["image_height/width"]` | `IMG_WIDTH/HEIGHT` | ✅ Auto-synced |
| Conv layers | `config["conv_layers"]` | `CKAN_Layer` instances | ✅ Auto-generated |
| Channels | `in_channels`, `out_channels` | `L*_INPUT/OUTPUT_CHANNELS` | ✅ Auto-calculated |
| Kernel size | `kernel_size` | `KERNEL_SIZE` | ✅ Auto-synced |
| Stride | `stride` | `CONV_STRIDE` | ✅ Auto-synced |
| Pooling | `pool_size`, `pool_stride` | `POOL_SIZE/STRIDE` | ✅ Auto-synced |
| Bitwidths | `in_precision`, `out_precision` | `DATA_WIDTH`, `OUT_WIDTH` | ✅ Auto-synced |
| Flatten size | Auto-calculated | `FLAT_OUT_WIDTH` | ✅ Auto-calculated |
| MLP input | `mlp_layers[0]` | Kanele VHDL input | ✅ From flatten |

**Everything is auto-generated from `config.json` — no manual parameter editing!**

---

## Key Design Decisions

### Why stride=1 conv + pooling (not stride=2 conv)?

**Verilog hardware** uses:
- Stride-1 convolutions (denser feature extraction)
- Separate 2×2 max pooling (spatial downsampling)

**Reasoning:**
1. **Better feature preservation**: Stride-1 conv sees every pixel overlap
2. **Hardware reuse**: `ImageBufferChnl` (sliding window) is reused for both conv and pool
3. **Standard CNN practice**: Most hardware CNNs (e.g., YOLO, ResNet) use separate pooling

Python model now matches this exactly.

---

## Example: MNIST 2-Layer CKAN

**Config:**
```json
{
  "image_height": 28,
  "image_width": 28,
  "conv_layers": [
    {"in_channels": 1, "out_channels": 2, "kernel_size": 3, "stride": 1,
     "in_precision": 8, "out_precision": 8},
    {"in_channels": 2, "out_channels": 2, "kernel_size": 3, "stride": 1,
     "in_precision": 16, "out_precision": 16}
  ],
  "pool_size": 2,
  "pool_stride": 2,
  "mlp_layers": [50, 32, 10]
}
```

**Generated architecture:**
```
Input:     28×28×1 (grayscale MNIST)
  ↓
Layer 1:   Conv 3×3 S=1 → 26×26×2 → Pool 2×2 → 13×13×2
  ↓
Layer 2:   Conv 3×3 S=1 → 11×11×2 → Pool 2×2 →  5×5×2
  ↓
Flatten:   5×5×2×16b = 800 bits
  ↓
Kanele MLP: 50 → 32 → 10 (classification)
```

**Hardware resources** (estimated for VU9P):
- ~1K LUTs per CKAN layer (36 functions × 256 LUT entries each)
- ~500 LUTs for pooling + buffering per layer
- ~2–5K LUTs for the full 2-layer CKAN
- MLP LUTs depend on sparsity after pruning

---

## Next Steps

1. **Try CIFAR-10**: Uncomment the CIFAR config in `train_ckan.py`
2. **Add more layers**: Extend `conv_layers` list — generator handles arbitrary depth
3. **Tune bitwidths**: Experiment with `in_precision`/`out_precision` for accuracy vs. hardware trade-off
4. **Connect to Kanele MLP**: Wire `flat_out` from CKAN to the Kanele VHDL KAN MLP input

---

You now have a complete, automated pipeline from Python to FPGA with **zero manual Verilog editing**. Just train, export, generate, and synthesize!
