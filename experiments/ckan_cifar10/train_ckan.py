# train_ckan.py — Train CKAN (Conv KAN + KAN MLP) on CIFAR-10
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
device = torch.device('cuda:1' if torch.cuda.is_available() else 'cpu')

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
# Configuration  —  PYNQ Z2 (XC7Z020) edition
# ═══════════════════════════════════════════════════════════════════════
#
# PYNQ Z2 resource budget (Zynq XC7Z020-1CLG400C):
#   ~53 200 LUTs, 140 BRAM36, 220 DSP48
#
# Design philosophy:
#   1. Keep conv channels tiny (4) to minimise KAN edge count.
#   2. Use grid_size=5 (8 spline coeffs/edge) instead of 15 (18).
#   3. Use 4-bit precision throughout → halves BRAM vs 8-bit.
#   4. Three stride-1 conv + pool stages shrink 32×32 → 2×2 before
#      flattening, giving a 16-element MLP input instead of 576.
#
# Architecture (stride-1 conv, 2×2 max-pool after each):
#   3×32×32 →[4-bit]→ CKANConv 3→4  K=3 S=1 → 4×30×30  → Pool → 4×15×15
#                    → CKANConv 4→4  K=3 S=1 → 4×13×13  → Pool → 4×6×6
#                    → CKANConv 4→4  K=3 S=1 → 4×4×4    → Pool → 4×2×2
#                    → Flatten(16)  → Kanele MLP  16→16→10
#
# Estimated KAN edge counts (edges × 8 spline coeffs each):
#   Conv0: 27×4  = 108 edges  →   864 LUT entries
#   Conv1: 36×4  = 144 edges  → 1 152 LUT entries
#   Conv2: 36×4  = 144 edges  → 1 152 LUT entries
#   MLP0:  16×16 = 256 edges  → 2 048 LUT entries
#   MLP1:  16×10 = 160 edges  → 1 280 LUT entries
#   TOTAL: 812 edges           → 6 496 LUT entries  ← fits Z2
#

# ── CIFAR-10 config (PYNQ Z2) ──
config = {
    "image_height": 32,
    "image_width": 32,

    # CKAN conv: compress 3-channel color → 4×2×2
    "conv_layers": [
        {"in_channels": 3, "out_channels": 4, "kernel_size": 3, "stride": 1,
         "in_precision": 4, "out_precision": 4},     # 3×32×32 → 4×30×30 → pool → 4×15×15
        {"in_channels": 4, "out_channels": 4, "kernel_size": 3, "stride": 1,
         "in_precision": 4, "out_precision": 4},     # 4×15×15 → 4×13×13 → pool → 4×6×6
        {"in_channels": 4, "out_channels": 4, "kernel_size": 3, "stride": 1,
         "in_precision": 4, "out_precision": 4},     # 4×6×6   → 4×4×4   → pool → 4×2×2
    ],

    # Pooling (applied after each conv layer)
    "pool_size": 2,
    "pool_stride": 2,

    # Kanele MLP: classify the compressed features
    "mlp_layers": [16, 16, 10],     # 4×2×2 = 16 → 16 → 10 classes
    "mlp_bitwidth": [4, 4, 4],

    # shared KAN hyper-params  (grid_size=5 → 8 coeffs/edge)
    "grid_size": 5,
    "spline_order": 3,
    "grid_eps": 0.05,
    "grid_range": [-4, 4],
    "base_activation": "nn.SiLU",

    # training — more epochs to compensate for smaller capacity
    "batch_size": 128,
    "num_epochs": 400,
    "learning_rate": 1e-2,
    "weight_decay": 1e-4,
    "scheduler_gamma": 0.997,

    # pruning
    "prune_threshold": 0.25,
    "target_epoch": 30,
    "warmup_epochs": 10,
    "random_seed": seed,

    # input quantization — 4-bit gives 16 levels per pixel
    "input_bitwidth": 4,

    # resume
    "resume": False,
    "resume_path": "models/",
}

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
    cuda=device.type == 'cuda',  # bool flag; GPU 1 selection is via .to(device)
).to(device)

# ─── Data ────────────────────────────────────────────────────────────
transform_train = transforms.Compose([
    transforms.RandomCrop(32, padding=4),
    transforms.RandomHorizontalFlip(),
    transforms.ToTensor(),
    transforms.Normalize((0.4914, 0.4822, 0.4465), (0.2470, 0.2435, 0.2616)),
])
transform_test = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.4914, 0.4822, 0.4465), (0.2470, 0.2435, 0.2616)),
])
trainset = torchvision.datasets.CIFAR10(root='./data', train=True,  download=True, transform=transform_train)
valset   = torchvision.datasets.CIFAR10(root='./data', train=False, download=True, transform=transform_test)
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
            images = images.view(-1, 3 * 32 * 32).to(device)
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
            images = images.view(-1, 3 * 32 * 32).to(device)
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
