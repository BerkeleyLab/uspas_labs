module arty_led_top (
    input           CLK100MHZ,
    input  [3:0]    BTN,
    output [3:0]    LED
);

wire clk, clk_buf;

IBUF ibufg_i (.I(CLK100MHZ), .O(clk_buf));
BUFG bufg_i (.I(clk_buf), .O(clk));

wire reset = |BTN;
led_test led_test_i (.clk(clk), .reset(BTN), .led(LED));

endmodule
