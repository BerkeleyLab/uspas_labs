
read_verilog marble_led_top.v
read_verilog led_test.v
read_xdc marble_top.xdc

synth_design -part xc7k160t-ffg676-2 -top marble_led_top
opt_design
place_design
# phys_opt_design
route_design

report_utilization
report_timing
write_verilog marble_led_vivado.v
write_bitstream -force marble_led_top.bit
