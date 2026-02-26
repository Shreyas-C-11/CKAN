//=====================================================
// Module: CKAN_Model_DUT
// Description:
//   - Design-Under-Test wrapper
//   - 28×28 input (1 channel, 4-bit pixels)
//   - OUT_WIDTH == VALUE_WIDTH (saturated conv output)
//   - Per-layer LUT files: kan_lut_conv0.mem, kan_lut_conv1.mem
//   - Architecture:
//       Layer 1: 28×28×1 → Conv 3×3 → 26×26×2 → Pool 2×2 → 13×13×2
//       Layer 2: 13×13×2 → Conv 3×3 → 11×11×2 → Pool 2×2 → 5×5×2
//       Flatten: 5×5×2×6b = 300-bit output vector
//=====================================================
module CKAN_Model_DUT (
    input  wire        clock,
    input  wire        sreset_n,
    input  wire        data_valid,
    input  wire [3:0]  pixel_in,       // 1 channel × 4 bits

    output wire [299:0] flat_out,      // 5×5×2×6 = 300 bits
    output wire         flat_valid,

    // Intermediate taps
    output wire [11:0]  l1_pool_out,   // 2 channels × 6 bits
    output wire         l1_pool_valid,
    output wire [11:0]  l2_pool_out,   // 2 channels × 6 bits
    output wire         l2_pool_valid
);

    CKAN_Model_Custom #(
        // Image
        .IMG_WIDTH           (28),
        .IMG_HEIGHT          (28),

        // Layer 1
        .L1_KERNEL_SIZE      (3),
        .L1_CONV_STRIDE      (1),
        .L1_INPUT_CHANNELS   (1),
        .L1_OUTPUT_CHANNELS  (2),
        .L1_DATA_WIDTH       (4),
        .L1_VALUE_WIDTH      (6),
        .L1_MEM_FILE         ("kan_lut_conv0.mem"),

        // Layer 2
        .L2_KERNEL_SIZE      (3),
        .L2_CONV_STRIDE      (1),
        .L2_INPUT_CHANNELS   (2),
        .L2_OUTPUT_CHANNELS  (2),
        .L2_DATA_WIDTH       (6),
        .L2_VALUE_WIDTH      (6),
        .L2_MEM_FILE         ("kan_lut_conv1.mem"),

        // Shared CKAN (OUT_WIDTH == VALUE_WIDTH for saturated output)
        .OUT_WIDTH           (6),

        // Shared pool
        .POOL_SIZE           (2),
        .POOL_STRIDE         (2),
        .SIGNED_DATA         (1)
    ) model_inst (
        .clock         (clock),
        .sreset_n      (sreset_n),
        .data_valid    (data_valid),
        .data_in       (pixel_in),
        .flat_out      (flat_out),
        .flat_valid    (flat_valid),
        .l1_pool_out   (l1_pool_out),
        .l1_pool_valid (l1_pool_valid),
        .l2_pool_out   (l2_pool_out),
        .l2_pool_valid (l2_pool_valid)
    );

endmodule
