#****************************************************************************
#* Sim support makefile for Icarus Verilog
#*
#* Variables:
#* - INCDIRS - List of include-path directories
#****************************************************************************

%.vpp : %_tb.v %.hex
	iverilog $(foreach def,$(DEFINES),-D$(def)) \
		$(foreach inc,$(INCDIRS),-I $(inc)) \
		$< -o $@

%.vcd : %.vpp
	vvp $<

clean ::
	rm -f *.vpp

