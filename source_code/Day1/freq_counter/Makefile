include ../rules.mk
.PHONY: all clean config_arty_freq

TARGET = freq_count_tb

CLEAN = $(TARGET)
CLEAN += freq_count.vcd freq_count_tb freq_demo_tb freq_demo.vcd
CLEAN += tight_setup_hold_pins.txt

FREQ_DEMO_V = freq_demo.v dec_forward.v b2decimal.v simpleuart.v freq_multi_count_fe.v simplest_gray.v
freq_demo_tb: $(FREQ_DEMO_V)
freq_count_tb: freq_count.v
all: $(TARGET)

freq_demo_top.bit: synth.tcl $(FREQ_DEMO_V) freq_demo_top.v
	$(VIVADO) -nojou -nolog -mode batch -source $<

config_arty_freq:
	openocd -f $(BITFILE_DIR)/openocd_xc7_ft2232.cfg -c "init; pld load 0 freq_demo_top.bit; exit;"
