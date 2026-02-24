# benchmark_fpga.py — Measure real inference FPS on PYNQ-Z2
#
# Run this ON the PYNQ-Z2 board (via Jupyter or SSH):
#   python benchmark_fpga.py --bitstream ckan_cifar10.bit --num_images 1000
#
# Measures:
#   - Latency per image (µs)
#   - Throughput (images/second = FPS)
#   - Total inference time
#   - Accuracy on CIFAR-10 test set

import numpy as np
import time
import argparse
import json
import os

def load_test_data(data_dir="fpga_test_data", num_images=100):
    """Load pre-generated hex pixel streams and labels."""
    labels = []
    images = []
    
    label_path = os.path.join(data_dir, "test_labels.txt")
    with open(label_path, 'r') as f:
        labels = [int(line.strip()) for line in f.readlines()]
    
    pixel_dir = os.path.join(data_dir, "pixel_streams")
    hex_files = sorted([f for f in os.listdir(pixel_dir) if f.endswith('.hex')])
    
    for hex_file in hex_files[:num_images]:
        pixels = []
        with open(os.path.join(pixel_dir, hex_file), 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('//'):
                    pixels.append(int(line, 16))
        images.append(np.array(pixels, dtype=np.uint8))
    
    return images[:num_images], labels[:num_images]


def benchmark_dma(overlay, images, labels, num_runs=3):
    """Benchmark using DMA transfer (AXI Stream interface)."""
    from pynq import allocate
    
    dma = overlay.axi_dma
    num_images = len(images)
    
    # Allocate buffers
    input_buffer = allocate(shape=(3072,), dtype=np.uint8)  # 3×32×32 for CIFAR-10
    output_buffer = allocate(shape=(10,), dtype=np.int16)  # 10 class logits
    
    # Warmup (5 images)
    for i in range(min(5, num_images)):
        input_buffer[:] = images[i]
        dma.sendchannel.transfer(input_buffer)
        dma.recvchannel.transfer(output_buffer)
        dma.sendchannel.wait()
        dma.recvchannel.wait()
    
    # Timed runs
    latencies = []
    all_times = []
    correct = 0
    
    for run in range(num_runs):
        run_correct = 0
        run_start = time.perf_counter()
        
        for i in range(num_images):
            input_buffer[:] = images[i]
            
            t0 = time.perf_counter()
            dma.sendchannel.transfer(input_buffer)
            dma.recvchannel.transfer(output_buffer)
            dma.sendchannel.wait()
            dma.recvchannel.wait()
            t1 = time.perf_counter()
            
            latencies.append(t1 - t0)
            
            pred = np.argmax(output_buffer)
            if pred == labels[i]:
                run_correct += 1
        
        run_time = time.perf_counter() - run_start
        all_times.append(run_time)
        correct = run_correct  # use last run's accuracy
    
    # Free buffers
    del input_buffer, output_buffer
    
    return latencies, all_times, correct


def benchmark_mmio(overlay, images, labels, num_runs=3):
    """Benchmark using MMIO (memory-mapped register interface).
    
    Use this if your design uses AXI-Lite instead of AXI Stream.
    Adjust register offsets based on your Vivado block design.
    """
    # Example register offsets (adjust for your design)
    CTRL_REG    = 0x00
    STATUS_REG  = 0x04
    DATA_IN_REG = 0x10
    DATA_OUT_BASE = 0x20
    
    ip = overlay.ckan_ip  # adjust IP name
    
    num_images = len(images)
    latencies = []
    all_times = []
    correct = 0
    
    for run in range(num_runs):
        run_correct = 0
        run_start = time.perf_counter()
        
        for i in range(num_images):
            t0 = time.perf_counter()
            
            # Assert reset
            ip.write(CTRL_REG, 0x0)
            ip.write(CTRL_REG, 0x1)  # release reset
            
            # Stream pixels one by one
            for pixel in images[i]:
                ip.write(DATA_IN_REG, int(pixel))
            
            # Wait for done
            while ip.read(STATUS_REG) & 0x1 == 0:
                pass
            
            # Read output logits
            outputs = []
            for j in range(10):
                val = ip.read(DATA_OUT_BASE + j * 4)
                # Convert from unsigned to signed (16-bit)
                if val >= 0x8000:
                    val -= 0x10000
                outputs.append(val)
            
            t1 = time.perf_counter()
            latencies.append(t1 - t0)
            
            pred = np.argmax(outputs)
            if pred == labels[i]:
                run_correct += 1
        
        run_time = time.perf_counter() - run_start
        all_times.append(run_time)
        correct = run_correct
    
    return latencies, all_times, correct


def print_results(latencies, all_times, correct, num_images, num_runs):
    """Print formatted benchmark results."""
    latencies = np.array(latencies)
    
    # Per-image stats (exclude first few as warmup)
    warmup = min(10, len(latencies) // 10)
    steady = latencies[warmup:]
    
    avg_latency_us = np.mean(steady) * 1e6
    min_latency_us = np.min(steady) * 1e6
    max_latency_us = np.max(steady) * 1e6
    p50_latency_us = np.percentile(steady, 50) * 1e6
    p99_latency_us = np.percentile(steady, 99) * 1e6
    
    # Throughput
    avg_total_time = np.mean(all_times)
    fps = num_images / avg_total_time
    
    accuracy = correct / num_images * 100
    
    print()
    print("=" * 65)
    print("  CKAN FPGA Inference Benchmark — PYNQ-Z2 (CIFAR-10)")
    print("=" * 65)
    print(f"  Images tested:     {num_images}")
    print(f"  Benchmark runs:    {num_runs}")
    print(f"  Accuracy:          {correct}/{num_images} ({accuracy:.2f}%)")
    print("-" * 65)
    print(f"  Latency (per image):")
    print(f"    Average:         {avg_latency_us:>10.1f} µs")
    print(f"    Median (p50):    {p50_latency_us:>10.1f} µs")
    print(f"    Min:             {min_latency_us:>10.1f} µs")
    print(f"    Max:             {max_latency_us:>10.1f} µs")
    print(f"    p99:             {p99_latency_us:>10.1f} µs")
    print("-" * 65)
    print(f"  Throughput:")
    print(f"    FPS:             {fps:>10.0f} images/sec")
    print(f"    Total time:      {avg_total_time:>10.3f} s (for {num_images} images)")
    print(f"    Time per image:  {avg_total_time/num_images*1000:>10.3f} ms")
    print("=" * 65)
    print()
    
    # Return results dict for saving
    return {
        "num_images": num_images,
        "num_runs": num_runs,
        "accuracy_pct": round(accuracy, 2),
        "correct": correct,
        "latency_us": {
            "mean": round(avg_latency_us, 1),
            "median_p50": round(p50_latency_us, 1),
            "min": round(min_latency_us, 1),
            "max": round(max_latency_us, 1),
            "p99": round(p99_latency_us, 1),
        },
        "throughput": {
            "fps": round(fps, 1),
            "total_time_s": round(avg_total_time, 3),
            "ms_per_image": round(avg_total_time / num_images * 1000, 3),
        },
    }


def main():
    parser = argparse.ArgumentParser(description="CKAN FPGA Inference Benchmark (CIFAR-10)")
    parser.add_argument("--bitstream", type=str, required=True,
                        help="Path to .bit file (e.g., ckan_cifar10.bit)")
    parser.add_argument("--data_dir", type=str, default="fpga_test_data",
                        help="Directory with pixel streams and labels")
    parser.add_argument("--num_images", type=int, default=100,
                        help="Number of images to benchmark")
    parser.add_argument("--num_runs", type=int, default=3,
                        help="Number of timed runs (results averaged)")
    parser.add_argument("--interface", type=str, default="dma",
                        choices=["dma", "mmio"],
                        help="FPGA interface type: dma (AXI Stream) or mmio (AXI-Lite)")
    parser.add_argument("--output", type=str, default="benchmark_results.json",
                        help="Save results to JSON file")
    args = parser.parse_args()
    
    # Load test data
    print(f"Loading test data from {args.data_dir}...")
    images, labels = load_test_data(args.data_dir, args.num_images)
    num_images = len(images)
    print(f"  Loaded {num_images} images")
    
    # Load FPGA overlay
    print(f"\nLoading bitstream: {args.bitstream}...")
    from pynq import Overlay
    overlay = Overlay(args.bitstream)
    print(f"  Bitstream loaded successfully")
    print(f"  IP blocks: {list(overlay.ip_dict.keys())}")
    
    # Run benchmark
    print(f"\nRunning benchmark ({args.num_runs} runs × {num_images} images)...")
    
    if args.interface == "dma":
        latencies, all_times, correct = benchmark_dma(
            overlay, images, labels, args.num_runs)
    else:
        latencies, all_times, correct = benchmark_mmio(
            overlay, images, labels, args.num_runs)
    
    # Print & save results
    results = print_results(latencies, all_times, correct, num_images, args.num_runs)
    results["bitstream"] = args.bitstream
    results["interface"] = args.interface
    results["board"] = "PYNQ-Z2 (XC7Z020)"
    
    with open(args.output, 'w') as f:
        json.dump(results, f, indent=2)
    print(f"Results saved to {args.output}")


if __name__ == "__main__":
    main()
