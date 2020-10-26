set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) chip_io

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/pads.v\
	$script_dir/../../verilog/rtl/mprj_io.v\
	$script_dir/../../verilog/rtl/chip_io.v"

# The removal of this line is pending the IO verilog files being parsable by yosys...
set ::env(VERILOG_FILES_BLACKBOX) "$script_dir/../../verilog/stubs/sky130_fd_io__top_xres4v2.v"

set ::env(DESIGN_IS_PADFRAME) 1
set ::env(SYNTH_FLAT_TOP) 1
set ::env(USE_GPIO_PADS) 1

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 3200 5300"
