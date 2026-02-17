# Complete CKAN Export Workflow

## What Gets Generated

After running `python convert_ckan.py`, you get a complete hardware-ready export:

```
models/<model_tag>/firmware/
│
├── mem/                           # CKAN Conv Layer Files
│   ├── kan_lut_conv0.mem          # Conv layer 0 LUTs (for Verilog KAN_LUT_ROM)
│   ├── kan_lut_conv1.mem          # Conv layer 1 LUTs
│   ├── conv0_meta.json            # Verilog parameters for layer 0
│   └── conv1_meta.json            # Verilog parameters for layer 1
│
└── mlp_firmware/                  # Kanele MLP IP (complete VHDL project)
    ├── src/                       # VHDL source files
    │   ├── KAN.vhd                #   Top-level MLP module
    │   ├── PkgKAN.vhd             #   Package with types/constants
    │   ├── PkgLUT.vhd             #   LUT configuration package
    │   ├── LUT_0_5_2.vhd          #   Individual LUT modules (per connection)
    │   ├── LUT_0_5_3.vhd
    │   └── ...                    #   (one per non-pruned connection)
    │
    ├── mem/                       # LUT initialization files
    │   ├── lut_0_5_2.mem          #   Truth table for connection (layer 0, in 5, out 2)
    │   ├── lut_0_5_3.mem
    │   └── ...
    │
    ├── vivado/                    # Vivado synthesis scripts
    │   ├── build_full.tcl         #   Full synthesis + implementation
    │   └── build_ooc.tcl          #   Out-of-context synthesis
    │
    └── sim/                       # Simulation files (optional)
        ├── tb_kan.vhd             #   Testbench for functional verification
        ├── vectors_in.txt         #   Test input vectors
        ├── vectors_out.txt        #   Expected outputs
        └── sim.tcl                #   Vivado sim script
```

---

## Export Architecture

### Two-Part System

```
┌─────────────────────────────────────────────┐
│  CKAN Export (custom logic)                 │
│  ────────────────────────                   │
│  • CKANExport.export_ckan_conv()            │
│    → Handles CKAN-specific addressing       │
│    → Generates kan_lut_conv*.mem            │
│    → Creates conv*_meta.json                │
└─────────────────────────────────────────────┘
                  +
┌─────────────────────────────────────────────┐
│  Kanele Infrastructure (reused)             │
│  ────────────────────────────                │
│  • KAN_LUT.generate_firmware()              │
│    → Generates VHDL source files            │
│    → Generates LUT .mem files               │
│    → Generates Vivado build scripts         │
│    → Generates simulation testbenches       │
└─────────────────────────────────────────────┘
```

### Why This Design?

| Component | Implementation | Reason |
|---|---|---|
| **CKAN Conv Export** | Custom `export_ckan_conv()` | Different addressing: `{function_id, input_value}` instead of per-connection files |
| **MLP Export** | Delegates to `KAN_LUT` | Identical to standard Kanele MLP — reuse battle-tested code |

---

## Code Flow

### 1. CKAN Conv Export

```python
# In CKAN_Export.py
def export_ckan_conv(self, output_dir, conv_layer_idx):
    # Get the CKANConv2d layer
    conv_layer = self.model.conv_layers[conv_layer_idx]
    kan = conv_layer.kan  # This is a KANLinear from Kanele
    
    # Get quantized input state space
    input_ss = self.model.input_layer.get_state_space()  # e.g., 256 values for 8-bit
    
    # For each "function" (out_ch × in_ch × K²):
    for func_id in range(num_functions):
        # Evaluate the learned B-spline at all input values
        lut_values = kan.evaluate_at(input_ss, func_id)
        
        # Quantize to integers
        lut_ints = quantize(lut_values, out_precision)
        
        # Write to .mem file (all functions concatenated)
        mem_file.write(hex(lut_ints))
    
    # Also write metadata for Verilog parameterization
    meta = {
        "kernel_size": conv_layer.kernel_size,
        "in_channels": conv_layer.in_channels,
        "out_channels": conv_layer.out_channels,
        ...
    }
    json.dump(meta, "conv{i}_meta.json")
```

### 2. MLP Firmware Export

```python
# In CKAN_Export.py
def export_mlp_firmware(self, clock_period, n_add, fpga_part, latency):
    # Extract MLP-only config
    mlp_config = {
        "layers": self.config["mlp_layers"],         # [50, 32, 10]
        "layers_bitwidth": self.config["mlp_bitwidth"],  # [16, 16, 16]
        ...
    }
    
    # Extract MLP weights from CKAN model
    mlp_checkpoint = {
        "model_state_dict": {
            "layers.0.base_weight": self.model.mlp_layers[0].base_weight,
            "layers.0.spline_weight": self.model.mlp_layers[0].spline_weight,
            ...
        }
    }
    
    # Get input quantizer from last conv layer
    mlp_input = self.model.conv_layers[-1].kan.output_quantizer
    
    # Delegate to Kanele's KAN_LUT
    kan_lut = KAN_LUT(
        model_dir=tmp_dir,
        checkpoint=mlp_checkpoint,
        config=mlp_config,
        input_layer=mlp_input,
        device=self.device
    )
    
    # This generates EVERYTHING:
    # - VHDL source files (KAN.vhd, LUT_*.vhd, packages)
    # - .mem files for LUT ROMs
    # - Vivado TCL scripts
    # - Simulation testbenches
    kan_lut.generate_firmware(
        clock_period=clock_period,
        n_add=n_add,
        fpga_part=fpga_part,
        latency=latency
    )
    
    # Copy generated firmware to output directory
    shutil.copytree(tmp_dir/firmware, output_dir/mlp_firmware)
```

---

## Usage

```bash
# After training completes:
cd experiments/ckan_mnist
python convert_ckan.py

# Output:
# ✓ All firmware files generated:
#   CKAN Conv: models/.../firmware/mem/  → kan_lut_conv*.mem + conv*_meta.json
#   MLP VHDL:  models/.../firmware/mlp_firmware/  → complete Kanele IP (VHDL+mem+TCL)
#
# Next steps:
#   1. Use generate_verilog.py to create CKAN_Model_Custom.v
#   2. Wire CKAN_Model_Custom.flat_out → MLP KAN.vhd input
#   3. Synthesize with Vivado
```

---

## Integration with Hardware

### CKAN Conv Layers (Verilog)

```verilog
// In Conv2D_KAN.v or generated CKAN_Model_Custom.v
KAN_LUT_ROM #(
    .INIT_FILE("firmware/mem/kan_lut_conv0.mem"),  // ← from export
    .NUM_FUNCTIONS(36),                             // ← from conv0_meta.json
    .DATA_WIDTH(8),                                 // ← from conv0_meta.json
    .VALUE_WIDTH(8)                                 // ← from conv0_meta.json
) lut_rom_inst (
    .function_id(func_id),    // 0-35 for 4×1×9 functions
    .input_value(pixel),      // 8-bit quantized pixel
    .data_out(lut_out)        // pre-computed spline value
);
```

### MLP Layers (VHDL from Kanele)

```vhdl
-- In your top-level design
entity top is
port (
    clk        : in  std_logic;
    flat_in    : in  input_vec_t;   -- from CKAN flatten (800 bits for 5×5×2×16)
    class_out  : out output_vec_t   -- 10 class logits
);
end top;

architecture rtl of top is
    component KAN  -- from mlp_firmware/src/KAN.vhd
    port (
        clk : in  std_logic;
        x   : in  input_vec_t;
        y   : out output_vec_t
    );
    end component;
begin
    kan_inst : KAN port map (clk => clk, x => flat_in, y => class_out);
end rtl;
```

---

## Advantages of This Approach

✅ **Reuses Kanele infrastructure**: MLP export is identical to standard Kanele workflow  
✅ **Clean separation**: CKAN conv logic is custom, MLP logic is delegated  
✅ **Complete IP generation**: Not just .mem files, but full VHDL project with build scripts  
✅ **Tested infrastructure**: `KAN_LUT.generate_firmware()` is production-ready from Kanele  
✅ **Automatic pruning**: Sparse connections are skipped automatically  
✅ **Simulation support**: Kanele generates testbenches and test vectors  

---

## Files Generated by Each Method

| Method | Generates | Purpose |
|---|---|---|
| `export_ckan_conv()` | `kan_lut_conv0.mem` | ROM init for Conv2D_KAN Verilog |
| | `conv0_meta.json` | Verilog module parameters |
| `export_mlp_firmware()` | `mlp_firmware/src/*.vhd` | Complete VHDL MLP IP |
| | `mlp_firmware/mem/*.mem` | LUT ROM initialization |
| | `mlp_firmware/vivado/*.tcl` | Synthesis scripts |
| | `mlp_firmware/sim/*` | Testbenches (optional) |

This gives you a **complete, synthesis-ready hardware design** in one command!
