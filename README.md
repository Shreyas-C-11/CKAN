# CKAN — Convolutional Kolmogorov-Arnold Network (Verilog)

A fully synthesisable Verilog implementation of a **Convolutional KAN (CKAN)** layer, where traditional multiply-accumulate (MAC) operations are replaced by **learned basis functions stored in lookup tables (LUTs)**. The design is parameterised for kernel size, stride, channel counts, and data widths, making it suitable for deployment on FPGAs.

---

## Key Idea

In a standard CNN convolution, each input pixel is multiplied by a learned weight and the products are summed. A KAN replaces this fixed linear operation with a **learnable univariate function per edge** in the network graph. In hardware, each learned function is stored as a ROM lookup table (`KAN_LUT_ROM`), so a "multiply" becomes a simple **table read** — trading multiplier resources for distributed memory.

---

## Architecture

```
pixel stream ──► ImageBufferChnl
                    │
                    ├── ImageBuf_KernelSlider (channel 0)  ──► kernel_valid
                    │       ├── Line_Buffer
                    │       │       └── Data_Buffer (shift-register chain)
                    │       └── Valid logic (row / col counters + stride)
                    │
                    ├── ImageBuf_KernelSlider (channel 1)
                    └── …
                            │
                            ▼  KxK × Cin window
                    ConvolChnl_KAN
                    │
                    ├── Conv_MIC_KAN (output channel 0)
                    │       ├── Conv_SIC_KAN (input ch 0) ── KAN_LUT_ROM ── adder tree
                    │       ├── Conv_SIC_KAN (input ch 1) ── KAN_LUT_ROM ── adder tree
                    │       └── cross-channel summation
                    │
                    ├── Conv_MIC_KAN (output channel 1)
                    └── …
                            │
                            ▼
                    conv_out  (packed output feature maps)
```

---

## Module Hierarchy

| Module | File | Role |
|---|---|---|
| **Conv2D_KAN** | `Conv2D_KAN.v` | Top-level wrapper. Connects the image buffer to the CKAN compute engine. |
| **ImageBufferChnl** | `ImageBufferChnl.v` | Multi-channel image buffer. Instantiates one sliding-window generator per input channel. |
| **ImageBuf_KernelSlider** | `ImageBuf_KernelSlider.v` | Generates a KxK sliding window from a serial pixel stream using chained line buffers. Contains row/column counters and stride-aware valid logic. |
| **Line_Buffer** | `Line_Buffer.v` | Shift-register chain built from `Data_Buffer` instances. Exposes the first K elements as a kernel row tap. |
| **Data_Buffer** | `Data_Buffer.v` | Single-register building block — stores one pixel on `data_valid`. |
| **ConvolChnl_KAN** | `ConvolChnl_KAN.v` | Instantiates one `Conv_MIC_KAN` per output channel; all output channels compute in parallel on the same input window. |
| **Conv_MIC_KAN** | `Conv_MIC.v` | Multi-Input-Channel block. Processes all Cin channels for **one** output feature, then sums their partial results. |
| **Conv_SIC_KAN** | `Conv_SIC.v` | Single-Input-Channel block. Passes each pixel of a KxK window through a KAN LUT, then reduces the K² results with a binary adder tree. 2-stage pipeline. |
| **KAN_LUT_ROM** | `KAN_LUT_ROM.v` | Combinational ROM holding learned KAN basis functions. Addressed by `{function_id, input_value}`. Attributed for distributed (LUT) RAM inference on Xilinx/Intel FPGAs. |

---

## Parameters

The top-level `Conv2D_KAN` module exposes all configurable parameters:

| Parameter | Default | Description |
|---|---|---|
| `KERNEL_SIZE` | 3 | Spatial convolution window size (K × K) |
| `COLUMN_NUM` | 5 | Input image width |
| `ROW_NUM` | 5 | Input image height |
| `STRIDE` | 1 | Sliding-window stride |
| `INPUT_CHANNELS` | 3 | Number of input feature channels (Cin) |
| `OUTPUT_CHANNELS` | 2 | Number of output feature channels (Cout) |
| `DATA_WIDTH` | 8 | Input pixel bit-width |
| `VALUE_WIDTH` | 8 | KAN LUT output bit-width |
| `OUT_WIDTH` | 16 | Accumulator / output bit-width |

---

## KAN LUT Memory

The file **`kan_lut.mem`** contains the hex-encoded initialisation data for `KAN_LUT_ROM`. Each learned basis function occupies a contiguous block of `2^DATA_WIDTH` entries. The ROM is addressed as:

```
ROM[ {function_id, input_value} ] → signed output value
```

The included example contains 16 entries (values 0–7 and −8 to −1 in two's complement), serving as a minimal placeholder. For a trained network, replace this file with the exported LUT weights from your KAN training framework.

---

## Interface

### Inputs

| Signal | Width | Description |
|---|---|---|
| `clock` | 1 | System clock |
| `sreset_n` | 1 | Synchronous active-low reset |
| `data_valid` | 1 | Asserted when `data_in` carries a valid pixel |
| `data_in` | Cin × DATA_WIDTH | Packed multi-channel pixel (all channels for one spatial position) |

### Outputs

| Signal | Width | Description |
|---|---|---|
| `conv_out` | Cout × OUT_WIDTH | Packed CKAN output feature maps |
| `conv_valid` | 1 | Asserted for one cycle when `conv_out` is valid |

---

## Pipeline Latency

The compute path has a **2-cycle pipeline** inside `Conv_SIC_KAN`:

1. **Cycle 1** — KAN LUT outputs are registered.
2. **Cycle 2** — Adder-tree result is registered.

A matching 2-stage valid shift register (`vpipe`) tracks the pipeline delay.

---

## Getting Started

1. **Add all `.v` files** and `kan_lut.mem` to your FPGA project.
2. **Instantiate `Conv2D_KAN`** with the desired parameters.
3. **Provide a trained `kan_lut.mem`** file — export from your KAN training script in `$readmemh`-compatible hex format.
4. **Stream pixels** row-major, one spatial position per clock (when `data_valid` is high). The module handles windowing, striding, and valid signalling internally.

---

## License
