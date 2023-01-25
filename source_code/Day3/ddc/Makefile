include ../rules.mk

TARGET = noniq_ddc_tb noniq_ddc.vcd
# TARGET += noniq_ddc.pdf

vpath %.v ../../Day2/cordic

noniq_ddc_tb: noniq_ddc.v ../../Day2/cordic/cordicg_b22.v fiq_interp.v cstageg.v addsubg.v  ../../Day2/dds/ph_acc.v

../../Day2/cordic/cordicg_b22.v:
	$(MAKE) -C ../../Day2/cordic cordicg_b22.v

all: $(TARGET)

CLEAN = $(TARGET)
