`timescale 1ns / 1ns
module led_test_tb;

integer cc=0;
reg clk=0;
initial begin
    if ($test$plusargs("vcd")) begin
        $dumpfile("led_test.vcd");
        $dumpvars(2, led_test_tb);
    end
    for (cc=0; cc<100; cc++) begin
        #5 clk <= ~clk;
    end
end

wire [3:0] led;
led_test #(.MSB(5)) dut (.clk(clk), .reset(1'b0), .led(led));

endmodule
