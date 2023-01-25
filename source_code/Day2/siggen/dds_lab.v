`timescale 1ns / 1ns

module dds_lab(
     input clk,
     input reset,
     input [19:0] phase_step_h,  // High order (coarse, binary) phase step
     input [11:0] phase_step_l,  // Low order (fine, possibly non-binary) phase step
     input [11:0] modulo,        // Encoding of non-binary modulus; 0 means binary
     input [17:0] lo_strength,   // Suggest 18'd74840
     output signed [17:0] sina,
     output signed [17:0] cosa
);


// PUT YOUR CODE/SOLUTION HERE
//////////////////////////
//
//
//
//////////////////////////

endmodule
