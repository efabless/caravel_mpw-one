.SUFFIXES:

PATTERN = la_wb

all:  ${PATTERN:=.vcd}

%.vvp: %_tb.v
	iverilog -I .. -I ../../../rtl \
	$< -o $@

%.vcd: %.vvp
	vvp $<

clean:
	rm -f *.vvp *.vcd

.PHONY: clean all
