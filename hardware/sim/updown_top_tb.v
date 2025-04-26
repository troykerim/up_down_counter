`timescale 1ns / 1ps

module updown_top_tb();

    // Testbench Signals
    reg clk_tb = 0;
    reg start_btn_tb = 0;
    reg rst_btn_tb = 0;
    reg sw_tb = 0;

    wire [6:0] seg_tb;
    wire [1:0] an_tb;
    wire [7:0] count_debug_tb;   // <<=== Add this for monitoring

    // Instantiate the DUT (Device Under Test)
    updown_top uut (
        .clk(clk_tb),
        .start_btn(start_btn_tb),
        .rst_btn(rst_btn_tb),
        .sw(sw_tb),
        .seg(seg_tb),
        .an(an_tb),
        .count_debug(count_debug_tb)
    );

    // Clock generation: 8 ns period for 125 MHz clock
    always #4 clk_tb = ~clk_tb;

    // Monitor key signals
    initial begin
        $monitor("Time=%0t | count_debug_tb=%0d | sw_tb=%b | rst_btn_tb=%b | start_btn_tb=%b", 
                 $time, count_debug_tb, sw_tb, rst_btn_tb, start_btn_tb);
    end

    // Test Procedure
    initial begin
        $display("\n===== Starting Up-Down Counter Testbench =====\n");

        // ----------- Reset everything initially
        rst_btn_tb = 1;
        start_btn_tb = 0;
        sw_tb = 0; // Default to UP mode
        #100;
        rst_btn_tb = 0;

        // ----------- Test 1: UP COUNT 0 -> 99 -> reset to 0
        $display("\n=== Test 1: UP count 00 -> 99 -> Reset to 0 ===");
        start_btn_tb = 1; #20;
        start_btn_tb = 0;
        #(3_000_000);   // enough time to simulate full counting up to 99

        // ----------- Test 2: UP COUNT then RESET early
        $display("\n=== Test 2: UP counting then RESET early ===");
        rst_btn_tb = 1; #20;
        rst_btn_tb = 0;
        start_btn_tb = 1; #20;
        start_btn_tb = 0;
        #(1_500_000);   // count partially
        rst_btn_tb = 1; #20;
        rst_btn_tb = 0;
        #1000;

        // ----------- Test 3: DOWN COUNT starting from 99
        $display("\n=== Test 3: DOWN count 99 -> 0 ===");
        sw_tb = 1;        // Switch to DOWN mode
        rst_btn_tb = 1; #20;
        rst_btn_tb = 0;
        start_btn_tb = 1; #20;
        start_btn_tb = 0;
        #(3_000_000);   // enough time to simulate full counting down to 0

        // ----------- Test 4: DOWN COUNT then RESET early
        $display("\n=== Test 4: DOWN counting then RESET early ===");
        rst_btn_tb = 1; #20;
        rst_btn_tb = 0;
        start_btn_tb = 1; #20;
        start_btn_tb = 0;
        #(1_500_000);   // count partially
        rst_btn_tb = 1; #20;
        rst_btn_tb = 0;
        #1000;

        $display("\n===== Testbench Completed =====\n");
        $stop;
    end

endmodule

