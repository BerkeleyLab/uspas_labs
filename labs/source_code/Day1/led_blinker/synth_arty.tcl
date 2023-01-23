
read_verilog arty_led_top.v
read_verilog led_test.v
read_xdc arty_a7_100.xdc

synth_design -part xc7a100t-csg324-1 -top arty_led_top
opt_design
place_design
# phys_opt_design
route_design

report_utilization
report_timing
write_verilog arty_led_vivado.v
write_bitstream -force arty_led_top.bit
