//=====================================================
// Module: Conv_SIC_KAN
// Description:
//   - CKAN Single-Input-Channel convolution block
//   - Processes ONE input channel of a KxK window
//   - Applies learned KAN basis functions (via LUT)
//   - Accumulates KxK contributions using an adder tree
//   - Outputs a partial sum for this channel
//=====================================================
module Conv_SIC_KAN #(
    parameter KERNEL_SIZE = 3,   // Convolution window size (KxK)
    parameter DATA_WIDTH  = 8,   // Input pixel width
    parameter VALUE_WIDTH = 8,   // KAN LUT output width
    parameter OUT_WIDTH   = 16,   // Accumulator width
    parameter FUNC_BITS   = 8    // Number of bits for function ID in KAN LUT
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
                .FUNC_BITS  (FUNC_BITS)
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
    // Pad the inputs to a power-of-two length
    wire signed [OUT_WIDTH-1:0] acc [0:PADDED_N-1];
    generate
        for (i = 0; i < PADDED_N; i = i + 1)
            assign acc[i] = (i < N) ? lut_r[i] : 0;
    endgenerate

    //=====================================================
    // Binary adder tree (combinational)
    //=====================================================
    // Sums all KxK KAN outputs for this channel
    wire signed [OUT_WIDTH-1:0] tree [0:LEVELS][0:PADDED_N-1];
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
    // Output register (pipeline boundary)
    //=====================================================
    // Registers the accumulated KxK sum
    always @(posedge clock) begin
        if (!sreset_n)  conv_out <= 0;
        else            conv_out <= tree[LEVELS][0];
    end

    //=====================================================
    // Valid signal pipeline
    //=====================================================
    // Accounts for:
    //   1 cycle LUT register
    //   1 cycle output register
    reg [1:0] vpipe;

    always @(posedge clock) begin
        if (!sreset_n) begin
            vpipe      <= 2'b00;
            conv_valid <= 1'b0;
        end else begin
            vpipe      <= {vpipe[0], data_valid};
            conv_valid <= vpipe[1];
        end
    end


endmodule
