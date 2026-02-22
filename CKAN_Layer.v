//=====================================================
// Module: CKAN_Layer
// Description:
//   - Wrapper combining Conv2D_KAN + MaxPool2D
//   - Accepts a raw multi-channel pixel stream
//   - Performs CKAN convolution followed by max pooling
//   - Dataflow:
//       pixel stream (Cin × DATA_WIDTH)
//          ↓
//       Conv2D_KAN   - CKAN convolution (produces Cout feature maps)
//          ↓
//       MaxPool2D    - spatial down-sampling via max pooling
//          ↓
//       pooled output (Cout × OUT_WIDTH)
//=====================================================
module CKAN_Layer #(
    // ---------------- Image Parameters ----------------
    parameter KERNEL_SIZE      = 3,   // Convolution window size (KxK)
    parameter IMG_WIDTH        = 5,   // Input image width
    parameter IMG_HEIGHT       = 5,   // Input image height
    parameter CONV_STRIDE      = 1,   // Convolution stride

    // ---------------- CKAN Parameters ----------------
    parameter INPUT_CHANNELS   = 3,   // Number of input feature channels (Cin)
    parameter OUTPUT_CHANNELS  = 2,   // Number of output feature channels (Cout)
    parameter DATA_WIDTH       = 8,   // Input pixel bit-width
    parameter VALUE_WIDTH      = 8,   // KAN LUT output width
    parameter OUT_WIDTH        = 16,  // Accumulator / conv output width
    parameter MEM_FILE         = "kan_lut.mem",

    // ---------------- Pooling Parameters ----------------
    parameter POOL_SIZE        = 2,   // Pooling window size (PxP)
    parameter POOL_STRIDE      = 2,   // Pooling stride (typically = POOL_SIZE)
    parameter SIGNED_DATA      = 1    // 1 = signed max, 0 = unsigned max
)(
    // ---------------- I/O Ports ----------------
    input  wire                                     clock,
    input  wire                                     sreset_n,
    input  wire                                     data_valid,   // Input pixel valid
    input  wire [INPUT_CHANNELS*DATA_WIDTH-1:0]     data_in,      // Packed multi-channel pixel input

    // ---------------- Final Output ----------------
    output wire [OUTPUT_CHANNELS*OUT_WIDTH-1:0]     pool_out,     // Packed pooled feature maps
    output wire                                     pool_valid,   // Valid signal for pool_out

    // ---------------- Intermediate Tap (optional) ----
    output wire [OUTPUT_CHANNELS*OUT_WIDTH-1:0]     conv_out,     // Raw conv output (before pooling)
    output wire                                     conv_valid    // Conv valid (before pooling)
);

    //=====================================================
    // Derived feature-map dimensions (after convolution)
    //=====================================================
    localparam CONV_OUT_WIDTH  = (IMG_WIDTH  - KERNEL_SIZE) / CONV_STRIDE + 1;
    localparam CONV_OUT_HEIGHT = (IMG_HEIGHT - KERNEL_SIZE) / CONV_STRIDE + 1;

    //=====================================================
    // Stage 1: CKAN Convolution
    //=====================================================
    Conv2D_KAN #(
        .KERNEL_SIZE     (KERNEL_SIZE),
        .COLUMN_NUM      (IMG_WIDTH),
        .ROW_NUM         (IMG_HEIGHT),
        .STRIDE          (CONV_STRIDE),
        .INPUT_CHANNELS  (INPUT_CHANNELS),
        .OUTPUT_CHANNELS (OUTPUT_CHANNELS),
        .DATA_WIDTH      (DATA_WIDTH),
        .VALUE_WIDTH     (VALUE_WIDTH),
        .OUT_WIDTH       (OUT_WIDTH),
        .MEM_FILE(MEM_FILE)
    ) conv_layer (
        .clock      (clock),
        .data_valid (data_valid),
        .sreset_n   (sreset_n),
        .data_in    (data_in),
        .conv_out   (conv_out),
        .conv_valid (conv_valid)
    );

    //=====================================================
    // Stage 2: Max Pooling
    //=====================================================
    MaxPool2D #(
        .POOL_SIZE   (POOL_SIZE),
        .POOL_STRIDE (POOL_STRIDE),
        .COLUMN_NUM  (CONV_OUT_WIDTH),    
        .ROW_NUM     (CONV_OUT_HEIGHT),   
        .CHANNELS    (OUTPUT_CHANNELS),   
        .DATA_WIDTH  (OUT_WIDTH),         
        .SIGNED_DATA (SIGNED_DATA)
    ) pool_layer (
        .clock      (clock),
        .sreset_n   (sreset_n),
        .data_valid (conv_valid),        
        .data_in    (conv_out),          
        .pool_out   (pool_out),
        .pool_valid (pool_valid)
    );

endmodule
