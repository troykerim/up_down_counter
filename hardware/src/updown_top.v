`timescale 1ns / 1ps

module updown_top(
input wire clk,                 // 125 MHz clock
    input wire start_btn,          // Start button
    input wire rst_btn,
    input wire sw,
    output wire [6:0] seg,         // 7-segment segments
    output reg [1:0] an            // Active-high anode control
    //output wire [7:0] count_debug

    //output reg [1:0] led
);

reg [7:0] count = 0;
// Signal Declarations
assign count_debug = count;


reg [25:0] slow_cnt = 0;
wire tick_1Hz = slow_cnt[25];

reg [3:0] ones, tens;
reg [3:0] current_digit;

reg [15:0] refresh_cnt = 0;
wire refresh_clk = refresh_cnt[15];

reg count_enable = 0;

wire rst_debounced;
wire start_debounced;

reg [1:0] start_shift;
wire start_rise;

// Debounce Button Inputs

DeBounce #(.clk_freq(50000000), .stable_time(10)) debounce_rst (
    .clk(clk), .reset_n(rst), .button(rst_btn), .result(rst_debounced)
);

DeBounce #(.clk_freq(50000000), .stable_time(10)) debounce_start (
    .clk(clk), .reset_n(rst), .button(start_btn), .result(start_debounced)
);

// Detect Rising Edge for Start

always @(posedge clk)
    start_shift <= {start_shift[0], start_debounced};

assign start_rise = (start_shift == 2'b01);


// Counter Control Logic (with direction switch)
always @(posedge clk) begin
    if (rst_debounced) begin
        count_enable <= 0;
        slow_cnt <= 0;
        count <= (sw == 1'b0) ? 8'd0 : 8'd99;  // reset to 0 if up mode, else to 99
    end else begin
        if (start_rise && !count_enable)
            count_enable <= 1;

        if (count_enable) begin
            slow_cnt <= slow_cnt + 1;

            if (tick_1Hz) begin
                slow_cnt <= 0;

                if (sw == 1'b0) begin
                    // UP MODE
                    if (count == 99) begin
                        count <= 0;
                        count_enable <= 0; // pause
                    end else begin
                        count <= count + 1;
                    end
                end else begin
                    // DOWN MODE
                    if (count == 0) begin
                        count <= 99;
                        count_enable <= 0; // pause
                    end else begin
                        count <= count - 1;
                    end
                end
            end
        end
    end
end

// SSD Digit 
always @* begin
    ones = count % 10;
    tens = count / 10;
end

// SSD Refresh Counter
always @(posedge clk)
    refresh_cnt <= refresh_cnt + 1;

always @(posedge refresh_clk) begin
    if (an == 2'b01) begin
        an <= 2'b10;
        current_digit <= ones;
    end else begin
        an <= 2'b01;
        current_digit <= tens;
    end
end


// SSD Driver
wire [6:0] seg_out;
ssd_driver ssd_inst (.dig(current_digit),.segment(seg_out));

assign seg = seg_out;
endmodule
