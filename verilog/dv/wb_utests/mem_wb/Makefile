.SUFFIXES:

PATTERN = mem_wb
SIM?=icarus
INCDIRS += ../ ../../ ../../../rtl

all:  ${PATTERN:=.vcd}


clean::
	rm -f *.vvp *.vcd

.PHONY: clean all

# Bring in sim-specific rules
include ../common/$(SIM).mk

