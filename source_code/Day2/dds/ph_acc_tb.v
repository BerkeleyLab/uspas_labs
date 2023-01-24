`timescale 1ns / 1ns

module ph_acc_tb;
parameter CLK_PERIOD = 8;

reg clk=0, reset=0, trace=0;
integer cc=0, out_file;
reg [128:0] fname;
initial begin
    if ($test$plusargs("vcd")) begin
        $dumpfile("ph_acc.vcd");
        $dumpvars(5,ph_acc_tb);
    end
    if ($value$plusargs("of=%s", fname)) begin
        trace = 1;
        out_file = $fopen(fname, "w");
        $display("Recording output to file: %20s", fname);
        $fwrite(out_file, "Time [ns],phase_acc\n");
    end

    for (cc=0; cc<=8192; cc=cc+1) begin
        #(CLK_PERIOD/2) clk <= 0;
        #(CLK_PERIOD/2) clk <= 1;
    end
    $display("Time: %g ns. cc = %5d. Done.", $time, cc);
    $finish();
end

wire [18:0] phase_acc;
reg [19:0] phase_step_h=19'd182361;
reg [11:0] phase_step_l=12'd178;
reg [11:0] modulo=12'd2;
reg en=0;
ph_acc dut (
    .clk            (clk),
    .reset          (reset),
    .en             (en),
    .phase_acc      (phase_acc),
    .phase_step_h   (phase_step_h),
    .phase_step_l   (phase_step_l),
    .modulo         (modulo)
);

integer r;
initial begin
    r = $value$plusargs("ph=%d", phase_step_h);
    r = $value$plusargs("pl=%d", phase_step_l);
    r = $value$plusargs("modulo=%d", modulo);
    $display("phase_step_h: %8d", phase_step_h);
    $display("phase_step_l: %8d", phase_step_l);
    $display("modulo:       %8d", modulo);
    en = 1'b1;
end

always @(posedge clk) if (trace && cc > 1) begin
    $fwrite(out_file, "%d,%d\n", $time, phase_acc);
end

endmodule