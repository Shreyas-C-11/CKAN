//=====================================================
// Module: Conv_MIC_KAN
// Description:
//   - CKAN Multi-Input Convolution block
//   - Computes ONE output feature value (one output channel)
//   - Internally:
//       * Splits the KxKxCin input window
//       * Processes each input channel independently
//       * Applies CKAN basis functions (via Conv_SIC_KAN)
//       * Sums contributions across all input channels
//=====================================================
module Conv_MIC_KAN #(
    parameter KERNEL_SIZE     = 3,   // Convolution window size (KxK)
    parameter INPUT_CHANNELS  = 3,   // Number of input channels (Cin)
    parameter DATA_WIDTH      = 8,   // Input pixel width
    parameter VALUE_WIDTH     = 8,   // KAN LUT output width
    parameter OUT_WIDTH       = 16,  // Accumulator width
    parameter FUNC_BITS       = 8    // Number of bits for function ID in KAN LUT
)(
    input  wire clock,
    input  wire sreset_n,
    input  wire data_valid,   // Indicates valid kernel window
    input  wire [INPUT_CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0]
                kernel_in,    // Packed KxK window for all input channels
    // Base function ID for this output channel
    input  wire [FUNC_BITS-1:0] func_base_id,

    // Output feature value for ONE CKAN output channel
    output wire signed [OUT_WIDTH-1:0] conv_out,
    output wire                        conv_valid
);

    //=====================================================
    // Per-input-channel partial outputs
    //=====================================================

    // Partial CKAN sums produced from each Conv_SIC_KAN instance
    wire signed [OUT_WIDTH-1:0] ch_out [0:INPUT_CHANNELS-1];

    // Valid signals from each Conv_SIC_KAN pipeline
    wire                      ch_valid [0:INPUT_CHANNELS-1];

    //=====================================================
    // Generate per-input-channel CKAN blocks
    //=====================================================
    genvar i;
    generate
        for (i = 0; i < INPUT_CHANNELS; i = i + 1) begin

            Conv_SIC_KAN #(
                .KERNEL_SIZE (KERNEL_SIZE),
                .DATA_WIDTH  (DATA_WIDTH),
                .VALUE_WIDTH (VALUE_WIDTH),
                .OUT_WIDTH   (OUT_WIDTH),
                .FUNC_BITS   (FUNC_BITS)
            ) sic (
                .clock      (clock),
                .sreset_n   (sreset_n),
                .data_valid (data_valid),
                // Extract the KxK window for input channel i
                .kernel_in  (kernel_in[(i+1)*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1 -:
                                        KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH]),
                .conv_out   (ch_out[i]),
                .conv_valid (ch_valid[i]),
                .func_base_id (func_base_id + i*KERNEL_SIZE*KERNEL_SIZE)
            );
        end
    endgenerate
    //

    //=====================================================
    // Cross-channel accumulation
    //=====================================================
    // Sum partial CKAN outputs from all input channels
    reg signed [OUT_WIDTH-1:0] sum;
    integer j;
    always @(*) begin
        sum = 0;
        for (j = 0; j < INPUT_CHANNELS; j = j + 1)
            sum = sum + ch_out[j];
    end

    //=====================================================
    // Outputs
    //=====================================================
    // Final CKAN output for this output channel
    assign conv_out = sum;

    // Global valid signal 
    //to be precise the valid signal should be set after calculating sum
    //not after calculating partial sums.
    assign conv_valid = ch_valid[0];

endmodule
