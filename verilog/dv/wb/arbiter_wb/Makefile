.SUFFIXES:

PATTERN = arbiter_wb

all:  ${PATTERN:=.vcd}

%.vvp: %_tb.v
	iverilog -I ../../../ip -I .. -I ../../ -I ../../../rtl \
	$< -o $@

%.vcd: %.vvp
	vvp $<

clean:
	rm -f *.vvp *.vcd *.log

.PHONY: clean all
