# Example: Generate Verilog from trained model

After training completes, run:

```bash
python src/generate_verilog.py \
    --model_dir experiments/ckan_cifar10/models/<your_run_timestamp> \
    --output_dir firmware/verilog
```

This will create:
- `firmware/verilog/CKAN_Model_Custom.v` — complete top module
- `firmware/verilog/CKAN_Model_Custom_summary.json` — architecture summary

The generated Verilog will exactly match your Python config:
- Number of layers
- Channel counts (in/out)
- Kernel sizes
- Stride values
- Pool parameters
- All spatial dimensions auto-calculated

## Workflow

1. **Train**: `python train_ckan.py` → saves config.json
2. **Export .mem**: `python convert_ckan.py` → generates LUT .mem files
3. **Generate Verilog**: `python generate_verilog.py` → creates top module
4. **Synthesize**: `vivado -mode batch -source vivado/build_full.tcl`

No manual parameter editing required!
