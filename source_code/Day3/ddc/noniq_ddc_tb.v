`timescale 1ns / 1ns
`include "constants.vams"
`define LO_AMP              74840       // must < (2^17 / `CORDIC_GAIN)
`define NUM_DDS             4
`define DEN_DDS             23

module noniq_ddc_tb;

parameter real SIG_AMP_CNT = 10000;     // ADC counts
parameter real SIG_PHS_DEG = 20;        // deg

parameter real DDC_AMP_GAIN = 3.3396;   // measured
parameter real DDC_PHS_OFF  = 62.6087;  // `NUM_DDS/`DEN_DDS * 360 deg, 1 cycle

parameter FDOWN_LATENCY = 16;           // fdownconvert latency, in clock cycles
parameter CC_N0 = 100;                  // #cycle to inject signal
parameter CC_N1 = CC_N0 + FDOWN_LATENCY + 5;    // #cycle to change input signal phase

parameter real AMP_ACCURACY = 0.001;// < 0.1% RMS
parameter real PHS_ACCURACY = 0.1;  // < 0.1 deg RMS

reg clk, trace=0;
integer cc;
integer out_file;
reg pass=1;
initial begin
    $display("##################################################");
    $display("    ---- Checking noniq_ddc.v ----");
    if ($test$plusargs("vcd")) begin
        $dumpfile("noniq_ddc.vcd");
        $dumpvars(5,noniq_ddc_tb);
    end

    for (cc=0; cc<CC_N1+FDOWN_LATENCY+1; cc=cc+1) begin
        clk=0; #5;
        clk=1; #5;
    end
    $display("Validation: %s.", pass ? "PASS":"FAIL");
    $display("##################################################");
    if (pass) $finish();
    else $stop();
end

task init_dds_task (
     output [19:0] phase_step_h,
     output [11:0] phase_step_l,
     output [11:0] modulo
 );
     integer m, r;
     begin
         m = 4096 / `DEN_DDS;
         modulo = 4096 - m * `DEN_DDS;
         r = {1'b1,{20{1'b0}}} * `NUM_DDS;
         phase_step_h =  r / `DEN_DDS;
         phase_step_l = (r % `DEN_DDS) * m;  
     end
endtask

reg [19:0] phase_step_h;
reg [11:0] phase_step_l;
reg [11:0] modulo;

initial begin
    init_dds_task(phase_step_h, phase_step_l, modulo);
end

real ampi = SIG_AMP_CNT;         // full scale: 2^15
real phsi = SIG_PHS_DEG;         // deg
real theta;
reg signed [15:0] a_data=16'hxxxx;
always @(posedge clk) begin
    theta <= cc * `M_TWO_PI * `NUM_DDS / `DEN_DDS - phsi * `M_PI / 180;
    if (cc >= CC_N0 ) a_data <= $floor(ampi * $cos(theta));
    if (cc == CC_N1) begin
        phsi = phsi + 15; // change stimulus signal phase
        $display(" Changed input signal phase to: %d deg", phsi);
    end
end

wire signed [17:0] cosd, sind;
wire [18:0] dds_phase_acc;
ph_acc dds_lo_i (
    .clk            (clk),
    .reset          (1'b0),
    .en             (1'b1),
    .phase_acc      (dds_phase_acc),
    .phase_step_h   (phase_step_h),
    .phase_step_l   (phase_step_l),
    .modulo         (modulo)
);

cordicg_b22 #(.nstg(20), .width(18)) dds_cordicg_i(
    .clk            (clk),
    .opin           (2'b00),
    .xin            (18'd`LO_AMP),
    .yin            (18'd0),
    .phasein        (dds_phase_acc),
    .xout           (cosd),
    .yout           (sind)
);

wire i_sel;
wire signed [16:0] field_iq;
noniq_ddc #(.ODW(17)) dut(
    .clk        (clk),
    .cosd       (cosd),
    .sind       (sind),
    .a_data     (a_data),
    .i_sel      (i_sel),
    .o_data     (field_iq)
);

wire signed [17:0] field_i, field_q;
// Interpolate downconverted field signals to get separate I&Q signals
fiq_interp #(.a_dw(17), .i_dw(18), .q_dw(18)) interp(
    .clk    (clk),
    .a_data (field_iq),
    .a_gate (1'b1),
    .a_trig (i_sel),
    .i_data (field_i),
    .q_data (field_q)
);

real gain = 1 / $sin(`M_TWO_PI * `NUM_DDS / `DEN_DDS);
real expect_num_i, expect_num_q;
reg signed [15:0] a_data_pre=0;

always @(posedge clk) begin
    a_data_pre <= a_data;
    # 1;
    expect_num_i <= gain * (
        $sin((cc-1) * `M_TWO_PI * `NUM_DDS / `DEN_DDS) * a_data_pre -
        $sin((cc-2) * `M_TWO_PI * `NUM_DDS / `DEN_DDS) * a_data);
    expect_num_q <= gain * (
       -$cos((cc-1) * `M_TWO_PI * `NUM_DDS / `DEN_DDS) * a_data_pre +
        $cos((cc-2) * `M_TWO_PI * `NUM_DDS / `DEN_DDS) * a_data);
end

real expect_i, expect_q;
real amp_out, phs_out;
always @(posedge clk) begin
    # 1;
    expect_i = ampi * $cos(phsi * `M_PI / 180);
    expect_q = ampi * $sin(phsi * `M_PI / 180);
    amp_out = $hypot(field_i, field_q) / DDC_AMP_GAIN;
    phs_out = $atan2(field_q, field_i) * 180 / `M_PI - DDC_PHS_OFF;
    // phs_out = $atan2(field_q, field_i) - 10;
    if (cc == CC_N0 + FDOWN_LATENCY || cc == CC_N1 + FDOWN_LATENCY) begin
        $display("cc = %4d:", cc);
        $display("  Mathematical Expect: I: %8.1f, Q: %8.1f, Amp = %8.1f, Phs = %8.1f deg",
            expect_i, expect_q, ampi, phsi);
        $display("  Numericcal   Expect: I: %8.1f, Q: %8.1f", expect_num_i, expect_num_q);
        $display("  Measured     Result: I: %8d, Q: %8d, Amp = %8.1f, Phs = %8.1f deg",
            field_i, field_q, amp_out, phs_out);
        pass &= $abs((amp_out - ampi) / ampi) < AMP_ACCURACY;
        pass &= $abs((phs_out - phsi)) < PHS_ACCURACY;
    end
end

endmodule
