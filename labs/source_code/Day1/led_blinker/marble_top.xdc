
# Pmod2 J13
set_property -dict {PACKAGE_PIN AE7 IOSTANDARD LVCMOS15} [get_ports {LED[0]}]
set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS15} [get_ports {LED[1]}]
set_property -dict {PACKAGE_PIN Y7 IOSTANDARD LVCMOS15} [get_ports {LED[2]}]
set_property -dict {PACKAGE_PIN AF7 IOSTANDARD LVCMOS15} [get_ports {LED[3]}]


set_property -dict {PACKAGE_PIN D6} [get_ports GTPREFCLK_P]
set_property -dict {PACKAGE_PIN D5} [get_ports GTPREFCLK_N]

# Bank 0 setup
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]

create_clock -name sys_clk_pin -period 8.00 [get_ports { GTPREFCLK_P }];
