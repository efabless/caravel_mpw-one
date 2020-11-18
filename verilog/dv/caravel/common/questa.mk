#****************************************************************************
#* Sim support makefile for Icarus Verilog
#*
#* Variables:
#* - INCDIRS - List of include-path directories
#* - DEFINES - List of definitions
#****************************************************************************

VLOG_SUPPRESS = 2388,2248,2892
#VLOG_SUPPRESS = 2388
#VLOG_SUPPRESS = 2388,2892
#VLOG_SUPPRESS = 2248,2892
#VOPT_SUPPRESS = -suppress 3013

%.questa : %_tb.v %.hex
	vlog $(foreach def,$(DEFINES), +define+$(def)) \
		$(foreach inc,$(INCDIRS),+incdir+$(inc)) \
		-suppress $(VLOG_SUPPRESS) \
		$<
	vopt -debug -o $(*)_tb_opt $(*)_tb $(VOPT_SUPPRESS) +designfile
	touch $@


%.vcd : %.questa
	vsim -batch -do "run -a; quit -f" $(*)_tb_opt \
		-qwavedb=+report=class+signal

clean ::
	rm -rf transcript work *.questa design.bin qwave.db

