`timescale 1ns / 1ps

//=====================================================
// Testbench: tb_dut
// Description:
//   - Drives CKAN_Model_DUT with a 28×28 test image
//   - Uses per-layer LUT files:
//       kan_lut1.mem (512 entries, Layer 1)
//       kan_lut2.mem (16384 entries, Layer 2)
//   - OUT_WIDTH == VALUE_WIDTH == 8 (saturated conv output)
//   - Monitors intermediate conv/pool outputs and
//     final flattened output
//   - Feeds two full images to verify pipeline reuse
//
//   Architecture:
//     Layer 1: 28×28×1 → Conv 3×3 → 26×26×2 → Pool 2×2 → 13×13×2
//     Layer 2: 13×13×2 → Conv 3×3 → 11×11×2 → Pool 2×2 →  5×5×2
//     Flatten: 5×5×2×8b = 400-bit output vector
//
//   Expected output counts per image:
//     L1 pool: 13×13 = 169
//     L2 pool:  5×5  =  25
//     Flat valid:        1
//=====================================================

module tb_dut;

    //=====================================================
    // Parameters
    //=====================================================
    parameter CLK_PERIOD  = 8;        // 125 MHz clock
    parameter IMG_WIDTH   = 28;
    parameter IMG_HEIGHT  = 28;
    parameter TOTAL_PX    = IMG_WIDTH * IMG_HEIGHT;  // 784 pixels per image
    parameter NUM_IMAGES  = 2;         // Number of images to feed

    // Expected output counts per image
    parameter L1_POOL_EXPECTED = 169;  // 13×13
    parameter L2_POOL_EXPECTED = 25;   //  5×5
    parameter FLAT_EXPECTED    = 1;

    //=====================================================
    // DUT I/O
    //=====================================================
    reg         clock;
    reg         sreset_n;
    reg         data_valid;
    reg  [3:0]  pixel_in;

    wire [399:0] flat_out;       // 5×5×2×8b = 400 bits
    wire         flat_valid;
    wire [15:0]  l1_pool_out;    // 2 channels × 8 bits
    wire         l1_pool_valid;
    wire [15:0]  l2_pool_out;    // 2 channels × 8 bits
    wire         l2_pool_valid;

    //=====================================================
    // DUT Instantiation
    //=====================================================
    CKAN_Model_DUT dut (
        .clock         (clock),
        .sreset_n      (sreset_n),
        .data_valid    (data_valid),
        .pixel_in      (pixel_in),
        .flat_out      (flat_out),
        .flat_valid    (flat_valid),
        .l1_pool_out   (l1_pool_out),
        .l1_pool_valid (l1_pool_valid),
        .l2_pool_out   (l2_pool_out),
        .l2_pool_valid (l2_pool_valid)
    );

    //=====================================================
    // Clock Generation
    //=====================================================
    initial clock = 0;
    always #(CLK_PERIOD/2) clock = ~clock;

    //=====================================================
    // Event Counters (for monitoring)
    //=====================================================
    integer l1_pool_count;
    integer l2_pool_count;
    integer flat_count;
    integer img_idx;
    integer errors;

    //=====================================================
    // Monitor Layer 1 Pooled Output
    //=====================================================
    always @(posedge clock) begin
        if (!sreset_n) begin
            l1_pool_count <= 0;
        end
        else if (l1_pool_valid) begin
            l1_pool_count <= l1_pool_count + 1;
            $display("[%0t] L1_POOL[%0d]: ch0=%0d ch1=%0d",
                     $time, l1_pool_count,
                     $signed(l1_pool_out[7:0]),
                     $signed(l1_pool_out[15:8]));
        end
    end

    //=====================================================
    // Monitor Layer 2 Pooled Output
    //=====================================================
    always @(posedge clock) begin
        if (!sreset_n) begin
            l2_pool_count <= 0;
        end
        else if (l2_pool_valid) begin
            l2_pool_count <= l2_pool_count + 1;
            $display("[%0t] L2_POOL[%0d]: ch0=%0d ch1=%0d",
                     $time, l2_pool_count,
                     $signed(l2_pool_out[7:0]),
                     $signed(l2_pool_out[15:8]));
        end
    end

    //=====================================================
    // Monitor Flatten Output
    //=====================================================
    always @(posedge clock) begin
        if (!sreset_n) begin
            flat_count <= 0;
        end
        else if (flat_valid) begin
            flat_count <= flat_count + 1;
            $display("[%0t] ===== FLAT_VALID #%0d =====", $time, flat_count);
            $display("  flat_out[15:0]   = %h", flat_out[15:0]);
            $display("  flat_out[31:16]  = %h", flat_out[31:16]);
            $display("  flat_out[399:384]= %h", flat_out[399:384]);
        end
    end

    //=====================================================
    // X/Z Checker — flags if outputs contain X or Z
    //=====================================================
    always @(posedge clock) begin
        if (sreset_n && l1_pool_valid) begin
            if (^l1_pool_out === 1'bx) begin
                $display("[%0t] WARNING: l1_pool_out contains X/Z!", $time);
                errors = errors + 1;
            end
        end
        if (sreset_n && l2_pool_valid) begin
            if (^l2_pool_out === 1'bx) begin
                $display("[%0t] WARNING: l2_pool_out contains X/Z!", $time);
                errors = errors + 1;
            end
        end
        if (sreset_n && flat_valid) begin
            if (^flat_out === 1'bx) begin
                $display("[%0t] WARNING: flat_out contains X/Z!", $time);
                errors = errors + 1;
            end
        end
    end

    //=====================================================
    // Main Stimulus
    //=====================================================
    integer px;

    initial begin
        // ---- Waveform dump (for viewer tools) ----
        $dumpfile("tb_dut.vcd");
        $dumpvars(0, tb_dut);

        // ---- Initialize ----
        sreset_n   = 0;
        data_valid = 0;
        pixel_in   = 0;
        errors     = 0;

        // ---- Reset ----
        repeat (5) @(posedge clock);
        sreset_n = 1;
        @(posedge clock);

        $display("========================================");
        $display(" CKAN Model DUT Testbench Started");
        $display(" Image size: %0d x %0d = %0d pixels",
                 IMG_WIDTH, IMG_HEIGHT, TOTAL_PX);
        $display(" LUT files: kan_lut1.mem (L1), kan_lut2.mem (L2)");
        $display(" VALUE_WIDTH=8, OUT_WIDTH=8 (saturated)");
        $display(" Expected per image:");
        $display("   L1 pool outputs: %0d", L1_POOL_EXPECTED);
        $display("   L2 pool outputs: %0d", L2_POOL_EXPECTED);
        $display("   Flat valid:      %0d", FLAT_EXPECTED);
        $display("========================================");

        // ---- Feed images ----
        for (img_idx = 0; img_idx < NUM_IMAGES; img_idx = img_idx + 1) begin
            $display("\n--- Feeding Image %0d ---", img_idx);

            for (px = 0; px < TOTAL_PX; px = px + 1) begin
                @(posedge clock);
                data_valid = 1;
                // Constant pixel = 1 for easy hand-tracing
                // With LUT=1: every KAN lookup returns +1
                //   L1 SIC sum = 9 (3×3 window, each → +1)
                //   L1 SIC saturated = 9 (fits in 8-bit signed: max=+127)
                //   L1 MIC sum = 9 (1 input channel)
                //   L1 pool = 9
                //   L2 SIC sum = 9, L2 MIC sum = 9+9=18 (2 channels)
                //   L2 pool = 18
                pixel_in = 4'd1;
            end

            // De-assert valid between images
            @(posedge clock);
            data_valid = 0;
            pixel_in   = 0;

            // Wait for pipeline to flush
            $display("--- Waiting for pipeline to flush ---");
            repeat (200) @(posedge clock);
        end

        // ---- Final wait and summary ----
        repeat (500) @(posedge clock);

        $display("\n========================================");
        $display(" Simulation Complete");
        $display(" L1 pool outputs seen:  %0d (expected %0d per image)", l1_pool_count, L1_POOL_EXPECTED);
        $display(" L2 pool outputs seen:  %0d (expected %0d per image)", l2_pool_count, L2_POOL_EXPECTED);
        $display(" Flat valid pulses:     %0d (expected %0d per image)", flat_count, FLAT_EXPECTED);
        $display(" X/Z warnings:          %0d", errors);
        if (errors == 0)
            $display(" STATUS: PASS");
        else
            $display(" STATUS: FAIL — %0d X/Z warnings detected", errors);
        $display("========================================");

        $finish;
    end

    //=====================================================
    // Timeout watchdog
    //=====================================================
    initial begin
        #5000000;  // 5 ms timeout
        $display("ERROR: Simulation timed out!");
        $finish;
    end

endmodule
