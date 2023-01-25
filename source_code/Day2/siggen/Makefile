include ../rules.mk
CORDIC_DIR = ../cordic
include $(CORDIC_DIR)/rules.mk

all: waves.csv

vpath %.v ../dds ../cordic

cordicg_b22.v: ../cordic/cordicgx.py
	$(PYTHON) $< 22 > $@

dds_lab_tb: dds_lab.v ph_acc.v cordicg_b22.v cstageg.v addsubg.v

waves.csv: dds_lab_tb
	$(VVP) $< +of=$@

CLEAN += waves.csv dds_lab_tb cordicg_b22.v
