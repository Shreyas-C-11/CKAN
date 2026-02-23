`timescale 1ns / 1ps

//=====================================================
// Testbench: tb_dut (SIMPLE DEMO)
//
// Purpose:
//   Easy-to-trace simulation with predictable values.
//   All KAN LUT entries = 01 → every lookup returns +1.
//   Input pixel = 1 (constant).
//
// Expected hand-trace (all LUT entries = +1):
//   Layer 1 (Cin=1, Cout=2, K=3)
//     SIC: 3×3 pixels → 9 lookups → 9 × (+1) = 9
//     MIC: 1 channel(s) → sum = 9
//     Pool 2×2: max = 9
//   Layer 2 (Cin=2, Cout=2, K=3)
//     SIC: 3×3 pixels → 9 lookups → 9 × (+1) = 9
//     MIC: 2 channels → sum = 18
//     Pool 2×2: max = 18
//
// Expected output counts (one image):
//   L1 pool: 13×13 = 169 valid pulses
//   L2 pool: 5×5 = 25 valid pulses
//   Flat:            1 valid pulse
//=====================================================

module tb_dut;

    //=====================================================
    // Parameters
    //=====================================================
    parameter CLK_PERIOD  = 8;        // 125 MHz clock
    parameter IMG_WIDTH   = 28;
    parameter IMG_HEIGHT  = 28;
    parameter TOTAL_PX    = IMG_WIDTH * IMG_HEIGHT;  // 784 pixels

    // Expected output counts
    parameter L1_POOL_EXPECTED = 169;  // 13×13
    parameter L2_POOL_EXPECTED = 25;   // 5×5
    parameter FLAT_EXPECTED    = 1;

    //=====================================================
    // DUT I/O
    //=====================================================
    reg         clock;
    reg         sreset_n;
    reg         data_valid;
    reg  [3:0]  pixel_in;

    wire [399:0] flat_out;       // 400 bits
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
    // Event Counters
    //=====================================================
    integer l1_pool_count;
    integer l2_pool_count;
    integer flat_count;
    integer errors;

    //=====================================================
    // Monitor Layer 1 Pooled Output
    //   Expected: ch0 = 9, ch1 = 9
    //=====================================================
    always @(posedge clock) begin
        if (!sreset_n) begin
            l1_pool_count <= 0;
        end
        else if (l1_pool_valid) begin
            l1_pool_count <= l1_pool_count + 1;
            $display("[%0t] L1_POOL[%0d]: ch0=%0d ch1=%0d  (expect 9, 9)",
                     $time, l1_pool_count,
                     $signed(l1_pool_out[7:0]),
                     $signed(l1_pool_out[15:8]));
        end
    end

    //=====================================================
    // Monitor Layer 2 Pooled Output
    //   Expected: ch0 = 18, ch1 = 18
    //=====================================================
    always @(posedge clock) begin
        if (!sreset_n) begin
            l2_pool_count <= 0;
        end
        else if (l2_pool_valid) begin
            l2_pool_count <= l2_pool_count + 1;
            $display("[%0t] L2_POOL[%0d]: ch0=%0d ch1=%0d  (expect 18, 18)",
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
            $display("  flat_out[7:0]     = 0x%h", flat_out[7:0]);
            $display("  flat_out[399:392] = 0x%h", flat_out[399:392]);
        end
    end

    //=====================================================
    // Value Checker — verify expected outputs
    //=====================================================
    always @(posedge clock) begin
        // Check L1 pool values
        if (sreset_n && l1_pool_valid) begin
            if (^l1_pool_out === 1'bx) begin
                $display("[%0t] ERROR: l1_pool_out contains X/Z!", $time);
                errors = errors + 1;
            end
            else if (l1_pool_out !== 16'h0909) begin
                $display("[%0t] MISMATCH: l1_pool_out = 0x%h, expected 0x0909", $time, l1_pool_out);
                errors = errors + 1;
            end
        end

        // Check L2 pool values
        if (sreset_n && l2_pool_valid) begin
            if (^l2_pool_out === 1'bx) begin
                $display("[%0t] ERROR: l2_pool_out contains X/Z!", $time);
                errors = errors + 1;
            end
            else if (l2_pool_out !== 16'h1212) begin
                $display("[%0t] MISMATCH: l2_pool_out = 0x%h, expected 0x1212", $time, l2_pool_out);
                errors = errors + 1;
            end
        end

        // Check flat output
        if (sreset_n && flat_valid) begin
            if (^flat_out === 1'bx) begin
                $display("[%0t] ERROR: flat_out contains X/Z!", $time);
                errors = errors + 1;
            end
        end
    end

    //=====================================================
    // Main Stimulus — Feed ONE 28×28 image, all pixels = 1
    //=====================================================
    integer px;

    initial begin
        // ---- Waveform dump ----
        $dumpfile("tb_dut.vcd");
        $dumpvars(0, tb_dut);

        // ---- Initialize ----
        sreset_n   = 0;
        data_valid = 0;
        pixel_in   = 0;
        errors     = 0;

        // ---- Reset (5 cycles) ----
        repeat (5) @(posedge clock);
        sreset_n = 1;
        @(posedge clock);

        $display("========================================");
        $display(" SIMPLE DEMO — CKAN Model DUT");
        $display("========================================");
        $display(" Image:  28x28 = 784 pixels, all = 1");
        $display(" LUTs:   all entries = +1");
        $display("----------------------------------------");
        $display(" Expected outputs:");
        $display("   L1 pool: ch0=9, ch1=9   (169 outputs)");
        $display("   L2 pool: ch0=18, ch1=18 (25 outputs)");
        $display("   Flat:    1 output");
        $display("========================================");

        // ---- Feed 784 pixels (all = 1) ----
        for (px = 0; px < TOTAL_PX; px = px + 1) begin
            @(posedge clock);
            data_valid = 1;
            pixel_in   = 4'd1;
        end

        // ---- De-assert valid ----
        @(posedge clock);
        data_valid = 0;
        pixel_in   = 0;

        // ---- Wait for pipeline to flush ----
        $display("\n--- Waiting for pipeline to flush ---");
        repeat (500) @(posedge clock);

        // ---- Summary ----
        $display("\n========================================");
        $display(" Simulation Complete");
        $display("----------------------------------------");
        $display(" L1 pool outputs: %0d  (expected %0d)", l1_pool_count, L1_POOL_EXPECTED);
        $display(" L2 pool outputs: %0d  (expected %0d)", l2_pool_count, L2_POOL_EXPECTED);
        $display(" Flat outputs:    %0d  (expected %0d)", flat_count, FLAT_EXPECTED);
        $display(" Errors:          %0d", errors);
        $display("----------------------------------------");
        if (errors == 0 && l1_pool_count == L1_POOL_EXPECTED &&
            l2_pool_count == L2_POOL_EXPECTED &&
            flat_count == FLAT_EXPECTED)
            $display(" STATUS: PASS");
        else
            $display(" STATUS: FAIL");
        $display("========================================");

        $finish;
    end

    //=====================================================
    // Timeout watchdog (3 ms — enough for 784 pixels)
    //=====================================================
    initial begin
        #3000000;
        $display("ERROR: Simulation timed out!");
        $finish;
    end

endmodule
