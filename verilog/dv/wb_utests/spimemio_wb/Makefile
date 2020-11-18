.SUFFIXES:

PATTERN = spimemio_wb
SIM?=icarus
INCDIRS += ../ ../../ ../../../rtl

all:  ${PATTERN:=.vcd}

clean::
	rm -f *.vvp *.vcd *.log

.PHONY: clean all

# Bring in sim-specific rules
include ../common/$(SIM).mk

