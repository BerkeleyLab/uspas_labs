module led_test #(
    parameter MSB = 27
) (
    input clk,
    input reset,
    output [3:0] led
);

reg [31:0] cnt=0;
always @(posedge clk) begin
    cnt <= reset ? 32'h0 : cnt + 1'b1;
end
assign led = cnt[MSB:MSB-3];

endmodule
