//=====================================================
// Module: Flatten
// Description:
//   - Collects sequential spatial positions into a
//     single parallel output vector
//   - Counts incoming valid data positions
//   - Asserts flat_valid for 1 cycle when all
//     ROW_NUM × COLUMN_NUM positions are collected
//=====================================================
module Flatten #(
    parameter CHANNELS   = 2,    // Number of feature channels
    parameter DATA_WIDTH = 16,   // Bit-width per channel
    parameter COLUMN_NUM = 5,    // Feature map width
    parameter ROW_NUM    = 5     // Feature map height
)(
    input  wire                                                  clock,
    input  wire                                                  sreset_n,
    input  wire                                                  data_valid,
    input  wire [CHANNELS*DATA_WIDTH-1:0]                        data_in,

    output wire [ROW_NUM*COLUMN_NUM*CHANNELS*DATA_WIDTH-1:0]     flat_out,
    output reg                                                   flat_valid
);

    //=====================================================
    // Local parameters
    //=====================================================
    localparam TOTAL_POSITIONS = ROW_NUM * COLUMN_NUM;
    localparam WORD_WIDTH      = CHANNELS * DATA_WIDTH;
    localparam COUNTER_BITS    = $clog2(TOTAL_POSITIONS);

    //=====================================================
    // Position counter
    //=====================================================
    reg [COUNTER_BITS-1:0] pos_counter;

    integer k;
    always @(posedge clock) begin
        if (!sreset_n) begin
            pos_counter <= 0;
            flat_valid  <= 1'b0;
            for (k = 0; k < TOTAL_POSITIONS; k = k + 1)
                buffer[k] <= {WORD_WIDTH{1'b0}};
        end
        else if (data_valid) begin
            buffer[pos_counter] <= data_in;
            if (pos_counter == TOTAL_POSITIONS - 1) begin
                pos_counter <= 0;
                flat_valid  <= 1'b1;
            end
            else begin
                pos_counter <= pos_counter + 1;
                flat_valid  <= 1'b0;
            end
        end
        else begin
            flat_valid <= 1'b0;
        end
    end

    //=====================================================
    // Buffer register file
    //=====================================================
    reg [WORD_WIDTH-1:0] buffer [0:TOTAL_POSITIONS-1];

    //=====================================================
    // Pack buffer into flat_out
    //=====================================================
    genvar i;
    generate
        for (i = 0; i < TOTAL_POSITIONS; i = i + 1) begin : FLAT_PACK
            assign flat_out[(i+1)*WORD_WIDTH-1 -: WORD_WIDTH] = buffer[i];
        end
    endgenerate

endmodule
