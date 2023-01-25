`timescale 1ns / 1ns

module dds_lab_tb;
parameter CLK_PERIOD = 8;

reg clk=0, reset=0, trace=0;
integer cc=0, out_file;
reg [128:0] fname;
reg [19:0] phase_step_h;
reg [11:0] phase_step_l;
reg [11:0] modulo;
initial begin
    if ($test$plusargs("vcd")) begin
        $dumpfile("dds_lab.vcd");
        $dumpvars(5, dds_lab_tb);
    end
    if ($value$plusargs("of=%s", fname)) begin
        trace = 1;
        out_file = $fopen(fname, "w");
        $display("Recording output to file: %20s", fname);
        $fwrite(out_file, "Time [ns],phase_acc\n");
    end
    if (! $value$plusargs("ph=%d", phase_step_h)) phase_step_h=19'd182361;;
    if (! $value$plusargs("pl=%d", phase_step_l)) phase_step_l=12'd178;
    if (! $value$plusargs("modulo=%d", modulo))   modulo=12'd2;
    $display("phase_step_h: %8d", phase_step_h);
    $display("phase_step_l: %8d", phase_step_l);
    $display("modulo:       %8d", modulo);

    for (cc=0; cc<=1024; cc=cc+1) begin
        #(CLK_PERIOD/2) clk = 0;
        #(CLK_PERIOD - CLK_PERIOD/2) clk = 1;
    end
    $display("Time: %g ns. cc = %5d. Done.", $time, cc);
    $finish();
end

// CHECK THE UPDATED CODE STARTING FROM HERE, THEN PUT YOUR CODE/SOLUTIONS IN THE 'dds_lab.v'
//////////////////////////
wire signed [17:0] cosa, sina; // generate cos and sin signal
dds_lab dut (
    .clk            (clk),
    .reset          (reset),
    .phase_step_h   (phase_step_h),
    .phase_step_l   (phase_step_l),
    .modulo         (modulo),
    .lo_strength    (18'd74840),
    .cosa           (cosa),
    .sina           (sina)
);
//////////////////////////
// UPDATED CODE ENDS HERE

always @(posedge clk) if (trace && cc > 1) begin
    $fwrite(out_file, "%d %d %d\n", $time, cosa, sina);
end

endmodule
