`timescale 1ns / 1ps

//=====================================================
// Module: MaxPooling
// Description:
//   - Performs spatial max-pooling over a POOL_SIZE×POOL_SIZE window
//   - Uses a binary comparator tree (analogous to the adder
//     tree in Conv_SIC_KAN) for O(log₂N) critical-path depth
//   - Supports signed and unsigned comparisons
//
//   Pipeline: tree(comb) → pool_out(reg)
//=====================================================
module MaxPooling #(
    parameter POOL_SIZE   = 2,   // K (KxK pooling)
    parameter DATA_WIDTH  = 16,  // input feature width (matches Conv2D_KAN OUT_WIDTH)
    parameter SIGNED_DATA = 1    // 1 = signed, 0 = unsigned
)(
    input  wire                                      clock,
    input  wire                                      sreset_n,
    input  wire                                      data_valid,
    input  wire [POOL_SIZE*POOL_SIZE*DATA_WIDTH-1:0] pool_in,
    output reg  [DATA_WIDTH-1:0]                     pool_out,
    output reg                                       pool_valid
);

    // ============================================================
    // Local parameters for comparator tree sizing
    // ============================================================
    localparam N        = POOL_SIZE * POOL_SIZE;  // Number of elements
    localparam PADDED_N = 1 << $clog2(N);         // Next power-of-2 for balanced tree
    localparam LEVELS   = $clog2(PADDED_N);       // Tree depth

    // Minimum representable value (used to pad unused tree slots)
    //   Signed:   most-negative = {1'b1, {(DATA_WIDTH-1){1'b0}}}
    //   Unsigned: zero           = {DATA_WIDTH{1'b0}}
    localparam [DATA_WIDTH-1:0] PAD_VALUE = SIGNED_DATA
        ? {1'b1, {(DATA_WIDTH-1){1'b0}}}   // e.g. -128 for 8-bit signed
        : {DATA_WIDTH{1'b0}};              // e.g. 0 for unsigned

    // ============================================================
    // Unpack pooling window
    // ============================================================
    wire [DATA_WIDTH-1:0] px [0:N-1];

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : UNPACK
            assign px[i] = pool_in[(i+1)*DATA_WIDTH-1 -: DATA_WIDTH];
        end
    endgenerate

    // ============================================================
    // Binary comparator tree (combinational)
    //   — mirrors the adder tree structure in Conv_SIC_KAN
    //   — each node selects max(left, right)
    //   — unused leaf slots are padded with PAD_VALUE so they
    //     can never "win" a comparison
    // ============================================================
    wire [DATA_WIDTH-1:0] tree [0:LEVELS][0:PADDED_N-1];

    generate
        // Level 0: leaf nodes — real pixels + padding
        for (i = 0; i < PADDED_N; i = i + 1) begin : TREE_LEAF
            assign tree[0][i] = (i < N) ? px[i] : PAD_VALUE;
        end

        // Reduction levels: pairwise max
        genvar l;
        for (l = 1; l <= LEVELS; l = l + 1) begin : TREE_LEVEL
            for (i = 0; i < (PADDED_N >> l); i = i + 1) begin : TREE_NODE
                assign tree[l][i] = SIGNED_DATA
                    ? ($signed(tree[l-1][2*i]) > $signed(tree[l-1][2*i+1])
                        ? tree[l-1][2*i] : tree[l-1][2*i+1])
                    : (tree[l-1][2*i] > tree[l-1][2*i+1]
                        ? tree[l-1][2*i] : tree[l-1][2*i+1]);
            end
        end
    endgenerate

    // Final tree output
    wire [DATA_WIDTH-1:0] max_val = tree[LEVELS][0];

    // ============================================================
    // Output register
    // ============================================================
    always @(posedge clock) begin
        if (!sreset_n)          pool_out <= {DATA_WIDTH{1'b0}};
        else if (data_valid)    pool_out <= max_val;
    end

    // ============================================================
    // VALID pipeline (1 cycle)
    // ============================================================
    always @(posedge clock) begin
        if (!sreset_n)  pool_valid <= 1'b0;
        else            pool_valid <= data_valid;
    end

endmodule