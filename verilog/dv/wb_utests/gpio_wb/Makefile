.SUFFIXES:

PATTERN = gpio_wb
SIM?=icarus

all:  ${PATTERN:=.vcd}

INCDIRS += ../ ../../../rtl

clean::
	rm -f *.vvp *.vcd

.PHONY: clean all

# Bring in sim-specific rules
include ../common/$(SIM).mk

