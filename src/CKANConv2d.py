"""
CKANConv2d — Convolutional KAN layer (Python / PyTorch)

Mirrors the Verilog Conv2D_KAN hierarchy:
    pixel stream → ImageBufferChnl (KxK windows) → ConvolChnl_KAN → output

Implementation:
    unfold input → apply KANLinear (shared across spatial positions) → fold output

Each edge in the convolution graph has its own learned B-spline function,
replacing standard weight multiplication. For a KxK kernel with Cin input
channels and Cout output channels, there are Cout × Cin × K × K learned
univariate functions.

Verilog parameter mapping:
    KERNEL_SIZE     → kernel_size
    INPUT_CHANNELS  → in_channels
    OUTPUT_CHANNELS → out_channels
    DATA_WIDTH      → in_precision
    VALUE_WIDTH     → out_precision
    STRIDE          → stride
"""

import torch
import torch.nn as nn
from KANQuant import KANLinear


class CKANConv2d(nn.Module):
    """
    Convolutional KAN layer built on top of Kanele's KANLinear.

    Internally unfolds the 2-D input into KxK·Cin patches, applies a
    single KANLinear (in_features=K²·Cin, out_features=Cout), and folds
    the result back to a 2-D feature map.
    """

    def __init__(
        self,
        in_channels,
        out_channels,
        kernel_size,
        stride=1,
        in_precision=8,
        out_precision=8,
        grid_size=5,
        spline_order=3,
        scale_noise=0.1,
        scale_base=1.0,
        scale_spline=1.0,
        enable_standalone_scale_spline=True,
        base_activation=nn.SiLU,
        grid_eps=0.02,
        grid_range=[-1, 1],
        device=None,
    ):
        super().__init__()
        self.in_channels = in_channels
        self.out_channels = out_channels
        self.kernel_size = kernel_size
        self.stride = stride
        self.in_precision = in_precision
        self.out_precision = out_precision

        self.in_features = in_channels * kernel_size * kernel_size

        # nn.Unfold extracts sliding KxK patches — same role as
        # ImageBuf_KernelSlider in the Verilog design.
        self.unfold = nn.Unfold(kernel_size=kernel_size, stride=stride)

        # Core KAN layer — one learned B-spline per edge
        # (Cout × Cin × K × K univariate functions total).
        self.kan = KANLinear(
            in_features=self.in_features,
            in_precision=in_precision,
            out_features=out_channels,
            out_precision=out_precision,
            grid_size=grid_size,
            spline_order=spline_order,
            scale_noise=scale_noise,
            scale_base=scale_base,
            scale_spline=scale_spline,
            enable_standalone_scale_spline=enable_standalone_scale_spline,
            base_activation=base_activation,
            grid_eps=grid_eps,
            grid_range=grid_range,
            device=device,
        )

    # ------------------------------------------------------------------
    # Forward
    # ------------------------------------------------------------------
    def forward(self, x: torch.Tensor) -> torch.Tensor:
        """
        Args:
            x: [B, Cin, H, W]
        Returns:
            [B, Cout, H_out, W_out]
        """
        batch, cin, H, W = x.shape
        assert cin == self.in_channels

        # Unfold → [B, Cin·K·K, num_patches]
        patches = self.unfold(x)
        num_patches = patches.shape[2]

        # Reshape → [B·num_patches, Cin·K·K]  (each row is one receptive field)
        patches = patches.permute(0, 2, 1).reshape(-1, self.in_features)

        # Apply KAN → [B·num_patches, Cout]
        out = self.kan(patches)

        # Fold back → [B, Cout, H_out, W_out]
        H_out = (H - self.kernel_size) // self.stride + 1
        W_out = (W - self.kernel_size) // self.stride + 1
        out = out.reshape(batch, num_patches, self.out_channels)
        out = out.permute(0, 2, 1).reshape(batch, self.out_channels, H_out, W_out)
        return out

    # ------------------------------------------------------------------
    # Delegates to KANLinear
    # ------------------------------------------------------------------
    @torch.no_grad()
    def prune_below_threshold(self, threshold, next_layer_sparsity_matrix=None,
                              input_state_space=None):
        self.kan.prune_below_threshold(threshold, next_layer_sparsity_matrix,
                                       input_state_space)

    def regularization_loss(self, regularize_activation=1.0, regularize_entropy=10.0):
        return self.kan.regularization_loss(regularize_activation, regularize_entropy)
