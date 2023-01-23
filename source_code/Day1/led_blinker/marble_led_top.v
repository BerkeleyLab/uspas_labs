module marble_led_top (
    input           GTPREFCLK_P,
    input           GTPREFCLK_N,
    output [3:0]    LED
);

wire clk, clk_buf;

IBUFDS_GTE2 ibufg_i (.I(GTPREFCLK_P), .IB(GTPREFCLK_N), .CEB(1'b0), .O(clk_buf));
BUFG bufg_i (.I(clk_buf), .O(clk));

wire reset = 1'b0;
led_test led_test_i (.clk(clk), .reset(btn), .led(LED));

endmodule
