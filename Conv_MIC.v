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
    parameter FUNC_BITS       = 8,   // Number of bits for function ID in KAN LUT
    parameter MEM_FILE        = "kan_lut.mem"
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
                .FUNC_BITS   (FUNC_BITS),
                .MEM_FILE(MEM_FILE)
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

    //=====================================================
    // Cross-channel accumulation (full-precision + saturate)
    //=====================================================
    // Sum partial CKAN outputs from all input channels
    // Use wider accumulator to avoid overflow, then saturate
    localparam MIC_ACC_BITS = $clog2(INPUT_CHANNELS) > 0 ? $clog2(INPUT_CHANNELS) : 1;
    localparam MIC_ACC_WIDTH = OUT_WIDTH + MIC_ACC_BITS;

    reg signed [MIC_ACC_WIDTH-1:0] sum_wide;
    integer j;
    always @(*) begin
        sum_wide = 0;
        for (j = 0; j < INPUT_CHANNELS; j = j + 1)
            sum_wide = sum_wide + {{MIC_ACC_BITS{ch_out[j][OUT_WIDTH-1]}}, ch_out[j]};
    end

    // Signed saturator: MIC_ACC_WIDTH → OUT_WIDTH
    localparam signed [MIC_ACC_WIDTH-1:0] MIC_SAT_MAX = {{(MIC_ACC_BITS+1){1'b0}}, {(OUT_WIDTH-1){1'b1}}};
    localparam signed [MIC_ACC_WIDTH-1:0] MIC_SAT_MIN = {{(MIC_ACC_BITS+1){1'b1}}, {(OUT_WIDTH-1){1'b0}}};

    wire signed [OUT_WIDTH-1:0] sum_sat;
    assign sum_sat = (sum_wide > MIC_SAT_MAX) ? MIC_SAT_MAX[OUT_WIDTH-1:0] :
                     (sum_wide < MIC_SAT_MIN) ? MIC_SAT_MIN[OUT_WIDTH-1:0] :
                     sum_wide[OUT_WIDTH-1:0];

    //=====================================================
    // Outputs
    //=====================================================
    // Final CKAN output for this output channel (saturated)
    assign conv_out = sum_sat;

    // Global valid signal 
    assign conv_valid = ch_valid[0];

endmodule
