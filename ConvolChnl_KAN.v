//=====================================================
// Module: ConvolChnl_KAN
// Description:
//   - CKAN convolution channel block
//   - Instantiates one Conv_MIC_KAN per output channel
//   - Each Conv_MIC_KAN computes ONE CKAN feature map
//   - All output channels operate in parallel on the
//     same KxKxCin kernel window
//=====================================================
module ConvolChnl_KAN #(
    parameter KERNEL_SIZE     = 3,   // Convolution window size (KxK)
    parameter INPUT_CHANNELS  = 3,   // Number of input feature channels (Cin)
    parameter OUTPUT_CHANNELS = 2,   // Number of output feature channels (Cout)   
    parameter DATA_WIDTH      = 8,   // Input pixel bit-width
    parameter VALUE_WIDTH     = 8,   // KAN LUT output width
    parameter OUT_WIDTH       = 16   // Accumulator width
)(
    input  wire clock,
    input  wire sreset_n,
    input  wire data_valid,   // Valid signal for kernel window
    input  wire [INPUT_CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0]
                kernel_in,    // Packed multi-channel KxK kernel window

    // Packed CKAN output feature maps
    output wire [OUTPUT_CHANNELS*OUT_WIDTH-1:0] conv_out,
    output wire conv_valid    
);
    localparam integer NUM_FUNCTIONS =
    OUTPUT_CHANNELS * INPUT_CHANNELS * KERNEL_SIZE * KERNEL_SIZE;
    localparam integer FUNC_BITS = $clog2(NUM_FUNCTIONS);

    //=====================================================
    // Internal per-output-channel signals
    //=====================================================

    // CKAN convolution output for each output channel
    wire signed [OUT_WIDTH-1:0] ch_out [0:OUTPUT_CHANNELS-1];

    // Valid signals from each Conv_MIC_KAN instance
    wire                      ch_valid [0:OUTPUT_CHANNELS-1];

    //=====================================================
    // Generate CKAN convolution blocks (one per output)
    //=====================================================
    genvar i;
    generate
        for (i=0; i<OUTPUT_CHANNELS; i=i+1) begin

            Conv_MIC_KAN #(
                .KERNEL_SIZE    (KERNEL_SIZE),
                .INPUT_CHANNELS (INPUT_CHANNELS),
                .DATA_WIDTH     (DATA_WIDTH),
                .VALUE_WIDTH    (VALUE_WIDTH),
                .OUT_WIDTH      (OUT_WIDTH),
                .FUNC_BITS      (FUNC_BITS)
            ) mic (
                .clock      (clock),
                .sreset_n   (sreset_n),
                .data_valid (data_valid),
                // Same kernel window is broadcast to all
                // output channels (different learned CKANs)
                .kernel_in  (kernel_in),
                .conv_out   (ch_out[i]),
                .conv_valid (ch_valid[i]),
                .func_base_id (i * INPUT_CHANNELS * KERNEL_SIZE * KERNEL_SIZE)
            );

            // Pack per-channel CKAN outputs into a single bus
            assign conv_out[(i+1)*OUT_WIDTH-1 -: OUT_WIDTH] = ch_out[i];
        end
    endgenerate

    // Global valid signal
    assign conv_valid = ch_valid[0];

endmodule
