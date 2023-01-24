include ../rules.mk

TARGET = cordic_ptor.csv cordic_rtop.csv
NSTG = 20		# Number of stages
DW = 18			# CORDIC data width 16 <= DW <= 21
VFLAGS_cordicg_tb = -P cordicg_tb.width=$(DW) -P cordicg_tb.nstg=$(NSTG)

all: $(TARGET)

cordicg_tb: cordicg_b22.v cstageg.v addsubg.v

# Internal data width : 22 bits
cordicg_b22.v: cordicgx.py
	$(PYTHON) $< 22 > $@

cordic_ptor.csv: cordicg_tb
	$(VVP) -N $< +op=0 +of=$@

cordic_rtop.csv: cordicg_tb
	$(VVP) -N $< +op=1 +of=$@

CLEAN = $(TARGET) cordicg_b22.v
