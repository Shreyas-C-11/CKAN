//=====================================================
// Module: KAN_LUT_ROM
// Description:
//   - Shared KAN lookup table (read-only)
//   - FORCED to be implemented as LUT-ROM (distributed RAM)
//   - Stores multiple KAN basis functions
//   - Address format:
//         addr = {function_id, input_value}
//=====================================================
module KAN_LUT_ROM #(
    parameter VALUE_WIDTH = 8,   // Output value width
    parameter INPUT_WIDTH = 8,   // Input pixel width
    parameter FUNC_BITS   = 8,   // Number of bits for function ID in KAN LUT
    parameter MEM_FILE    = "kan_lut.mem"
)(
    input  wire [FUNC_BITS+INPUT_WIDTH-1:0] addr,
    output wire signed [VALUE_WIDTH-1:0]    data
);

    // Total ROM depth = (#functions × input resolution)
    localparam DEPTH = 1 << (FUNC_BITS + INPUT_WIDTH);

    // --------------------------------------------------
    // Force LUT-ROM inference (Vivado / Quartus friendly)
    // --------------------------------------------------
    (* rom_style = "distributed" *)
    (* ram_style = "distributed" *)
    reg signed [VALUE_WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize ROM from file
    initial begin
        $readmemh(MEM_FILE, mem);
    end

    // Combinational read (LUT-ROM)
    assign data = mem[addr];

endmodule
//