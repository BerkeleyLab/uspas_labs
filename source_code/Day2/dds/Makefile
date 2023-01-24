include ../rules.mk

TARGET = ph_acc.csv dds.pdf dds_solution.pdf

all: $(TARGET)

CLEAN = $(TARGET) ph_acc.vcd ph_acc_tb

ph_acc.csv: ph_acc_tb
	$(VVP) -N $< +of=$@

ph_acc_tb: ph_acc.v