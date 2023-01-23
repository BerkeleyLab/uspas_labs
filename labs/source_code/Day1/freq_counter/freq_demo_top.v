module freq_demo_top (
    input           CLK100MHZ,
    input  [3:0]    btn,
    output [3:0]    led,
    output          uart_rxd_out,
    input           uart_txd_in
);

wire clk125, locked;
wire clk100, sysclk_buf;
wire reset = |btn;

xilinx7_clocks #(
    .DIFF_CLKIN     ("FALSE"),  // Single ended
    .CLKIN_PERIOD   (10.0),     // 100 MHz
    .MULT           (10),       // 1000 MHz
    .DIV0           (8),        // 125 MHz
    .DIV1           (10)        // 100 MHz
) xilinx7_clocks_i (
    .sysclk_p   (CLK100MHZ),
    .sysclk_n   (1'b0),
    .sysclk_buf (sysclk_buf),
    .reset      (reset),
    .clk_out0   (clk125),
    .clk_out1   (clk100),
    .locked     (locked)
);

// Frequency counter demo to UART
wire [3:0] unk_clk = {3'h0, clk100};
freq_demo freq_demo(
    .refclk     (clk125), 
    .unk_clk    (unk_clk),
    .uart_tx    (uart_rxd_out),
    .uart_rx    (uart_txd_in)
);

reg [31:0] cnt=0;
always @(posedge clk125) begin
    cnt <= reset ? 32'h0 : cnt + 1'b1;
end
assign led = cnt[27:27-3];

endmodule
