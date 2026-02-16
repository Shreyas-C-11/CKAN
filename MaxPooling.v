`timescale 1ns / 1ps

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
    // Unpack pooling window
    // ============================================================
    localparam N = POOL_SIZE * POOL_SIZE;
    wire [DATA_WIDTH-1:0] px [0:N-1];

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            assign px[i] = pool_in[(i+1)*DATA_WIDTH-1 -: DATA_WIDTH];
        end
    endgenerate

    // ============================================================
    // Combinational max reduction
    // ============================================================
    reg [DATA_WIDTH-1:0] max_val;
    integer j;

    always @(*) begin
        max_val = px[0];
        for (j = 1; j < N; j = j + 1) begin
            if (SIGNED_DATA) begin
                if ($signed(px[j]) > $signed(max_val))
                    max_val = px[j];
            end else begin
                if (px[j] > max_val)
                    max_val = px[j];
            end
        end
    end

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
