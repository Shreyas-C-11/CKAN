"""
CKAN_Model — Full Convolutional KAN + KAN MLP model.

Architecture:
    image_input_layer (pixel quantization)
        → CKANConv2d layers  (KAN-based convolution)
        → Flatten
        → KANLinear MLP layers  (Kanele quantized KAN)
        → class logits

Designed for MNIST but configurable for other datasets.
"""

import torch
import torch.nn as nn
import math

from CKANConv2d import CKANConv2d
from KANQuant import KANLinear


class CKANModel(nn.Module):
    """
    Combined CKAN convolution + KAN MLP model.

    Args:
        config: dict with keys:
            conv_layers: list of dicts, each with
                in_channels, out_channels, kernel_size, stride,
                in_precision, out_precision
            mlp_layers: list of ints — neuron counts per MLP layer
            mlp_bitwidth: list of ints — bitwidth per MLP layer
            grid_size, spline_order, grid_eps, grid_range,
            base_activation  (all shared across conv + MLP)
        input_layer: QuantBrevitasActivation for quantizing raw image pixels
        device: 'cpu' or 'cuda'
    """

    def __init__(self, config, input_layer, device):
        super().__init__()
        self.config = config
        self.input_layer = input_layer
        self.device = device
        self.is_cuda = device == "cuda" if isinstance(device, str) else device.type == "cuda"

        shared = dict(
            grid_size=config["grid_size"],
            spline_order=config["spline_order"],
            grid_eps=config["grid_eps"],
            grid_range=config["grid_range"],
            base_activation=eval(config["base_activation"]),
            device=device,
        )

        # ── Pooling ──
        pool_size = config.get("pool_size", 2)
        pool_stride = config.get("pool_stride", 2)
        self.pool = nn.MaxPool2d(kernel_size=pool_size, stride=pool_stride)

        # ── CKAN convolution layers ──
        self.conv_layers = nn.ModuleList()
        for cfg in config["conv_layers"]:
            self.conv_layers.append(
                CKANConv2d(
                    in_channels=cfg["in_channels"],
                    out_channels=cfg["out_channels"],
                    kernel_size=cfg["kernel_size"],
                    stride=cfg.get("stride", 1),
                    in_precision=cfg["in_precision"],
                    out_precision=cfg["out_precision"],
                    **shared,
                )
            )

        # ── KAN MLP layers ──
        mlp_sizes = config["mlp_layers"]
        mlp_bw = config["mlp_bitwidth"]
        self.mlp_layers = nn.ModuleList()
        for in_f, in_bw, out_f, out_bw in zip(
            mlp_sizes[:-1], mlp_bw[:-1], mlp_sizes[1:], mlp_bw[1:]
        ):
            self.mlp_layers.append(
                KANLinear(
                    in_features=in_f,
                    in_precision=in_bw,
                    out_features=out_f,
                    out_precision=out_bw,
                    **shared,
                )
            )

        # store image shape for reshaping after input quantization
        self.img_channels = config["conv_layers"][0]["in_channels"]
        self.img_h = config["image_height"]
        self.img_w = config["image_width"]

    # ------------------------------------------------------------------
    def forward(self, x: torch.Tensor) -> torch.Tensor:
        """
        Args:
            x: [B, Cin*H*W] flat pixel vector  (matches Kanele convention)
        Returns:
            [B, num_classes]
        """
        # Quantize image pixels
        x = self.input_layer(x)

        # Reshape to spatial: [B, Cin, H, W]
        x = x.reshape(-1, self.img_channels, self.img_h, self.img_w)

        # CKAN conv layers (conv → pool, matching Verilog CKAN_Layer)
        for conv in self.conv_layers:
            x = conv(x)
            x = self.pool(x)

        # Flatten
        x = x.flatten(1)

        # KAN MLP layers
        for layer in self.mlp_layers:
            x = layer(x)

        return x

    # ------------------------------------------------------------------
    # Pruning (mirrors KANQuant.prune_below_threshold)
    # ------------------------------------------------------------------
    @torch.no_grad()
    def prune_below_threshold(self, threshold=0.01, epoch=0,
                              target_epoch=20, warmup_epochs=3):
        total_nodes = 0
        total_remaining = 0

        # Asymptotic pruning schedule
        t = max(epoch - warmup_epochs, 0)
        denom = max(target_epoch - warmup_epochs, 1)
        k = math.log(20.0) / denom
        scale = 1.0 - math.exp(-k * t)
        layer_threshold = min(threshold * scale, threshold)

        all_layers = []

        # Collect conv KAN layers
        for conv in self.conv_layers:
            all_layers.append(conv.kan)

        # Collect MLP layers
        for mlp in self.mlp_layers:
            all_layers.append(mlp)

        with torch.no_grad():
            for i, layer in enumerate(all_layers):
                # Determine input state space
                if i == 0:
                    input_ss = self.input_layer.get_state_space(self.is_cuda).to(self.device)
                else:
                    input_ss = all_layers[i - 1].output_quantizer.get_state_space(
                        self.is_cuda
                    ).to(self.device)

                next_sparsity = (
                    all_layers[i + 1].spline_selector
                    if i < len(all_layers) - 1
                    else None
                )

                layer.prune_below_threshold(
                    layer_threshold, next_sparsity, input_ss
                )
                total_nodes += layer.spline_selector.numel()
                total_remaining += layer.spline_selector.sum()

        return total_remaining / total_nodes

    # ------------------------------------------------------------------
    def regularization_loss(self, ra=1.0, re=10.0):
        loss = 0.0
        for conv in self.conv_layers:
            loss = loss + conv.regularization_loss(ra, re)
        for mlp in self.mlp_layers:
            loss = loss + mlp.regularization_loss(ra, re)
        return loss