include rules.mk

.PHONY: all clean template release

LABS = adc dac dds resonator led_blinker freq_counter feedback vna cordic cic ddc

all: template
	@for d in $(LABS); do \
	    $(MAKE) -C $$d; \
	done;

template:
	$(MAKE) -C template

TARGETS  = adc/adc.pdf
TARGETS += dac/dac.pdf
TARGETS += dds/dds.pdf
TARGETS += resonator/resonator.pdf
TARGETS += led_blinker/led_blinker.pdf
TARGETS += freq_counter/freq_counter.pdf
TARGETS += feedback/feedback.pdf
TARGETS += vna/ntw_analyzer.pdf
TARGETS += cordic/cordic.pdf
TARGETS += cic/cic.pdf
TARGETS += ddc/noniq_ddc.pdf

RELEASE_DIR = $(LABS_DIR)release
release: $(TARGETS)
	mkdir -p $(RELEASE_DIR)
	cp -p $^ $(RELEASE_DIR)
	cd .. ; git archive -o labs.zip HEAD:labs ; cd -

clean::
	@for d in $(LABS); do \
	    $(MAKE) -C $$d clean; \
	done;
