//=====================================================
// Module: MaxPool2D
// Description:
//   - Top-level max-pooling layer for CKAN pipeline
//   - Designed to connect directly to Conv2D_KAN output
//   - Dataflow:
//       conv feature stream (CHANNELS × DATA_WIDTH)
//          ↓
//       ImageBufferChnl  - generates POOL×POOL windows
//          ↓
//       MaxPooling (×CHANNELS) - per-channel max + register
//
//   Connection example:
//       Conv2D_KAN.conv_out   →  MaxPool2D.data_in
//       Conv2D_KAN.conv_valid →  MaxPool2D.data_valid
//=====================================================
module MaxPool2D #(
    // ---------------- Pooling Parameters ----------------
    parameter POOL_SIZE    = 2,   // Pooling window size (KxK)
    parameter POOL_STRIDE  = 2,   // Pooling stride (typically = POOL_SIZE)

    // ---------------- Feature Map Dimensions ----------------
    parameter COLUMN_NUM   = 3,   // Conv output feature map width
    parameter ROW_NUM      = 3,   // Conv output feature map height

    // ---------------- Data Parameters ----------------
    parameter CHANNELS     = 2,   // Number of feature channels
    parameter DATA_WIDTH   = 16,  // Bit-width per channel
    parameter SIGNED_DATA  = 1    // 1 = signed comparisons, 0 = unsigned
)(
    // ---------------- I/O Ports ----------------
    input  wire                                clock,
    input  wire                                sreset_n,
    input  wire                                data_valid,    // From Conv2D_KAN conv_valid
    input  wire [CHANNELS*DATA_WIDTH-1:0]      data_in,       // From Conv2D_KAN conv_out

    // ---------------- Pooled Output ----------------
    output wire [CHANNELS*DATA_WIDTH-1:0]      pool_out,      // Packed pooled feature maps
    output wire                                pool_valid     // Valid signal for pool_out
);

    //=====================================================
    // Internal Signals
    //=====================================================

    // Packed POOL×POOL windows for all channels
    wire [CHANNELS*POOL_SIZE*POOL_SIZE*DATA_WIDTH-1:0] pool_window;
    wire pool_window_valid;

    // Debug / unused buffered output
    wire [CHANNELS*DATA_WIDTH-1:0] data_out_buf;

    //=====================================================
    // Feature Map Buffer (window generation)
    //=====================================================
    ImageBufferChnl #(
        .KERNEL_SIZE (POOL_SIZE),
        .DATA_WIDTH  (DATA_WIDTH),
        .COLUMN_NUM  (COLUMN_NUM),
        .ROW_NUM     (ROW_NUM),
        .STRIDE      (POOL_STRIDE),
        .CHANNELS    (CHANNELS)
    ) pool_buffer (
        .clock        (clock),
        .data_valid   (data_valid),
        .sreset_n     (sreset_n),
        .data_in      (data_in),
        .data_out     (data_out_buf),    // Not used downstream
        .kernel_out   (pool_window),
        .kernel_valid (pool_window_valid)
    );

    //=====================================================
    // Per-Channel Max Pooling
    //=====================================================
    wire [DATA_WIDTH-1:0] ch_pool_out   [0:CHANNELS-1];
    wire                  ch_pool_valid [0:CHANNELS-1];

    genvar i;
    generate
        for (i = 0; i < CHANNELS; i = i + 1) begin : POOL_CH

            MaxPooling #(
                .POOL_SIZE   (POOL_SIZE),
                .DATA_WIDTH  (DATA_WIDTH),
                .SIGNED_DATA (SIGNED_DATA)
            ) pool_inst (
                .clock      (clock),
                .sreset_n   (sreset_n),
                .data_valid (pool_window_valid),
                .pool_in    (pool_window[(i+1)*POOL_SIZE*POOL_SIZE*DATA_WIDTH-1 -:
                                         POOL_SIZE*POOL_SIZE*DATA_WIDTH]),
                .pool_out   (ch_pool_out[i]),
                .pool_valid (ch_pool_valid[i])
            );

            // Pack per-channel pooled output into a single bus
            assign pool_out[(i+1)*DATA_WIDTH-1 -: DATA_WIDTH] = ch_pool_out[i];
        end
    endgenerate

    // Global valid
    assign pool_valid = ch_pool_valid[0];

endmodule
//