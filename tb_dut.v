`timescale 1ns / 1ps

//=====================================================
// Testbench: tb_dut
// Description:
//   - Drives CKAN_Model_DUT with a 28×28 test image
//   - Monitors intermediate conv/pool outputs and
//     final flattened output
//   - Feeds two full images to verify pipeline reuse
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

    //=====================================================
    // DUT I/O
    //=====================================================
    reg         clock;
    reg         sreset_n;
    reg         data_valid;
    reg  [3:0]  pixel_in;

    wire [399:0] flat_out;
    wire         flat_valid;
    wire [15:0]  l1_pool_out;
    wire         l1_pool_valid;
    wire [15:0]  l2_pool_out;
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
            if (^l1_pool_out === 1'bx)
                $display("[%0t] WARNING: l1_pool_out contains X/Z!", $time);
        end
        if (sreset_n && l2_pool_valid) begin
            if (^l2_pool_out === 1'bx)
                $display("[%0t] WARNING: l2_pool_out contains X/Z!", $time);
        end
        if (sreset_n && flat_valid) begin
            if (^flat_out === 1'bx)
                $display("[%0t] WARNING: flat_out contains X/Z!", $time);
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

        // ---- Reset ----
        repeat (5) @(posedge clock);
        sreset_n = 1;
        @(posedge clock);

        $display("========================================");
        $display(" CKAN Model DUT Testbench Started");
        $display(" Image size: %0d x %0d = %0d pixels",
                 IMG_WIDTH, IMG_HEIGHT, TOTAL_PX);
        $display("========================================");

        // ---- Feed images ----
        for (img_idx = 0; img_idx < NUM_IMAGES; img_idx = img_idx + 1) begin
            $display("\n--- Feeding Image %0d ---", img_idx);

            for (px = 0; px < TOTAL_PX; px = px + 1) begin
                @(posedge clock);
                data_valid = 1;
                // Constant pixel = 1 for easy hand-tracing
                // With LUT=1: L1 conv=9, L1 pool=9, L2 conv=18, L2 pool=18
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
        $display(" L1 pool outputs seen:  %0d", l1_pool_count);
        $display(" L2 pool outputs seen:  %0d", l2_pool_count);
        $display(" Flat valid pulses:     %0d", flat_count);
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
