//=====================================================
// Module: Conv_SIC_KAN
// Description:
//   - CKAN Single-Input-Channel convolution block
//   - Processes ONE input channel of a KxK window
//   - Applies learned KAN basis functions (via LUT)
//   - Accumulates KxK contributions using an adder tree
//   - Saturates the wide accumulator sum to OUT_WIDTH
//   - Outputs a partial sum for this channel
//
//   Pipeline: LUT(comb) → lut_r(reg) → tree(comb) →
//             saturate(comb) → conv_out(reg)
//=====================================================
module Conv_SIC_KAN #(
    parameter KERNEL_SIZE = 3,   // Convolution window size (KxK)
    parameter DATA_WIDTH  = 8,   // Input pixel width
    parameter VALUE_WIDTH = 8,   // KAN LUT output width
    parameter OUT_WIDTH   = 8,   // Saturated output width (can equal VALUE_WIDTH)
    parameter FUNC_BITS   = 8,   // Number of bits for function ID in KAN LUT
    parameter MEM_FILE    = "kan_lut.mem"
)(
    input  wire clock,
    input  wire sreset_n,
    input  wire data_valid,   // Indicates valid kernel window
    input  wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0]
                kernel_in,    // Packed KxK window for all input channels
    // Base function ID for this channel
    input  wire [FUNC_BITS-1:0] func_base_id,

    // Partial CKAN output (one channel contribution)
    output reg  signed [OUT_WIDTH-1:0] conv_out,
    output reg                         conv_valid
);

    //=====================================================
    // Local parameters for adder tree sizing
    //=====================================================
    localparam N        = KERNEL_SIZE*KERNEL_SIZE; // Number of pixels per window
    localparam PADDED_N = 1 << $clog2(N);          // Next power-of-2 for tree
    localparam LEVELS   = $clog2(PADDED_N);        // Tree depth

    // Full-precision accumulator width:
    //   VALUE_WIDTH bits per input + ceil(log2(N)) guard bits
    //   Guarantees no overflow in the adder tree
    localparam ACC_WIDTH = VALUE_WIDTH + LEVELS;

    //=====================================================
    // Unpack KxK kernel window into individual pixels
    //=====================================================
    wire [DATA_WIDTH-1:0] px [0:N-1];
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1)
            assign px[i] = kernel_in[(i+1)*DATA_WIDTH-1 -: DATA_WIDTH];
    endgenerate

    //=====================================================
    // KAN LUT evaluation (basis function lookup)
    //=====================================================
    // Each pixel value is passed through a learned
    // KAN basis function implemented as a LUT
    wire signed [VALUE_WIDTH-1:0] lut_out [0:N-1];
    generate
        for (i = 0; i < N; i = i + 1) begin
            KAN_LUT_ROM #(
                .VALUE_WIDTH(VALUE_WIDTH),
                .INPUT_WIDTH(DATA_WIDTH),
                .FUNC_BITS  (FUNC_BITS),
                .MEM_FILE(MEM_FILE)
            ) lut (
                .addr({(func_base_id + i), px[i]}),
                .data(lut_out[i])
                );
        end
    endgenerate

    //=====================================================
    // Register LUT outputs (pipeline stage)
    //=====================================================
    // This isolates LUT delay and aligns data with valid
    reg signed [VALUE_WIDTH-1:0] lut_r [0:N-1];
    integer j;
    always @(posedge clock) begin
        if (!sreset_n)
            for (j = 0; j < N; j = j + 1)   lut_r[j] <= 0;
        else if (data_valid)
            for (j = 0; j < N; j = j + 1)   lut_r[j] <= lut_out[j];
    end

    //=====================================================
    // Adder tree input preparation
    //=====================================================
    // Sign-extend VALUE_WIDTH inputs to ACC_WIDTH,
    // pad unused slots with zero
    wire signed [ACC_WIDTH-1:0] acc [0:PADDED_N-1];
    generate
        for (i = 0; i < PADDED_N; i = i + 1)
            assign acc[i] = (i < N) ? {{(ACC_WIDTH-VALUE_WIDTH){lut_r[i][VALUE_WIDTH-1]}}, lut_r[i]}
                                    : {ACC_WIDTH{1'b0}};
    endgenerate

    //=====================================================
    // Binary adder tree (combinational, full-precision)
    //=====================================================
    // Sums all KxK KAN outputs for this channel
    // Uses ACC_WIDTH throughout — no overflow possible
    wire signed [ACC_WIDTH-1:0] tree [0:LEVELS][0:PADDED_N-1];
    generate
        // Tree level 0 (leaf nodes)
        for (i = 0; i < PADDED_N; i = i + 1)
            assign tree[0][i] = acc[i];

        // Tree reduction levels
        genvar l;
        for (l = 1; l <= LEVELS; l = l + 1)
            for (i = 0; i < (PADDED_N >> l); i = i + 1)
                assign tree[l][i] = tree[l-1][2*i] + tree[l-1][2*i+1];
    endgenerate

    //=====================================================
    // Signed saturator: ACC_WIDTH → OUT_WIDTH
    //=====================================================
    // Clamps the full-precision sum to the representable
    // range of a signed OUT_WIDTH-bit number:
    //   max =  2^(OUT_WIDTH-1) - 1   (e.g. +127 for 8b)
    //   min = -2^(OUT_WIDTH-1)       (e.g. -128 for 8b)
    wire signed [ACC_WIDTH-1:0] tree_sum = tree[LEVELS][0];

    localparam signed [ACC_WIDTH-1:0] SAT_MAX = {{(ACC_WIDTH-OUT_WIDTH+1){1'b0}}, {(OUT_WIDTH-1){1'b1}}};
    localparam signed [ACC_WIDTH-1:0] SAT_MIN = {{(ACC_WIDTH-OUT_WIDTH+1){1'b1}}, {(OUT_WIDTH-1){1'b0}}};

    wire signed [OUT_WIDTH-1:0] saturated;
    assign saturated = (tree_sum > SAT_MAX) ? SAT_MAX[OUT_WIDTH-1:0] :
                       (tree_sum < SAT_MIN) ? SAT_MIN[OUT_WIDTH-1:0] :
                       tree_sum[OUT_WIDTH-1:0];

    //=====================================================
    // Output register (pipeline boundary)
    //=====================================================
    // Registers the saturated KxK sum only when valid data is present
    always @(posedge clock) begin
        if (!sreset_n)       conv_out <= 0;
        else if (vpipe)      conv_out <= saturated;
    end

    //=====================================================
    // Valid signal pipeline (2 stages to match data path)
    //=====================================================
    // Data path: data_valid → lut_r(reg) → conv_out(reg) = 2 cycles
    // Valid path: data_valid → vpipe(reg) → conv_valid(reg) = 2 cycles
    reg vpipe;

    always @(posedge clock) begin
        if (!sreset_n) begin
            vpipe      <= 1'b0;
            conv_valid <= 1'b0;
        end else begin
            vpipe      <= data_valid;
            conv_valid <= vpipe;
        end
    end


endmodule

