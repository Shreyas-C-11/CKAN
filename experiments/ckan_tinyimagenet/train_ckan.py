# train_ckan.py — Train CKAN (Conv KAN + KAN MLP) on TinyImageNet
#
# Usage:  python train_ckan.py
#
# This scaffold follows the existing MNIST/CIFAR-10 experiment layout.
# TinyImageNet is assumed to be arranged for torchvision.datasets.ImageFolder
# with:
#   ./data/tiny-imagenet-200/train/<class_id>/*.JPEG
#   ./data/tiny-imagenet-200/val/<class_id>/*.JPEG

import sys, os, glob, logging, re, json
from datetime import datetime
from typing import Optional

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
import numpy as np

from brevitas.nn import QuantHardTanh
from brevitas.core.scaling import ParameterScaling
from brevitas.core.quant import QuantType

from tinyimagenet_utils import ensure_tiny_imagenet


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
# TinyImageNet is 64×64 RGB with 200 classes.
# The scaffold keeps the CKAN design small enough to iterate quickly.
config = {
    "image_height": 64,
    "image_width": 64,

    # CKAN conv layers followed by 2×2 max pooling
    "conv_layers": [
        {"in_channels": 3,   "out_channels": 8,  "kernel_size": 3, "stride": 1,
         "in_precision": 8, "out_precision": 8},
        {"in_channels": 8,   "out_channels": 16, "kernel_size": 3, "stride": 1,
         "in_precision": 8, "out_precision": 8},
        {"in_channels": 16,  "out_channels": 32, "kernel_size": 3, "stride": 1,
         "in_precision": 8, "out_precision": 8},
        {"in_channels": 32,  "out_channels": 32, "kernel_size": 3, "stride": 1,
         "in_precision": 8, "out_precision": 8},
    ],

    "pool_size": 2,
    "pool_stride": 2,

    # 64 -> 62 -> 31 -> 29 -> 14 -> 12 -> 6 -> 4 -> 2, so flatten = 32 * 2 * 2 = 128
    "mlp_layers": [128, 256, 200],
    "mlp_bitwidth": [6, 6, 6],

    # shared KAN hyper-params
    "grid_size": 5,
    "spline_order": 3,
    "grid_eps": 0.05,
    "grid_range": [-4, 4],
    "base_activation": "nn.SiLU",

    # training
    "batch_size": 32,
    "num_epochs": 200,
    "learning_rate": 1e-3,
    "weight_decay": 1e-4,
    "scheduler_gamma": 0.998,

    # pruning
    "prune_threshold": 0.08,
    "target_epoch": 25,
    "warmup_epochs": 15,
    "random_seed": seed,

    # input quantization
    "input_bitwidth": 8,

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
    cuda=device.type == 'cuda',
).to(device)

# ─── Data ────────────────────────────────────────────────────────────
data_root = os.path.join(os.path.dirname(__file__), 'data')
dataset_root = ensure_tiny_imagenet(data_root)

train_transform = transforms.Compose([
    transforms.RandomResizedCrop(64, scale=(0.8, 1.0)),
    transforms.RandomHorizontalFlip(),
    transforms.ToTensor(),
    transforms.Normalize((0.4802, 0.4481, 0.3975), (0.2770, 0.2691, 0.2821)),
])
val_transform = transforms.Compose([
    transforms.Resize(64),
    transforms.CenterCrop(64),
    transforms.ToTensor(),
    transforms.Normalize((0.4802, 0.4481, 0.3975), (0.2770, 0.2691, 0.2821)),
])

trainset = torchvision.datasets.ImageFolder(root=os.path.join(dataset_root, 'train'), transform=train_transform)
valset = torchvision.datasets.ImageFolder(root=os.path.join(dataset_root, 'val'), transform=val_transform)
trainloader = DataLoader(trainset, batch_size=config['batch_size'], shuffle=True, num_workers=2, pin_memory=True)
valloader = DataLoader(valset, batch_size=config['batch_size'], shuffle=False, num_workers=2, pin_memory=True)

# ─── Model ───────────────────────────────────────────────────────────
model = CKANModel(config, input_layer, device).to(device)
optimizer = optim.AdamW(model.parameters(), lr=config['learning_rate'], weight_decay=config['weight_decay'])
scheduler = optim.lr_scheduler.ExponentialLR(optimizer, gamma=config['scheduler_gamma'])
criterion = nn.CrossEntropyLoss()

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
            images = images.view(-1, 3 * 64 * 64).to(device)
            labels = labels.to(device)
            output = model(images)
            val_loss += criterion(output, labels).item()
            val_acc += (output.argmax(1) == labels).float().mean().item()
    return val_loss / len(valloader), val_acc / len(valloader)

# ═══════════════════════════════════════════════════════════════════════
# Training loop
# ═══════════════════════════════════════════════════════════════════════
for epoch in range(resume_start_epoch, config['num_epochs']):
    model.train()
    with tqdm(trainloader, desc=f"Epoch {epoch+1}/{config['num_epochs']}") as pbar:
        for images, labels in pbar:
            images = images.view(-1, 3 * 64 * 64).to(device)
            labels = labels.to(device)

            optimizer.zero_grad()
            output = model(images)
            loss = criterion(output, labels)
            loss.backward()
            optimizer.step()

            acc = (output.argmax(1) == labels).float().mean()
            pbar.set_postfix(loss=f'{loss.item():.4f}', acc=f'{acc.item():.4f}',
                             lr=f'{optimizer.param_groups[0]["lr"]:.2e}')

    val_loss, val_acc = validate()
    scheduler.step()

    logging.info(
        f"Epoch {epoch+1}: train_loss={loss.item():.4f} "
        f"val_loss={val_loss:.4f} val_acc={val_acc:.4f}"
    )

    ckpt_path = os.path.join(
        model_dir,
        f"CKAN_acc{val_acc:.4f}_epoch{epoch+1}_remaining1.0000.pt",
    )
    torch.save({
        'epoch': epoch + 1,
        'model_state_dict': model.state_dict(),
        'optimizer_state_dict': optimizer.state_dict(),
        'scheduler_state_dict': scheduler.state_dict(),
        'val_accuracy': val_acc,
        'config': config,
    }, ckpt_path)

    if val_acc > best_val_accuracy:
        best_val_accuracy = val_acc
        best_path = os.path.join(model_dir, 'best.pt')
        torch.save({
            'epoch': epoch + 1,
            'model_state_dict': model.state_dict(),
            'optimizer_state_dict': optimizer.state_dict(),
            'scheduler_state_dict': scheduler.state_dict(),
            'val_accuracy': val_acc,
            'config': config,
        }, best_path)
        logging.info(f"Saved best checkpoint to {best_path}")

print(f"Training complete. Best val_acc={best_val_accuracy:.4f}")
