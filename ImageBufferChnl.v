//=====================================================
// Module: ImageBufferChnl
// Description:
//   - Handles multi-channel image buffering
//   - Generates sliding KxK windows for each channel
//   - Internally instantiates one ImageBuf_KernelSlider
//     per input channel
//=====================================================
module ImageBufferChnl#(
    
    parameter KERNEL_SIZE = 3,   // KxK convolution window
    parameter DATA_WIDTH  = 8,   // Pixel bit-width
    parameter COLUMN_NUM  = 5,   // Image width
    parameter ROW_NUM     = 5,   // Image height
    parameter STRIDE      = 1,   // Sliding stride
    parameter CHANNELS    = 2    // Number of input channels (Cin)
 
)(
    input  wire                              clock,
    input  wire                              data_valid, 
    input  wire                              sreset_n,

    input  wire [CHANNELS*DATA_WIDTH-1:0]    data_in,
    output wire [CHANNELS*DATA_WIDTH-1:0]    data_out,

    output wire                              kernel_valid,
    output wire [CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_out
    
);

    //=====================================================
    // Internal per-channel signals
    //=====================================================

    // Individual channel pixel inputs
    wire [DATA_WIDTH-1:0] SeperateInChannels  [0:CHANNELS-1];
    // Individual channel buffered outputs
    wire [DATA_WIDTH-1:0] SeperateOutChannels [0:CHANNELS-1];
    // Individual channel KxK sliding windows
    wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] SeperateKernels [0:CHANNELS-1];

    //=====================================================
    // Channel separation & recombination logic
    //=====================================================
    genvar i;
    generate
        for(i=0; i<CHANNELS; i=i+1) begin

            // ---------------- INPUT UNPACKING ----------------
            assign SeperateInChannels[CHANNELS-i-1] = data_in[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH];

            // ---------------- OUTPUT PACKING ----------------
            assign data_out[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH] = SeperateOutChannels[CHANNELS-i-1];

            // Re-pack per-channel KxK windows
            assign kernel_out[(i+1)*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1 :
                              i*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH] =
                   SeperateKernels[CHANNELS-i-1];

            //=================================================
            // Per-channel Image Buffer + Kernel Slider
            //=================================================

            // Only ONE channel (i==0) drives kernel_valid
            if(i==0) begin
                ImageBuf_KernelSlider #(
                    .KERNEL_SIZE (KERNEL_SIZE),
                    .DATA_WIDTH  (DATA_WIDTH),
                    .COLUMN_NUM  (COLUMN_NUM),
                    .ROW_NUM     (ROW_NUM),
                    .STRIDE      (STRIDE)
                ) ChannelBuf (
                    .clock        (clock),
                    .data_valid   (data_valid),
                    .sreset_n     (sreset_n),
                    .data_in      (SeperateInChannels[i]),
                    .data_out     (SeperateOutChannels[i]),
                    .kernel_out   (SeperateKernels[i]),
                    .kernel_valid (kernel_valid) // global valid
                );
            end
            else begin
                ImageBuf_KernelSlider #(
                    .KERNEL_SIZE (KERNEL_SIZE),
                    .DATA_WIDTH  (DATA_WIDTH),
                    .COLUMN_NUM  (COLUMN_NUM),
                    .ROW_NUM     (ROW_NUM),
                    .STRIDE      (STRIDE)
                ) ChannelBuf (
                    .clock        (clock),
                    .data_valid   (data_valid),
                    .sreset_n     (sreset_n),
                    .data_in      (SeperateInChannels[i]),
                    .data_out     (SeperateOutChannels[i]),
                    .kernel_out   (SeperateKernels[i]),
                    .kernel_valid () // intentionally unused
                );
            end
        end
    endgenerate
    
endmodule