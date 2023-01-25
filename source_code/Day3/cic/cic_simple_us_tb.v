`timescale 1ns / 1ns

module cic_simple_us_tb;

parameter CYCLE=8;
reg trace=0;
reg [15:0] vin;
reg [128:0] fname;
integer in_file, r;

reg clk=0;
integer cc;
initial begin
	if ($test$plusargs("vcd")) begin
		$dumpfile("cic_simple_us.vcd");
		$dumpvars(5,cic_simple_us_tb);
	end
    if ($value$plusargs("if=%s", fname)) begin
		trace = 1;
		in_file = $fopen(fname, "r");
		$display("Reading input file: %20s", fname);
	end
	for (cc=0; cc<1024; cc=cc+1) begin
		clk=0; #(CYCLE/2);
		clk=1; #(CYCLE/2);
	end
	$finish();
end

// stimulus
reg [15:0] data_in=44444;
reg data_in_gate=0;
always @(negedge clk) begin
	data_in_gate <= (cc%5) == 2;  // Far more frequent than real life
	if (trace && data_in_gate) begin
		if (!$feof(in_file)) begin
			r = $fscanf(in_file, "%d\n", vin); 
			$display("%g ns, %d", $time, vin);
			data_in <= vin;
		end
	end
end

// DUT
wire [15:0] data_out;
wire data_out_gate;
cic_simple_us #(.dw(16), .ex(5)) dut (.clk(clk),
	.data_in(data_in), .data_in_gate(data_in_gate), .roll(1'b0),
	.data_out(data_out), .data_out_gate(data_out_gate)
);

endmodule
