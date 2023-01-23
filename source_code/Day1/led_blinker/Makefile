include ../rules.mk

.PHONY: all clean config_arty_led config_marble_led

TARGET = led_test_tb
CLEAN += $(TARGET) led_test.vcd arty_led_top.bit marble_led_top.bit arty_led_vivado.v marble_led_vivado.v

led_test_tb: led_test.v

all: $(TARGET)

arty_led_top.bit: synth_arty.tcl led_test.v  arty_led_top.v arty_a7_100.xdc
	$(VIVADO) -nojou -nolog -mode batch -source $<

marble_led_top.bit: synth_marble.tcl led_test.v marble_led_top.v marble_top.xdc
	$(VIVADO) -nojou -nolog -mode batch -source $<

config_arty_led: arty_led_top.bit
	openocd -f $(BITFILE_DIR)/openocd_xc7_ft2232.cfg -c "init; pld load 0 $<; exit;"

config_marble_led: marble_led_top.bit
	openocd -f $(BITFILE_DIR)/openocd_marble.cfg -c "init; pld load 0 $<; exit;"
