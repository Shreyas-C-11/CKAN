# CKAN — Convolutional KAN on FPGA

**End-to-end pipeline: Train a Convolutional Kolmogorov–Arnold Network in Python → Deploy on FPGA with zero manual HDL editing.**

CKAN replaces traditional convolution weights with **learned B-spline functions** that are baked into **ROM lookup tables** for O(1) hardware inference. The MLP classifier uses the [Kanele](https://github.com/Kanele) framework for VHDL generation.

```
Python Training  →  .mem LUT Files + VHDL/Verilog  →  FPGA Bitstream
```

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Repository Structure](#2-repository-structure)
3. [Step 1 — Train the Model](#3-step-1--train-the-model)
4. [Step 2 — Export to Hardware Files](#4-step-2--export-to-hardware-files)
5. [Step 3 — Generate Verilog Top Module](#5-step-3--generate-verilog-top-module)
6. [Step 4 — Prepare Test Data for FPGA](#6-step-4--prepare-test-data-for-fpga)
7. [Step 5 — Simulate (Optional)](#7-step-5--simulate-optional)
8. [Step 6 — Synthesize & Deploy on FPGA](#8-step-6--synthesize--deploy-on-fpga)
9. [Architecture Overview](#9-architecture-overview)
10. [Configuration Reference](#10-configuration-reference)
11. [Troubleshooting](#11-troubleshooting)

---

## 1. Prerequisites

### Software

| Tool | Version | Purpose |
|------|---------|---------|
| Python | 3.8+ | Training & export |
| PyTorch | 1.13+ | Neural network framework |
| Brevitas | 0.8+ | Quantization-aware training |
| torchvision | 0.14+ | MNIST dataset |
| tqdm | any | Progress bars |
| NumPy | any | Numerical utilities |
| Vivado | 2020.2+ | FPGA synthesis (for deployment) |

### Install Python dependencies

```bash
pip install torch torchvision brevitas tqdm numpy
```

### Hardware (for deployment)

- Xilinx FPGA board (e.g., VCU118 / VU9P, ZCU102, Zynq-7000, etc.)
- Vivado installed with a valid license for your target FPGA

---

## 2. Repository Structure

```
CKAN/
├── src/                              # Core Python modules
│   ├── CKANConv2d.py                 #   Conv KAN layer (unfold → KANLinear → fold)
│   ├── CKAN_Model.py                 #   Full model (conv + pool + MLP)
│   ├── CKAN_Export.py                #   Export trained model → .mem + VHDL
│   ├── KANQuant.py                   #   Quantized KAN with B-splines + pruning
│   ├── quant.py                      #   Quantization utilities (Brevitas)
│   ├── generate_verilog.py           #   Auto-generate Verilog top module
│   ├── KAN_LUT.py                    #   Kanele MLP LUT generation
│   └── templates/                    #   VHDL/Vivado templates
│       ├── src/                      #     VHDL source templates
│       ├── sim/                      #     Testbench templates
│       └── vivado/                   #     TCL build scripts
│
├── experiments/ckan_mnist/           # MNIST experiment
│   ├── train_ckan.py                 #   Training script
│   ├── convert_ckan.py               #   Export script
│   └── prepare_fpga_data.py          #   FPGA test data generator
│
├── [Verilog RTL modules]             # Hand-written hardware IP
│   ├── CKAN_Model.v                  #   2-layer CKAN top module (template)
│   ├── CKAN_Model_DUT.v              #   MNIST test wrapper
│   ├── CKAN_Layer.v                  #   Conv + Pool wrapper
│   ├── Conv2D_KAN.v                  #   KAN-based convolution
│   ├── ConvolChnl_KAN.v              #   Per-channel convolution
│   ├── Conv_MIC.v / Conv_SIC.v       #   Multi/single input channel conv
│   ├── KAN_LUT_ROM.v                 #   B-spline lookup table ROM
│   ├── ImageBuf_KernelSlider.v       #   Sliding window buffer
│   ├── ImageBufferChnl.v             #   Multi-channel image buffer
│   ├── Line_Buffer.v / Data_Buffer.v #   Line/data buffer primitives
│   ├── MaxPool2D.v / MaxPooling.v    #   Max pooling
│   └── Flatten.v                     #   Spatial → vector converter
│
├── ARCHITECTURE.md                   # Detailed architecture documentation
├── PIPELINE_SUMMARY.md               # Pipeline overview
└── Readme.md                         # ← You are here
```

---

## 3. Step 1 — Train the Model

### 3.1 Navigate to the experiment directory

```bash
cd experiments/ckan_mnist
```

### 3.2 Download MNIST (first time only)

Open `train_ckan.py` and set `download=True` on lines 223–224:

```python
trainset = torchvision.datasets.MNIST(root='./data', train=True,  download=True, transform=transform)
valset   = torchvision.datasets.MNIST(root='./data', train=False, download=True, transform=transform)
```

> After the first run, set it back to `download=False`.

### 3.3 Start training

```bash
python train_ckan.py
```

### 3.4 What happens during training

| Phase | Epochs | What Happens |
|-------|--------|-------------|
| **Warmup** | 1–5 | No pruning. Model learns all B-spline functions. |
| **Pruning ramp** | 5–20 | Weak connections are progressively zeroed (sparsity increases). |
| **Fine-tuning** | 20–200 | Stable sparsity. Accuracy converges (~98–99% on MNIST). |

### 3.5 Training outputs

```
models/YYYYMMDD_HHMMSS/
├── config.json                                    ← Architecture config (auto-saved)
├── CKAN_acc0.9563_epoch1_remaining1.0000.pt       ← Checkpoint per epoch
├── CKAN_acc0.9850_epoch50_remaining0.7234.pt
└── ...
```

### 3.6 (Optional) Tune the config

Edit the `config` dict in `train_ckan.py` to change:

- **Architecture**: `conv_layers`, `mlp_layers`, `pool_size`
- **Precision**: `in_precision`, `out_precision`, `input_bitwidth`
- **Training**: `num_epochs`, `learning_rate`, `batch_size`
- **Pruning**: `prune_threshold`, `target_epoch`, `warmup_epochs`

A CIFAR-10 config is included as a commented block — uncomment to use.

---

## 4. Step 2 — Export to Hardware Files

Once training is complete (or you have a good checkpoint):

### 4.1 Run the export script

```bash
python convert_ckan.py
```

> **Note**: Edit `model_dir` in `convert_ckan.py` if your checkpoint is not in the default `models/` directory.

### 4.2 What gets generated

```
models/<run>/firmware/
│
├── mem/                              # CKAN Conv LUT files (Verilog)
│   ├── kan_lut_conv0.mem             #   Layer 0: all B-spline truth tables
│   ├── kan_lut_conv1.mem             #   Layer 1: all B-spline truth tables
│   ├── conv0_meta.json               #   Verilog parameters for layer 0
│   └── conv1_meta.json               #   Verilog parameters for layer 1
│
└── mlp_firmware/                     # Kanele MLP IP (VHDL)
    ├── src/                          #   VHDL source files
    │   ├── KAN.vhd                   #     Top-level MLP entity
    │   ├── PkgKAN.vhd                #     Type/constant package
    │   ├── PkgLUT.vhd                #     LUT config package
    │   └── LUT_*.vhd                 #     Per-connection LUT modules
    ├── mem/                          #   LUT .mem files for VHDL ROMs
    ├── vivado/                       #   Vivado TCL scripts
    │   ├── build_full.tcl            #     Full synth + implementation
    │   └── build_ooc.tcl             #     Out-of-context synthesis
    └── sim/                          #   Simulation files
        ├── tb_kan.vhd                #     MLP testbench
        ├── vectors_in.txt            #     Test inputs
        ├── vectors_out.txt           #     Expected outputs
        └── sim.tcl                   #     Vivado sim script
```

### 4.3 What the .mem files contain

Each `.mem` file is a truth table for the Verilog `KAN_LUT_ROM` module:

```
03    ← function 0, input 0   →   spline(0) = 0x03
F2    ← function 0, input 1   →   spline(1) = 0xF2
...
1A    ← function 0, input 255 →   spline(255) = 0x1A
05    ← function 1, input 0   →   next function starts
...
```

Address = `{function_id, input_value}` — direct ROM lookup, zero math at runtime.

---

## 5. Step 3 — Generate Verilog Top Module

### 5.1 Run the Verilog generator

```bash
python ../../src/generate_verilog.py \
    --model_dir models/<your_run_dir> \
    --output_dir firmware/verilog
```

### 5.2 What gets generated

```
firmware/verilog/
├── CKAN_Model_Custom.v               ← Parameterized top module
└── CKAN_Model_Custom_summary.json    ← Architecture summary
```

The generated Verilog is fully parameterized from your `config.json`:

```verilog
module CKAN_Model_Custom #(
    parameter IMG_WIDTH             = 28,
    parameter IMG_HEIGHT            = 28,
    parameter L1_KERNEL_SIZE        = 3,
    parameter L1_CONV_STRIDE        = 1,
    parameter L1_INPUT_CHANNELS     = 1,
    parameter L1_OUTPUT_CHANNELS    = 2,
    parameter L1_DATA_WIDTH         = 8,
    parameter L1_VALUE_WIDTH        = 8,
    ...
)(
    input  wire        clock,
    input  wire        sreset_n,
    input  wire        data_valid,
    input  wire [7:0]  data_in,       // pixel stream
    output wire [799:0] flat_out,     // flattened features → MLP
    output wire         flat_valid
);
```

### 5.3 No manual editing needed

All parameters (channels, kernel sizes, bitwidths, spatial dimensions) are auto-calculated from `config.json`. Zero manual Verilog editing.

---

## 6. Step 4 — Prepare Test Data for FPGA

### 6.1 Generate test data

```bash
# Raw pixel hex only (no trained model needed):
python prepare_fpga_data.py --raw_only --num_images 100

# Full export with MLP test vectors (after training):
python prepare_fpga_data.py --model_dir models/<your_run_dir> --num_images 100
```

### 6.2 Output files

```
fpga_test_data/
├── pixel_streams/                    # Individual image hex files
│   ├── image_0000_label7.hex         #   784 lines, one 8-bit hex byte per pixel
│   └── ...
├── all_pixels.hex                    # All images concatenated
├── vectors_in.txt                    # MLP input vectors (for VHDL testbench)
├── vectors_out.txt                   # Expected MLP outputs
├── test_labels.txt                   # Ground-truth labels
├── predictions.txt                   # Model predictions
└── test_summary.json                 # Export metadata
```

### 6.3 How to feed data to the FPGA

The hardware expects a **row-major pixel stream** — one pixel per clock cycle:

```
Clock cycle:    1    2    3    ...  784       (28×28 = 784 pixels per image)
pixel_in:      P00  P01  P02  ...  P783      (8-bit hex, top-left → bottom-right)
data_valid:     1    1    1    ...   1        (high during entire image)
                                     ↓
                              [pipeline delay]
                                     ↓
flat_valid:                          1        (pulses when result is ready)
flat_out:                    [800-bit vector] (50 features × 16 bits)
```

Between images, deassert `data_valid` for at least 1 clock cycle.

---

## 7. Step 5 — Simulate (Optional)

### 7.1 Simulate the MLP (VHDL)

```bash
cd models/<your_run>/firmware/mlp_firmware
vivado -mode batch -source sim/sim.tcl
```

This runs `tb_kan.vhd` which reads `vectors_in.txt` / `vectors_out.txt` and compares DUT output against expected values.

### 7.2 Simulate the full CKAN pipeline (Verilog)

Create a Verilog testbench that:

1. Reads a `.hex` file from `fpga_test_data/pixel_streams/`
2. Feeds pixels into `CKAN_Model_DUT` one per clock
3. Waits for `flat_valid` pulse
4. Captures `flat_out` and feeds it to the Kanele MLP

```verilog
// Example testbench snippet
module tb_ckan;
    reg clock = 0, sreset_n = 1, data_valid = 0;
    reg [7:0] pixel_in;
    wire [799:0] flat_out;
    wire flat_valid;

    CKAN_Model_DUT dut (.*);

    always #5 clock = ~clock;  // 100 MHz

    initial begin
        // Load hex file
        $readmemh("fpga_test_data/pixel_streams/image_0000_label7.hex", pixel_mem);
        #100 sreset_n = 1;

        // Stream 784 pixels
        for (int i = 0; i < 784; i++) begin
            @(posedge clock);
            data_valid <= 1;
            pixel_in <= pixel_mem[i];
        end
        @(posedge clock) data_valid <= 0;

        // Wait for result
        wait(flat_valid);
        $display("flat_out = %h", flat_out);
        $finish;
    end
endmodule
```

---

## 8. Step 6 — Synthesize & Deploy on FPGA

### 8.1 Gather all source files

Copy the following into your Vivado project:

| Source | Location |
|--------|----------|
| **CKAN Verilog RTL** | All `.v` files from repo root |
| **Generated top module** | `firmware/verilog/CKAN_Model_Custom.v` |
| **CKAN Conv .mem files** | `firmware/mem/kan_lut_conv*.mem` |
| **MLP VHDL sources** | `firmware/mlp_firmware/src/*.vhd` |
| **MLP .mem files** | `firmware/mlp_firmware/mem/*.mem` |

### 8.2 Project file list

```
# Verilog (CKAN Conv pipeline)
CKAN_Model_Custom.v          ← auto-generated
CKAN_Layer.v
Conv2D_KAN.v
ConvolChnl_KAN.v
Conv_MIC.v
Conv_SIC.v
KAN_LUT_ROM.v
ImageBuf_KernelSlider.v
ImageBufferChnl.v
Line_Buffer.v
Data_Buffer.v
MaxPool2D.v
MaxPooling.v
Flatten.v

# VHDL (Kanele MLP)
KAN.vhd
PkgKAN.vhd
PkgLUT.vhd
LUT_*.vhd
```

### 8.3 Synthesize with Vivado

**Option A — Use the provided TCL script:**

```bash
cd firmware/mlp_firmware
vivado -mode batch -source vivado/build_full.tcl
```

**Option B — Manual Vivado GUI:**

1. Create a new Vivado project
2. Add all Verilog `.v` files and VHDL `.vhd` files as sources
3. Add all `.mem` files as data/memory files
4. Set `CKAN_Model_Custom` (or your top-level wrapper) as the top module
5. Add your constraints file (`.xdc`) with pin mappings and clock
6. Run Synthesis → Implementation → Generate Bitstream

**Option C — Command-line:**

```bash
vivado -mode batch -source build.tcl
```

Example `build.tcl`:

```tcl
create_project ckan_fpga ./vivado_project -part xcvu9p-flgb2104-2-i

# Add sources
add_files [glob *.v]
add_files [glob firmware/mlp_firmware/src/*.vhd]
add_files [glob firmware/mem/*.mem]
add_files [glob firmware/mlp_firmware/mem/*.mem]

# Set top module
set_property top CKAN_Model_Custom [current_fileset]

# Add constraints
add_files -fileset constrs_1 constraints.xdc

# Run
launch_runs synth_1 -jobs 8
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
```

### 8.4 Program the FPGA

```bash
open_hw_manager
connect_hw_server
open_hw_target
set_property PROGRAM.FILE {./vivado_project/ckan_fpga.runs/impl_1/CKAN_Model_Custom.bit} [current_hw_device]
program_hw_devices
```

### 8.5 Integration tips

- **Clock**: The CKAN conv pipeline is purely combinational per stage with registered outputs. Target 100–200 MHz depending on your FPGA.
- **Data interface**: Connect `pixel_in` to your image source (camera, UART, AXI stream, BRAM, etc.)
- **MLP connection**: Wire `flat_out` from the CKAN Verilog module to the `input` port of `KAN.vhd`
- **Output**: The MLP's 10 outputs are class logits — take `argmax` for the predicted digit.

---

## 9. Architecture Overview

### MNIST Default Configuration

```
Input:     1×28×28 (grayscale, 8-bit pixels, 4-bit quantized)
  ↓
Layer 1:   CKANConv 1→2, K=3, S=1  →  26×26×2  →  MaxPool 2×2  →  13×13×2
  ↓
Layer 2:   CKANConv 2→2, K=3, S=1  →  11×11×2  →  MaxPool 2×2  →   5×5×2
  ↓
Flatten:   5×5×2 = 50 features (× 16-bit = 800 bits)
  ↓
MLP:       50 → 32 → 10 (KAN with B-spline LUTs)
  ↓
Output:    10 class logits (argmax = predicted digit)
```

### How KAN LUTs Work

Traditional CNN: `output += weight × input` (multiply-accumulate)

CKAN: `output += LUT[function_id][input_value]` (ROM lookup, zero math)

Each learned B-spline is **pre-evaluated** at all quantized input values and stored as a truth table in ROM. At inference time, the hardware just does a table lookup — no multiplications needed.

### Python ↔ Hardware Mapping

| Python | Verilog/VHDL | Function |
|--------|-------------|----------|
| `nn.Unfold` | `ImageBufferChnl` | Extract K×K sliding windows |
| `KANLinear` (B-spline) | `KAN_LUT_ROM` | Learned function → ROM lookup |
| `nn.MaxPool2d` | `MaxPool2D` | 2×2 spatial downsampling |
| `torch.flatten` | `Flatten` | Spatial features → vector |
| KAN MLP layers | `KAN.vhd` | Classification (VHDL from Kanele) |

---

## 10. Configuration Reference

### Training config (`train_ckan.py`)

| Parameter | Default | Description |
|-----------|---------|-------------|
| `image_height/width` | 28 | Input image dimensions |
| `conv_layers` | 2 layers | List of conv layer dicts |
| `conv_layers[].in_channels` | 1, 2 | Input channels per layer |
| `conv_layers[].out_channels` | 2, 2 | Output channels per layer |
| `conv_layers[].kernel_size` | 3 | Convolution window size |
| `conv_layers[].stride` | 1 | Convolution stride |
| `conv_layers[].in_precision` | 8, 16 | Input bitwidth for LUT addressing |
| `conv_layers[].out_precision` | 8, 16 | Output bitwidth for LUT values |
| `pool_size` | 2 | Max pooling window size |
| `pool_stride` | 2 | Max pooling stride |
| `mlp_layers` | [50, 32, 10] | MLP neuron counts |
| `mlp_bitwidth` | [16, 16, 16] | MLP per-layer bitwidth |
| `grid_size` | 15 | B-spline grid resolution |
| `spline_order` | 3 | B-spline polynomial order |
| `input_bitwidth` | 4 | Pixel quantization (4-bit = 16 levels) |
| `prune_threshold` | 0.3 | Pruning strength |
| `num_epochs` | 200 | Training epochs |

---

## 11. Troubleshooting

### Training issues

| Problem | Solution |
|---------|----------|
| `ModuleNotFoundError: brevitas` | `pip install brevitas` |
| `FileNotFoundError: MNIST` | Set `download=True` in `train_ckan.py` lines 223–224 |
| `CUDA out of memory` | Reduce `batch_size` in config |
| Low accuracy | Train longer, reduce `prune_threshold`, increase `grid_size` |

### Export issues

| Problem | Solution |
|---------|----------|
| `No checkpoints found` | Edit `model_dir` in `convert_ckan.py` to point to your run |
| `.mem file too large` | Reduce `in_precision` (fewer LUT entries per function) |

### Synthesis issues

| Problem | Solution |
|---------|----------|
| `Module not found` | Ensure ALL `.v` and `.vhd` files are added to the project |
| `.mem file not found` | Add `.mem` files as memory init files; check `INIT_FILE` paths |
| Timing violations | Reduce clock frequency or increase pipeline depth |
| High LUT usage | Increase pruning (`prune_threshold`) to reduce active connections |

---

## Quick Reference — Full Deployment in 6 Commands

```bash
# 1. Train
cd experiments/ckan_mnist
python train_ckan.py

# 2. Export .mem + VHDL
python convert_ckan.py

# 3. Generate Verilog top module
python ../../src/generate_verilog.py \
    --model_dir models/<run> \
    --output_dir firmware/verilog

# 4. Prepare test data
python prepare_fpga_data.py \
    --model_dir models/<run> \
    --num_images 100

# 5. Simulate (optional)
cd firmware/mlp_firmware
vivado -mode batch -source sim/sim.tcl

# 6. Synthesize
vivado -mode batch -source vivado/build_full.tcl
```

**That's it — config-driven, end-to-end, from Python to FPGA!**
