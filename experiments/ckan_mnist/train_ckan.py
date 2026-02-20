# train_ckan.py — Train CKAN (Conv KAN + KAN MLP) on MNIST
#
# Usage:  python train_ckan.py
#
# Based on the existing Kanele train_quant.py but replaces the flat
# KAN MLP with CKANConv2d → flatten → KANLinear MLP.

import sys, os, glob, logging, re, json, math
from datetime import datetime

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', 'src'))

from CKAN_Model import CKANModel
from quant import QuantBrevitasActivation, ScalarBiasScale

import torch
import torch.nn as nn
import torch.optim as optim
import torchvision
import torchvision.transforms as transforms
from torch.utils.data import DataLoader
from tqdm import tqdm
from typing import Optional
import numpy as np

from brevitas.nn import QuantHardTanh
from brevitas.core.scaling import ParameterScaling
from brevitas.core.quant import QuantType


# ─── Helpers ─────────────────────────────────────────────────────────
def _extract_epoch(fname: str) -> int:
    m = re.search(r'epoch(\d+)', os.path.basename(fname))
    return int(m.group(1)) if m else -1


def find_latest_checkpoint(path_like: str) -> Optional[str]:
    if os.path.isfile(path_like):
        return path_like
    if os.path.isdir(path_like):
        cands = sorted(
            glob.glob(os.path.join(path_like, '*.pt')),
            key=lambda p: (_extract_epoch(p), p),
        )
        return cands[-1] if cands else None
    return None


# ─── Seed ────────────────────────────────────────────────────────────
seed = 3321
torch.manual_seed(seed)
np.random.seed(seed)
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

# ─── Logging ─────────────────────────────────────────────────────────
os.makedirs('checkpoints', exist_ok=True)
logging.basicConfig(
    filename='training_ckan.log', filemode='a',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
)
console = logging.StreamHandler()
console.setLevel(logging.INFO)
console.setFormatter(logging.Formatter('%(message)s'))
logging.getLogger().addHandler(console)

# ═══════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════
#
# Design philosophy:
#   CKAN conv layers  = spatial compressor (4-bit color in → small feature map)
#   Kanele KAN MLP    = classifier (small flat vector → class logits)
#
# Architecture matches Verilog CKAN_Model.v:
#   - Stride-1 convolutions for feature extraction
#   - 2×2 max pooling for spatial downsampling
#   - This differs from pure stride-2 conv; pooling preserves more features
#
# ─── MNIST (1ch grayscale) ───
#   1×28×28 →[8-bit]→ CKANConv 1→2 K=3 S=1 → 26×26×2 → Pool 2×2 → 13×13×2
#                    → CKANConv 2→2 K=3 S=1 → 11×11×2 → Pool 2×2 →  5×5×2
#                    → Flatten(50) → Kanele MLP 50→32→10
#
# ─── CIFAR-10 (3ch color) — uncomment to use ───
#   3×32×32 →[8-bit]→ CKANConv 3→8  K=3 S=1 → 30×30×8  → Pool 2×2 → 15×15×8
#                    → CKANConv 8→16 K=3 S=1 → 13×13×16 → Pool 2×2 →  6×6×16
#                    → Flatten(576) → Kanele MLP 576→64→10
#

# ── MNIST config (matches Verilog CKAN_Model_DUT.v) ──
config = {
    "image_height": 28,
    "image_width": 28,

    # CKAN conv: stride-1 convolutions with 2×2 pooling
    "conv_layers": [
        {"in_channels": 1, "out_channels": 2, "kernel_size": 3, "stride": 1,
         "in_precision": 4, "out_precision": 8},     # 1×28×28 → 2×26×26 → pool → 2×13×13
        {"in_channels": 2, "out_channels": 2, "kernel_size": 3, "stride": 1,
         "in_precision": 4, "out_precision": 8},   # 2×13×13 → 2×11×11 → pool → 2×5×5
    ],

    # Pooling (applied after each conv layer)
    "pool_size": 2,
    "pool_stride": 2,

    # Kanele MLP: classify the compressed features
    "mlp_layers": [50, 32, 10],     # 2×5×5 = 50 → 32 → 10 classes
    "mlp_bitwidth": [8, 8, 8],

    # shared KAN hyper-params
    "grid_size": 15,
    "spline_order": 3,
    "grid_eps": 0.05,
    "grid_range": [-4, 4],
    "base_activation": "nn.SiLU",

    # training
    "batch_size": 256,
    "num_epochs": 200,
    "learning_rate": 1e-2,
    "weight_decay": 1e-4,
    "scheduler_gamma": 0.995,

    # pruning
    "prune_threshold": 0.3,
    "target_epoch": 20,
    "warmup_epochs": 5,
    "random_seed": seed,

    # input quantization — 4-bit gives 16 levels per pixel
    "input_bitwidth": 4,

    # resume
    "resume": False,
    "resume_path": "models/",
}

# # ── CIFAR-10 config (uncomment to use) ──
# config = {
#     "image_height": 32,
#     "image_width": 32,
#
#     # CKAN conv: compress 3-channel 4-bit color → 16×6×6
#     "conv_layers": [
#         {"in_channels": 3,  "out_channels": 8,  "kernel_size": 3, "stride": 1,
#          "in_precision": 4, "out_precision": 6},       # 3×32×32 → 8×30×30
#         {"in_channels": 8,  "out_channels": 16, "kernel_size": 3, "stride": 2,
#          "in_precision": 6, "out_precision": 6},        # 8×30×30 → 16×14×14
#         {"in_channels": 16, "out_channels": 16, "kernel_size": 3, "stride": 2,
#          "in_precision": 6, "out_precision": 6},        # 16×14×14 → 16×6×6
#     ],
#
#     # Kanele MLP: classify the compressed features
#     "mlp_layers": [576, 64, 10],    # 16×6×6 = 576 → 64 → 10 classes
#     "mlp_bitwidth": [6, 6, 6],
#
#     "grid_size": 15,
#     "spline_order": 3,
#     "grid_eps": 0.05,
#     "grid_range": [-4, 4],
#     "base_activation": "nn.SiLU",
#
#     "batch_size": 128,
#     "num_epochs": 300,
#     "learning_rate": 1e-2,
#     "weight_decay": 1e-4,
#     "scheduler_gamma": 0.995,
#
#     "prune_threshold": 0.3,
#     "target_epoch": 25,
#     "warmup_epochs": 5,
#     "random_seed": seed,
#
#     "input_bitwidth": 4,    # 4-bit: 16 levels per channel per pixel
#
#     "resume": False,
#     "resume_path": "models/",
# }

# ─── Resume logic ────────────────────────────────────────────────────
resume_checkpoint_path = None
resume_start_epoch = 0

if config.get('resume', False):
    resume_checkpoint_path = find_latest_checkpoint(config.get('resume_path', 'models'))
    if resume_checkpoint_path is None:
        logging.warning("Resume requested but no checkpoint found. Starting fresh.")

if resume_checkpoint_path is not None:
    model_dir = os.path.dirname(resume_checkpoint_path)
else:
    model_dir = f'models/{datetime.now().strftime("%Y%m%d_%H%M%S")}'
os.makedirs(model_dir, exist_ok=True)

with open(f'{model_dir}/config.json', 'w') as f:
    json.dump(config, f, indent=2)

# ─── Input layer (pixel quantization) ────────────────────────────────
bn_in = nn.BatchNorm1d(28 * 28)
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
    cuda=device.type == 'cuda',
).to(device)

# ─── Data ────────────────────────────────────────────────────────────
transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.1307,), (0.3081,)),
])
trainset = torchvision.datasets.MNIST(root='./data', train=True,  download=False, transform=transform)
valset   = torchvision.datasets.MNIST(root='./data', train=False, download=False, transform=transform)
trainloader = DataLoader(trainset, batch_size=config['batch_size'], shuffle=True)
valloader   = DataLoader(valset,   batch_size=config['batch_size'], shuffle=False)

# ─── Model ───────────────────────────────────────────────────────────
model = CKANModel(config, input_layer, device).to(device)
optimizer  = optim.AdamW(model.parameters(), lr=config['learning_rate'],
                         weight_decay=config['weight_decay'])
scheduler  = optim.lr_scheduler.ExponentialLR(optimizer, gamma=config['scheduler_gamma'])
criterion  = nn.CrossEntropyLoss()

# ─── Resume ──────────────────────────────────────────────────────────
best_val_accuracy = 0.0

if resume_checkpoint_path is not None:
    logging.info(f"Resuming from checkpoint: {resume_checkpoint_path}")
    ckpt = torch.load(resume_checkpoint_path, map_location=device)
    model.load_state_dict(ckpt['model_state_dict'])
    optimizer.load_state_dict(ckpt['optimizer_state_dict'])
    if 'scheduler_state_dict' in ckpt:
        try:
            scheduler.load_state_dict(ckpt['scheduler_state_dict'])
        except Exception as e:
            logging.warning(f"Could not load scheduler: {e}")
    resume_start_epoch = int(ckpt.get('epoch', 0))
    best_val_accuracy = float(ckpt.get('val_accuracy', 0.0))
    logging.info(f"Loaded epoch={resume_start_epoch}, val_acc={best_val_accuracy:.4f}")

# ─── Validation ──────────────────────────────────────────────────────
def validate():
    model.eval()
    val_loss = val_acc = 0.0
    with torch.no_grad():
        for images, labels in valloader:
            images = images.view(-1, 28 * 28).to(device)
            labels = labels.to(device)
            output = model(images)
            val_loss += criterion(output, labels).item()
            val_acc  += (output.argmax(1) == labels).float().mean().item()
    return val_loss / len(valloader), val_acc / len(valloader)

# ═══════════════════════════════════════════════════════════════════════
# Training loop
# ═══════════════════════════════════════════════════════════════════════
for epoch in range(resume_start_epoch, config['num_epochs']):
    model.train()
    with tqdm(trainloader, desc=f"Epoch {epoch+1}/{config['num_epochs']}") as pbar:
        for images, labels in pbar:
            images = images.view(-1, 28 * 28).to(device)
            labels = labels.to(device)

            optimizer.zero_grad()
            output = model(images)
            loss = criterion(output, labels)
            loss.backward()
            optimizer.step()

            acc = (output.argmax(1) == labels).float().mean()
            pbar.set_postfix(loss=f'{loss.item():.4f}', acc=f'{acc.item():.4f}',
                             lr=f'{optimizer.param_groups[0]["lr"]:.2e}')

    # Prune
    remaining = model.prune_below_threshold(
        threshold=config['prune_threshold'],
        epoch=epoch,
        target_epoch=config['target_epoch'],
        warmup_epochs=config['warmup_epochs'],
    )
    print(f"Remaining fraction: {remaining:.4f}")

    # Validate
    val_loss, val_accuracy = validate()
    scheduler.step()

    logging.info(
        f"Epoch {epoch+1:03d} | Val Loss: {val_loss:.4f} | "
        f"Val Acc: {val_accuracy:.4f} | Remaining: {remaining:.4f}"
    )

    # Save checkpoint
    ckpt_path = (
        f'{model_dir}/CKAN_acc{val_accuracy:.4f}_epoch{epoch+1}'
        f'_remaining{remaining:.4f}.pt'
    )
    torch.save({
        'epoch': epoch + 1,
        'model_state_dict': model.state_dict(),
        'optimizer_state_dict': optimizer.state_dict(),
        'scheduler_state_dict': scheduler.state_dict(),
        'val_accuracy': val_accuracy,
        'val_loss': val_loss,
        'remaining_fraction': remaining,
    }, ckpt_path)
    logging.info(f"Checkpoint saved: {ckpt_path}")
