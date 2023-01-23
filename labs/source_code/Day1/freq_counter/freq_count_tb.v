`timescale 1ns / 1ns
// Derived from https://github.com/BerkeleyLab/Bedrock/blob/master/dsp/freq_count_tb.v
module freq_count_tb;

parameter integer FCLK_PERIOD = 6;		// unknown clock period in ns
parameter integer CLK_PERIOD = 20;		// reference clock period in ns
parameter integer REFCNT_DW = 6;

real freq_exp = 1e3 / FCLK_PERIOD;	// MHz
real freq_mea;
real freq_clk = 1e3 / 20;	// MHz
real ferror;

reg clk, f_in;
integer cc;
wire [27:0] result;
initial begin
	if (FCLK_PERIOD < 6) begin
		$display("ERROR: FCLK_PERIOD must be >= 6 ns!");
		$stop();
	end
	if ($test$plusargs("vcd")) begin
		$dumpfile("freq_count.vcd");
		$dumpvars(5,freq_count_tb);
	end
	for (cc=0; cc<220; cc=cc+1) begin
		clk=0; #(CLK_PERIOD / 2);
		clk=1; #(CLK_PERIOD / 2);
	end
	if ($abs(ferror) < 0.5) begin
		$display("PASS");
		$finish();
	end else begin
		$display("FAIL");
		$stop();
	end
end

always begin
	f_in=0; #(FCLK_PERIOD / 2);
	f_in=1; #(FCLK_PERIOD / 2);
end

wire [15:0] diff_stream;
wire diff_stream_strobe;
freq_count #(.refcnt_width(REFCNT_DW)) mut(
	.sysclk				(clk),
	.f_in				(f_in),
	.frequency			(result),
	.diff_stream		(diff_stream),
	.diff_stream_strobe	(diff_stream_strobe)
);

// Simulated accumulation interval is 20 * (2**6) = 1280 ns
// Should catch an average of 1280/6 = 213.33 f_in edges in that time

always @(negedge clk) if (diff_stream_strobe && cc % 5 ==0) begin
	freq_mea = result * freq_clk / 2**REFCNT_DW;  // MHz
	ferror = freq_exp - freq_mea;
	$display(
		"time: %6g ns, measured freq: %6.2f MHz, error = %6.1f MHz",
		$time, freq_mea, ferror);
end
endmodule
