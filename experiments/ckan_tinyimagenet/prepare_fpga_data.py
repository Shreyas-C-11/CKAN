# prepare_fpga_data.py — Convert TinyImageNet images to FPGA-ready hex files
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
#
# Assumes TinyImageNet is organized for torchvision.datasets.ImageFolder:
#   ./data/tiny-imagenet-200/train/<class_id>/*.JPEG
#   ./data/tiny-imagenet-200/val/<class_id>/*.JPEG

import sys, os, json, argparse
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

from tinyimagenet_utils import ensure_tiny_imagenet


def main():
    parser = argparse.ArgumentParser(description="Prepare TinyImageNet data for FPGA inference")
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
    device = "cpu"

    transform = transforms.Compose([
        transforms.Resize(64),
        transforms.CenterCrop(64),
        transforms.ToTensor(),
        transforms.Normalize((0.4802, 0.4481, 0.3975), (0.2770, 0.2691, 0.2821)),
    ])
    data_root = os.path.join(os.path.dirname(__file__), 'data')
    dataset_root = ensure_tiny_imagenet(data_root)
    testset = torchvision.datasets.ImageFolder(root=os.path.join(dataset_root, 'val'), transform=transform)

    num_images = min(args.num_images, len(testset))
    print(f"Exporting {num_images} TinyImageNet test images to {args.output_dir}/")

    print("\n[1/4] Generating raw pixel streams...")
    pixel_dir = os.path.join(args.output_dir, "pixel_streams")
    os.makedirs(pixel_dir, exist_ok=True)

    labels = []
    x_test = []
    for idx in range(num_images):
        image, label = testset[idx]
        labels.append(label)

        raw_pixels = image.permute(1, 2, 0).clone()
        raw_pixels = (raw_pixels * torch.tensor([0.2770, 0.2691, 0.2821]).view(1, 1, 3) +
                      torch.tensor([0.4802, 0.4481, 0.3975]).view(1, 1, 3)) * 255.0
        raw_pixels = raw_pixels.clamp(0, 255).to(torch.uint8)
        x_test.append(raw_pixels.cpu().numpy())

        hex_path = os.path.join(pixel_dir, f"image_{idx:04d}_label{label}.hex")
        with open(hex_path, 'w') as f:
            for row in range(64):
                for col in range(64):
                    r, g, b = raw_pixels[row, col].tolist()
                    f.write(f"{int(r):02X}{int(g):02X}{int(b):02X}\n")

    label_path = os.path.join(args.output_dir, "test_labels.txt")
    with open(label_path, 'w') as f:
        for lbl in labels:
            f.write(f"{lbl}\n")
    print(f"  ✓ {num_images} pixel streams → {pixel_dir}/")
    print(f"  ✓ Labels → {label_path}")

    x_test_path = os.path.join(args.output_dir, "x_test.npy")
    y_test_path = os.path.join(args.output_dir, "y_test.npy")
    np.save(x_test_path, np.stack(x_test, axis=0))
    np.save(y_test_path, np.array(labels, dtype=np.int64))
    print(f"  ✓ X test data → {x_test_path}")
    print(f"  ✓ Y test data → {y_test_path}")

    combined_path = os.path.join(args.output_dir, "all_pixels.hex")
    with open(combined_path, 'w') as f:
        for idx in range(num_images):
            image, label = testset[idx]
            raw_pixels = image.permute(1, 2, 0).clone()
            raw_pixels = (raw_pixels * torch.tensor([0.2770, 0.2691, 0.2821]).view(1, 1, 3) +
                          torch.tensor([0.4802, 0.4481, 0.3975]).view(1, 1, 3)) * 255.0
            raw_pixels = raw_pixels.clamp(0, 255).to(torch.uint8)
            f.write(f"// Image {idx} (label={label})\n")
            for row in range(64):
                for col in range(64):
                    r, g, b = raw_pixels[row, col].tolist()
                    f.write(f"{int(r):02X}{int(g):02X}{int(b):02X}\n")
    print(f"  ✓ Combined stream → {combined_path}")

    if args.raw_only:
        print("\n✓ Raw pixel export complete (--raw_only mode)")
        return

    if args.model_dir is None:
        print("\n⚠ Skipping MLP test vectors (no --model_dir provided)")
        print("  Run with: python prepare_fpga_data.py --model_dir models/<your_run>")
        _write_summary(args.output_dir, num_images, labels, has_mlp_vectors=False)
        return

    print(f"\n[2/4] Loading model from {args.model_dir}...")
    config_path = os.path.join(args.model_dir, "config.json")
    with open(config_path, 'r') as f:
        config = json.load(f)

    files = [f for f in os.listdir(args.model_dir) if f.endswith('.pt')]
    if not files:
        raise FileNotFoundError(f"No checkpoints in '{args.model_dir}'")
    files.sort(key=lambda x: float(x.split('_acc')[1].split('_epoch')[0]), reverse=True)
    best_ckpt = os.path.join(args.model_dir, files[0])
    print(f"  Using checkpoint: {best_ckpt}")

    bn_in = nn.BatchNorm1d(3 * 64 * 64)
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
    checkpoint = torch.load(best_ckpt, map_location=device)
    model.load_state_dict(checkpoint['model_state_dict'])
    model.eval()
    print(f"  Model loaded — val_acc: {checkpoint.get('val_accuracy', 'N/A')}")

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
                x = image.view(1, -1).to(device)

                x_q = model.input_layer(x)
                x_spatial = x_q.reshape(1, 3, 64, 64)
                for conv in model.conv_layers:
                    x_spatial = conv(x_spatial)
                    x_spatial = model.pool(x_spatial)

                mlp_input = x_spatial.flatten(1)
                mlp_output = mlp_input.clone()
                for layer in model.mlp_layers:
                    mlp_output = layer(mlp_output)

                pred = mlp_output.argmax(1).item()
                if pred == label:
                    correct += 1

                last_conv_quant = model.conv_layers[-1].kan.output_quantizer
                scale, bits = last_conv_quant.get_scale_factor_bits(False)
                mlp_in_ints = (mlp_input / scale).round().to(torch.int).squeeze()

                last_mlp_quant = model.mlp_layers[-1].output_quantizer
                out_scale, out_bits = last_mlp_quant.get_scale_factor_bits(False)
                mlp_out_ints = (mlp_output / out_scale).round().to(torch.int).squeeze()

                fin.write(" ".join(str(v.item()) for v in mlp_in_ints) + "\n")
                fout.write(" ".join(str(v.item()) for v in mlp_out_ints) + "\n")
                fpred.write(f"{pred} (label={label})\n")

    acc = correct / num_images * 100
    print(f"  ✓ MLP inputs  → {vectors_in_path}")
    print(f"  ✓ MLP outputs → {vectors_out_path}")
    print(f"  ✓ Predictions → {predictions_path}")
    print(f"  Model accuracy on exported set: {correct}/{num_images} ({acc:.1f}%)")

    print("\n[4/4] Writing summary...")
    _write_summary(args.output_dir, num_images, labels, has_mlp_vectors=True,
                   accuracy=acc, model_dir=args.model_dir)


def _write_summary(output_dir, num_images, labels, has_mlp_vectors=False,
                   accuracy=None, model_dir=None):
    summary = {
        "num_images": num_images,
        "image_size": "64x64",
        "pixel_format": "8-bit RGB, row-major, one hex triplet per line",
        "label_distribution": {str(i): labels.count(i) for i in sorted(set(labels))},
        "has_mlp_vectors": has_mlp_vectors,
    }
    if accuracy is not None:
        summary["model_accuracy"] = f"{accuracy:.1f}%"
    if model_dir is not None:
        summary["model_dir"] = model_dir

    summary["files"] = {
        "pixel_streams/image_NNNN_labelL.hex": "Individual 64x64 RGB pixel streams (raw 8-bit)",
        "all_pixels.hex": "All images concatenated (with // comments)",
        "test_labels.txt": "Ground-truth labels (one per line)",
        "x_test.npy": "Test images as uint8 arrays for deployment.ipynb",
        "y_test.npy": "Test labels as int64 array for deployment.ipynb",
    }
    if has_mlp_vectors:
        summary["files"]["vectors_in.txt"] = "Quantized MLP inputs"
        summary["files"]["vectors_out.txt"] = "Quantized MLP outputs"
        summary["files"]["predictions.txt"] = "Model predictions"

    with open(os.path.join(output_dir, "test_summary.json"), 'w') as f:
        json.dump(summary, f, indent=2)
    print(f"  ✓ Summary → {os.path.join(output_dir, 'test_summary.json')}")


if __name__ == "__main__":
    main()
