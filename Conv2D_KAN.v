//=====================================================
// Module: Conv2D_KAN
// Description:
//   - Top-level CKAN convolution layer
//   - Combines spatial image buffering with CKAN compute
//   - Dataflow:
//       pixel stream
//          ↓
//       ImageBufferChnl  - generates KxKxCin windows
//          ↓
//       ConvolChnl_KAN   - CKAN feature extraction
//=====================================================
//
module Conv2D_KAN #(
    // ---------------- Image Buffer Parameters ----------------
    parameter KERNEL_SIZE     = 3,   // Convolution window size (KxK)
    parameter COLUMN_NUM      = 5,   // Input image width
    parameter ROW_NUM         = 5,   // Input image height
    parameter STRIDE          = 1,   // Sliding window stride

    // ---------------- CKAN Parameters ----------------
    parameter INPUT_CHANNELS   = 3,   // Number of input feature channels (Cin)
    parameter OUTPUT_CHANNELS  = 2,   // Number of output feature channels (Cout)
    parameter DATA_WIDTH       = 8,   // Input pixel bit-width
    parameter VALUE_WIDTH      = 8,   // KAN LUT output width
    parameter OUT_WIDTH        = 16   // Accumulator width
)(
    // ---------------- I/O Ports ----------------
    input  wire                                  clock,
    input  wire                                  data_valid,   // Input pixel valid
    input  wire                                  sreset_n,     
    input  wire [INPUT_CHANNELS*DATA_WIDTH-1:0]  data_in,      // Packed multi-channel pixel input

    // ---------------- CKAN Output ----------------
    output wire [OUTPUT_CHANNELS*OUT_WIDTH-1:0]  conv_out,     // Packed CKAN feature maps
    output wire                                  conv_valid    // Valid signal for conv_out
);

    //=====================================================
    // Internal Signals
    //=====================================================

    // Packed KxK window for all input channels
    wire [INPUT_CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_window;
    wire kernel_valid_signal;

    // Optional debug signal
    wire [INPUT_CHANNELS*DATA_WIDTH-1:0] data_out_buffer;

    //=====================================================
    // Image Buffer Channel 
    //=====================================================
    ImageBufferChnl #(
        .KERNEL_SIZE (KERNEL_SIZE),
        .DATA_WIDTH  (DATA_WIDTH),
        .COLUMN_NUM  (COLUMN_NUM),
        .ROW_NUM     (ROW_NUM),
        .STRIDE      (STRIDE),
        .CHANNELS    (INPUT_CHANNELS)
    ) ImageBufferChnl_inst (
        .clock        (clock),
        .data_valid   (data_valid),
        .sreset_n     (sreset_n),
        .data_in      (data_in),
        .data_out     (data_out_buffer),   // Debug only (CKAN does not consume this)
        .kernel_out   (kernel_window),
        .kernel_valid (kernel_valid_signal)
    );

    //=====================================================
    // CKAN Convolution Channel 
    //=====================================================
    ConvolChnl_KAN #(
        .KERNEL_SIZE     (KERNEL_SIZE),
        .INPUT_CHANNELS  (INPUT_CHANNELS),
        .OUTPUT_CHANNELS (OUTPUT_CHANNELS),
        .DATA_WIDTH      (DATA_WIDTH),
        .VALUE_WIDTH     (VALUE_WIDTH),
        .OUT_WIDTH       (OUT_WIDTH)
    ) ConvolChnl_inst (
        .clock      (clock),
        .sreset_n   (sreset_n),
        .data_valid (kernel_valid_signal),  // Trigger CKAN computation
        .kernel_in  (kernel_window),
        .conv_out   (conv_out),
        .conv_valid (conv_valid)
    );

endmodule
