
read_verilog freq_demo_top.v
read_verilog {freq_demo.v dec_forward.v b2decimal.v simpleuart.v freq_multi_count_fe.v simplest_gray.v}
read_verilog {xilinx7_clocks.v}
read_xdc arty_a7_100.xdc

synth_design -part xc7a100t-csg324-1 -top freq_demo_top
opt_design
place_design
# phys_opt_design
route_design

report_utilization
report_timing
write_bitstream -force freq_demo_top.bit
