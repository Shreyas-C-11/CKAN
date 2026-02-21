//=====================================================
// Module: CKAN_Model
// Description:
//   - 2-layer CKAN CNN model
//   - Layer 1: Conv2D_KAN + MaxPool2D
//   - Layer 2: Conv2D_KAN + MaxPool2D
//   - Flatten: collects final feature map into vector
//   - Dataflow:
//       pixel stream
//          ↓
//       CKAN_Layer 1 (conv + pool)
//          ↓
//       CKAN_Layer 2 (conv + pool)
//          ↓
//       Flatten → flat_out + flat_valid
//=====================================================
//
module CKAN_Model #(
    // ---------------- Image Parameters ----------------
    parameter IMG_WIDTH        = 5,
    parameter IMG_HEIGHT       = 5,

    // ---------------- Shared Conv Parameters ----------------
    parameter KERNEL_SIZE      = 3,
    parameter CONV_STRIDE      = 1,

    // ---------------- Layer 1 Parameters ----------------
    parameter L1_INPUT_CHANNELS  = 3,
    parameter L1_OUTPUT_CHANNELS = 2,
    parameter L1_DATA_WIDTH      = 8,

    // ---------------- Layer 2 Parameters ----------------
    parameter L2_OUTPUT_CHANNELS = 2,

    // ---------------- Shared CKAN Parameters ----------------
    parameter VALUE_WIDTH      = 8,
    parameter OUT_WIDTH        = 16,

    // ---------------- Shared Pool Parameters ----------------
    parameter POOL_SIZE        = 2,
    parameter POOL_STRIDE      = 2,
    parameter SIGNED_DATA      = 1,

    // ---------------- Derived Parameters (do not override) ----------------
    parameter L1_CONV_OUT_W = (IMG_WIDTH  - KERNEL_SIZE) / CONV_STRIDE + 1,
    parameter L1_CONV_OUT_H = (IMG_HEIGHT - KERNEL_SIZE) / CONV_STRIDE + 1,
    parameter L1_POOL_OUT_W = (L1_CONV_OUT_W - POOL_SIZE) / POOL_STRIDE + 1,
    parameter L1_POOL_OUT_H = (L1_CONV_OUT_H - POOL_SIZE) / POOL_STRIDE + 1,

    parameter L2_CONV_OUT_W = (L1_POOL_OUT_W - KERNEL_SIZE) / CONV_STRIDE + 1,
    parameter L2_CONV_OUT_H = (L1_POOL_OUT_H - KERNEL_SIZE) / CONV_STRIDE + 1,
    parameter L2_POOL_OUT_W = (L2_CONV_OUT_W - POOL_SIZE) / POOL_STRIDE + 1,
    parameter L2_POOL_OUT_H = (L2_CONV_OUT_H - POOL_SIZE) / POOL_STRIDE + 1,

    parameter FLAT_OUT_WIDTH = L2_POOL_OUT_W * L2_POOL_OUT_H * L2_OUTPUT_CHANNELS * OUT_WIDTH
)(
    // ---------------- I/O Ports ----------------
    input  wire                                     clock,
    input  wire                                     sreset_n,
    input  wire                                     data_valid,
    input  wire [L1_INPUT_CHANNELS*L1_DATA_WIDTH-1:0] data_in,

    // ---------------- Final Output ----------------
    output wire [FLAT_OUT_WIDTH-1:0]                flat_out,
    output wire                                     flat_valid,

    // ---------------- Intermediate Taps ----------------
    output wire [L1_OUTPUT_CHANNELS*OUT_WIDTH-1:0]  l1_pool_out,
    output wire                                     l1_pool_valid,
    output wire [L2_OUTPUT_CHANNELS*OUT_WIDTH-1:0]  l2_pool_out,
    output wire                                     l2_pool_valid
);

    //=====================================================
    // Derived Parameters
    //=====================================================
    localparam L2_INPUT_CHANNELS = L1_OUTPUT_CHANNELS;
    localparam L2_DATA_WIDTH     = OUT_WIDTH;

    //=====================================================
    // Internal signals
    //=====================================================
    wire [L1_OUTPUT_CHANNELS*OUT_WIDTH-1:0] l1_conv_out;
    wire                                    l1_conv_valid;
    wire [L2_OUTPUT_CHANNELS*OUT_WIDTH-1:0] l2_conv_out;
    wire                                    l2_conv_valid;

    //=====================================================
    // Layer 1: CKAN Conv + Pool
    //=====================================================
    CKAN_Layer #(
        .KERNEL_SIZE     (KERNEL_SIZE),
        .IMG_WIDTH       (IMG_WIDTH),
        .IMG_HEIGHT      (IMG_HEIGHT),
        .CONV_STRIDE     (CONV_STRIDE),
        .INPUT_CHANNELS  (L1_INPUT_CHANNELS),
        .OUTPUT_CHANNELS (L1_OUTPUT_CHANNELS),
        .DATA_WIDTH      (L1_DATA_WIDTH),
        .VALUE_WIDTH     (VALUE_WIDTH),
        .OUT_WIDTH       (OUT_WIDTH),
        .POOL_SIZE       (POOL_SIZE),
        .POOL_STRIDE     (POOL_STRIDE),
        .SIGNED_DATA     (SIGNED_DATA)
    ) layer1 (
        .clock      (clock),
        .sreset_n   (sreset_n),
        .data_valid (data_valid),
        .data_in    (data_in),
        .pool_out   (l1_pool_out),
        .pool_valid (l1_pool_valid),
        .conv_out   (l1_conv_out),
        .conv_valid (l1_conv_valid)
    );

    //=====================================================
    // Layer 2: CKAN Conv + Pool
    //=====================================================
    CKAN_Layer #(
        .KERNEL_SIZE     (KERNEL_SIZE),
        .IMG_WIDTH       (L1_POOL_OUT_W),
        .IMG_HEIGHT      (L1_POOL_OUT_H),
        .CONV_STRIDE     (CONV_STRIDE),
        .INPUT_CHANNELS  (L2_INPUT_CHANNELS),
        .OUTPUT_CHANNELS (L2_OUTPUT_CHANNELS),
        .DATA_WIDTH      (L2_DATA_WIDTH),
        .VALUE_WIDTH     (VALUE_WIDTH),
        .OUT_WIDTH       (OUT_WIDTH),
        .POOL_SIZE       (POOL_SIZE),
        .POOL_STRIDE     (POOL_STRIDE),
        .SIGNED_DATA     (SIGNED_DATA)
    ) layer2 (
        .clock      (clock),
        .sreset_n   (sreset_n),
        .data_valid (l1_pool_valid),
        .data_in    (l1_pool_out),
        .pool_out   (l2_pool_out),
        .pool_valid (l2_pool_valid),
        .conv_out   (l2_conv_out),
        .conv_valid (l2_conv_valid)
    );

    //=====================================================
    // Flatten
    //=====================================================
    Flatten #(
        .CHANNELS   (L2_OUTPUT_CHANNELS),
        .DATA_WIDTH (OUT_WIDTH),
        .COLUMN_NUM (L2_POOL_OUT_W),
        .ROW_NUM    (L2_POOL_OUT_H)
    ) flatten_inst (
        .clock      (clock),
        .sreset_n   (sreset_n),
        .data_valid (l2_pool_valid),
        .data_in    (l2_pool_out),
        .flat_out   (flat_out),
        .flat_valid (flat_valid)
    );

endmodule
