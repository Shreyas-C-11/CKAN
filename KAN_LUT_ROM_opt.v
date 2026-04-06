//=====================================================
// Module: KAN_LUT_ROM_opt
// Description:
//   - Split KAN lookup table (read-only)
//   - Stores ONLY ONE KAN basis function (64 entries)
//   - Address format: addr = {input_pixel}
//=====================================================
module KAN_LUT_ROM_opt #(
    parameter VALUE_WIDTH = 4,   // 4-bit data out for CARRY4 efficiency
    parameter INPUT_WIDTH = 6,   // 6-bit input for perfect LUT6 mapping
    parameter MEM_FILE    = "kan_lut_func_0.mem"  // Passed at compile-time
)(
    input  wire [INPUT_WIDTH-1:0]    addr, 
    output wire signed [VALUE_WIDTH-1:0] data
);

    // Total ROM depth = 64 (fits exactly in 1 LUT6 per output bit!)
    localparam DEPTH = 1 << INPUT_WIDTH;

    // Force LUT-ROM inference 
    (* rom_style = "distributed" *)
    reg signed [VALUE_WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize ROM from file dynamically assigned by parameter
    initial begin
        $readmemh(MEM_FILE, mem);
    end

    // Combinational read (pure LUT6 inference, NO muxing overhead)
    assign data = mem[addr];

endmodule
