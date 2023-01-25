include ../rules.mk

TARGET = cic_simple_us_tb cic_simple_us.vcd

all: $(TARGET)

cic_simple_us_tb: cic_simple_us.v

cic_simple_us.vcd: cic_simple_us_tb
	$(VVP) -N $< +vcd +if=vin.txt

CLEAN = $(TARGET)
