LABS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
BITFILE_DIR = $(LABS_DIR)bitfiles
BITFILE = $(BITFILE_DIR)/marble_zest_top_uspas.bit
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave
VIVADO = vivado
PYTHON = python

%_tb: %_tb.v
	$(IVERILOG) ${VFLAGS_$@} -Wall -Wno-timescale -o $@ $^

%.vcd: %_tb
	$(VVP) -N $< +vcd

%_view: %.vcd %.gtkw
	$(GTKWAVE) $^

%.pdf: %.ipynb
	jupyter nbconvert $< --to pdf --template uspas

config_marble: 
	openocd -f $(BITFILE_DIR)/openocd_marble.cfg -c "init; pld load 0 $(BITFILE); exit;"

.DEFAULT_GOAL := all

.PHONY: clean all config_marble

clean::
	rm -f $(CLEAN)