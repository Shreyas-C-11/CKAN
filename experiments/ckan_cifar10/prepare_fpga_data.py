# prepare_fpga_data.py — Convert CIFAR-10 images to FPGA-ready hex files
#
# Generates:
#   1. pixel_stream_N.hex    — Row-major 8-bit hex pixel stream for CKAN conv input
#   2. vectors_in.txt        — Quantized flat input vectors for MLP testbench
#   3. vectors_out.txt       — Expected output vectors for MLP testbench verification
#   4. test_labels.txt       — Ground-truth labels for verification
#   5. test_summary.json     — Metadata about the exported test set
#
# Usage:
#   python prepare_fpga_data.py [--num_images 100] [--model_dir models/<run>]

import sys, os, json, argparse
import numpy as np
import torch
import torch.nn as nn
import torchvision
import torchvision.transforms as transforms

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', 'src'))

from CKAN_Model import CKANModel
from quant import QuantBrevitasActivation, ScalarBiasScale
from brevitas.nn import QuantHardTanh
from brevitas.core.scaling import ParameterScaling
from brevitas.core.quant import QuantType


def quantize_pixel_to_int(value_float, bitwidth):
    """
    Convert a floating-point pixel (after normalization + quantization)
    to an unsigned integer for the FPGA ROM.

    For 8-bit signed: range [-128, 127] → stored as 2's complement hex.
    For 4-bit signed: range [-8, 7] → stored as 2's complement hex.
    """
    num_levels = 1 << bitwidth
    half = num_levels // 2
    # Clamp to signed range
    int_val = int(round(value_float))
    int_val = max(-half, min(half - 1, int_val))
    # Convert to unsigned (2's complement)
    if int_val < 0:
        int_val += num_levels
    return int_val


# CIFAR-10 constants
CIFAR10_MEAN = (0.4914, 0.4822, 0.4465)
CIFAR10_STD  = (0.2470, 0.2435, 0.2616)
CIFAR10_CLASSES = [
    'airplane', 'automobile', 'bird', 'cat', 'deer',
    'dog', 'frog', 'horse', 'ship', 'truck',
]


def main():
    parser = argparse.ArgumentParser(description="Prepare CIFAR-10 data for FPGA inference")
    parser.add_argument("--num_images", type=int, default=100,
                        help="Number of test images to export (default: 100)")
    parser.add_argument("--model_dir", type=str, default=None,
                        help="Model dir with config.json + checkpoint (for quantized export)")
    parser.add_argument("--output_dir", type=str, default="fpga_test_data",
                        help="Output directory for generated files")
    parser.add_argument("--raw_only", action="store_true",
                        help="Export raw pixel hex only (no model needed)")
    args = parser.parse_args()

    os.makedirs(args.output_dir, exist_ok=True)
    device = "cpu"  # CPU is fine for data export

    # ─── Load CIFAR-10 test set ───────────────────────────────────────
    transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize(CIFAR10_MEAN, CIFAR10_STD),
    ])
    testset = torchvision.datasets.CIFAR10(
        root='./data', train=False, download=True, transform=transform
    )

    num_images = min(args.num_images, len(testset))
    print(f"Exporting {num_images} CIFAR-10 test images to {args.output_dir}/")

    # ═══════════════════════════════════════════════════════════════════
    # 1. Raw pixel stream (always generated — no model needed)
    #    Format: one hex value per line, channel-major scan order (C×H×W)
    #    This is what the CKAN_Model hardware reads via data_in
    # ═══════════════════════════════════════════════════════════════════
    print("\n[1/4] Generating raw pixel streams...")
    pixel_dir = os.path.join(args.output_dir, "pixel_streams")
    os.makedirs(pixel_dir, exist_ok=True)

    labels = []
    for idx in range(num_images):
        image, label = testset[idx]  # image: [3, 32, 32] float tensor
        labels.append(label)

        # Convert to 8-bit unsigned (0-255) for the raw pixel stream
        # The FPGA input layer handles quantization in hardware
        # Undo normalization per channel
        raw_pixels = image.clone()
        for c in range(3):
            raw_pixels[c] = raw_pixels[c] * CIFAR10_STD[c] + CIFAR10_MEAN[c]
        raw_pixels = (raw_pixels * 255.0).clamp(0, 255).to(torch.uint8)

        # Write channel-major pixel stream (C×H×W, one hex byte per line)
        class_name = CIFAR10_CLASSES[label]
        hex_path = os.path.join(pixel_dir, f"image_{idx:04d}_label{label}_{class_name}.hex")
        with open(hex_path, 'w') as f:
            for ch in range(3):
                for row in range(32):
                    for col in range(32):
                        f.write(f"{int(raw_pixels[ch, row, col]):02X}\n")

    # Write labels
    label_path = os.path.join(args.output_dir, "test_labels.txt")
    with open(label_path, 'w') as f:
        for lbl in labels:
            f.write(f"{lbl}\n")
    print(f"  ✓ {num_images} pixel streams → {pixel_dir}/")
    print(f"  ✓ Labels → {label_path}")

    # Also write a single combined file (all images concatenated)
    combined_path = os.path.join(args.output_dir, "all_pixels.hex")
    with open(combined_path, 'w') as f:
        for idx in range(num_images):
            image, label = testset[idx]
            raw_pixels = image.clone()
            for c in range(3):
                raw_pixels[c] = raw_pixels[c] * CIFAR10_STD[c] + CIFAR10_MEAN[c]
            raw_pixels = (raw_pixels * 255.0).clamp(0, 255).to(torch.uint8)
            class_name = CIFAR10_CLASSES[label]
            f.write(f"// Image {idx} (label={label}, class={class_name})\n")
            for ch in range(3):
                for row in range(32):
                    for col in range(32):
                        f.write(f"{int(raw_pixels[ch, row, col]):02X}\n")
    print(f"  ✓ Combined stream → {combined_path}")

    if args.raw_only:
        print("\n✓ Raw pixel export complete (--raw_only mode)")
        return

    # ═══════════════════════════════════════════════════════════════════
    # 2. Quantized MLP test vectors (needs trained model)
    #    Format: space-separated integers, one vector per line
    #    Used by the Kanele MLP VHDL testbench (tb_kan.vhd)
    # ═══════════════════════════════════════════════════════════════════
    if args.model_dir is None:
        print("\n⚠ Skipping MLP test vectors (no --model_dir provided)")
        print("  Run with: python prepare_fpga_data.py --model_dir models/<your_run>")
        _write_summary(args.output_dir, num_images, labels, has_mlp_vectors=False)
        return

    print(f"\n[2/4] Loading model from {args.model_dir}...")

    # Load config
    config_path = os.path.join(args.model_dir, "config.json")
    with open(config_path, 'r') as f:
        config = json.load(f)

    # Find best checkpoint
    files = [f for f in os.listdir(args.model_dir) if f.endswith('.pt')]
    if not files:
        raise FileNotFoundError(f"No checkpoints in '{args.model_dir}'")
    files.sort(key=lambda x: float(x.split('_acc')[1].split('_epoch')[0]),
               reverse=True)
    best_ckpt = os.path.join(args.model_dir, files[0])
    print(f"  Using checkpoint: {best_ckpt}")

    # Rebuild input layer
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

    # Load model
    model = CKANModel(config, input_layer, device).to(device)
    checkpoint = torch.load(best_ckpt, map_location=device)
    model.load_state_dict(checkpoint['model_state_dict'])
    model.eval()
    print(f"  Model loaded — val_acc: {checkpoint.get('val_accuracy', 'N/A')}")

    # ─── Generate MLP input/output test vectors ───────────────────────
    print("\n[3/4] Generating MLP test vectors...")
    vectors_in_path = os.path.join(args.output_dir, "vectors_in.txt")
    vectors_out_path = os.path.join(args.output_dir, "vectors_out.txt")
    predictions_path = os.path.join(args.output_dir, "predictions.txt")

    correct = 0
    with open(vectors_in_path, 'w') as fin, \
         open(vectors_out_path, 'w') as fout, \
         open(predictions_path, 'w') as fpred:

        with torch.no_grad():
            for idx in range(num_images):
                image, label = testset[idx]
                x = image.view(1, -1).to(device)  # [1, 3072]

                # Run through input quantization
                x_q = model.input_layer(x)

                # Run through conv layers
                x_spatial = x_q.reshape(1, 3, 32, 32)
                for conv in model.conv_layers:
                    x_spatial = conv(x_spatial)
                    x_spatial = model.pool(x_spatial)

                # Flatten — this is the MLP input vector
                mlp_input = x_spatial.flatten(1)  # [1, 576]

                # Run through MLP
                mlp_output = mlp_input.clone()
                for layer in model.mlp_layers:
                    mlp_output = layer(mlp_output)

                # Get prediction
                pred = mlp_output.argmax(1).item()
                if pred == label:
                    correct += 1

                # Quantize MLP input to integers for the VHDL testbench
                last_conv_quant = model.conv_layers[-1].kan.output_quantizer
                scale, bits = last_conv_quant.get_scale_factor_bits(False)
                mlp_in_ints = (mlp_input / scale).round().to(torch.int).squeeze()

                # Quantize MLP output to integers
                last_mlp_quant = model.mlp_layers[-1].output_quantizer
                out_scale, out_bits = last_mlp_quant.get_scale_factor_bits(False)
                mlp_out_ints = (mlp_output / out_scale).round().to(torch.int).squeeze()

                # Write space-separated integer vectors
                fin.write(" ".join(str(v.item()) for v in mlp_in_ints) + "\n")
                fout.write(" ".join(str(v.item()) for v in mlp_out_ints) + "\n")
                fpred.write(f"{pred} (label={label}, class={CIFAR10_CLASSES[label]})\n")

    acc = correct / num_images * 100
    print(f"  ✓ MLP inputs  → {vectors_in_path}  ({mlp_in_ints.shape[0]} elements/vector)")
    print(f"  ✓ MLP outputs → {vectors_out_path} ({mlp_out_ints.shape[0]} elements/vector)")
    print(f"  ✓ Predictions → {predictions_path}")
    print(f"  Model accuracy on exported set: {correct}/{num_images} ({acc:.1f}%)")

    # ─── Summary ──────────────────────────────────────────────────────
    print("\n[4/4] Writing summary...")
    _write_summary(args.output_dir, num_images, labels, has_mlp_vectors=True,
                   accuracy=acc, model_dir=args.model_dir)


def _write_summary(output_dir, num_images, labels, has_mlp_vectors=False,
                   accuracy=None, model_dir=None):
    summary = {
        "dataset": "CIFAR-10",
        "num_images": num_images,
        "image_size": "3x32x32",
        "pixel_format": "8-bit unsigned, channel-major (C×H×W), one hex byte per line",
        "classes": CIFAR10_CLASSES,
        "label_distribution": {str(i): labels.count(i) for i in range(10)},
        "has_mlp_vectors": has_mlp_vectors,
    }
    if accuracy is not None:
        summary["model_accuracy"] = f"{accuracy:.1f}%"
    if model_dir is not None:
        summary["model_dir"] = model_dir

    summary["files"] = {
        "pixel_streams/image_NNNN_labelL_class.hex": "Individual 3x32x32 pixel streams (raw 8-bit, C×H×W)",
        "all_pixels.hex": "All images concatenated (with // comments)",
        "test_labels.txt": "Ground-truth labels (one per line)",
    }
    if has_mlp_vectors:
        summary["files"].update({
            "vectors_in.txt": "MLP input vectors (space-separated integers)",
            "vectors_out.txt": "Expected MLP output vectors (for tb_kan.vhd)",
            "predictions.txt": "Model predictions vs labels",
        })

    summary_path = os.path.join(output_dir, "test_summary.json")
    with open(summary_path, 'w') as f:
        json.dump(summary, f, indent=2)
    print(f"  ✓ Summary → {summary_path}")

    print(f"\n{'═'*60}")
    print(f"✓ FPGA test data export complete!")
    print(f"{'═'*60}")
    print(f"\nHow to use:")
    print(f"  1. CKAN Conv (Verilog): Feed pixel_streams/*.hex into CKAN_Model_DUT")
    print(f"     → One hex byte per clock cycle, channel-major (C×H×W)")
    print(f"     → 3 channels × 32×32 = 3072 bytes per image")
    print(f"     → Assert data_valid=1 while streaming, 0 between images")
    if has_mlp_vectors:
        print(f"  2. MLP (VHDL tb_kan): Copy vectors_in.txt + vectors_out.txt to sim/")
        print(f"     → tb_kan.vhd reads these automatically for verification")
    print()


if __name__ == "__main__":
    main()
