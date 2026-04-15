# Example: Generate Verilog from trained TinyImageNet CKAN model

After training completes, run:

```bash
python src/generate_verilog.py \
    --model_dir experiments/ckan_tinyimagenet/models/<your_run> \
    --output_dir firmware/verilog
```

This will create:
- `firmware/verilog/CKAN_Model_Custom.v` — complete top module
- `firmware/verilog/CKAN_Model_Custom_summary.json` — architecture summary

Workflow:

1. Train: `python train_ckan.py`
2. Export `.mem` / Verilog: `python convert_ckan.py`
3. Generate FPGA test data: `python prepare_fpga_data.py --model_dir models/<your_run>`
4. Synthesize: `vivado -mode batch -source vivado/build_full.tcl`

TinyImageNet uses 64×64 RGB inputs and 200 classes, so update the model config before exporting if you change the architecture.
