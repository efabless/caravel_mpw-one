set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) mgmt_protect_hv

set ::env(STD_CELL_LIBRARY) sky130_fd_sc_hvl

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/mgmt_protect_hv.v"

set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set ::env(SYNTH_TOP_LEVEL) 1

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 25 25"

set ::env(CLOCK_TREE_SYNTH) 0

set ::env(CELL_PAD) 0

set ::env(PL_RANDOM_GLB_PLACEMENT) 1

set ::env(BOTTOM_MARGIN_MULT) 1
set ::env(TOP_MARGIN_MULT) 1
set ::env(LEFT_MARGIN_MULT) 1
set ::env(RIGHT_MARGIN_MULT) 1

set ::env(PLACE_SITE) "unithv"
set ::env(PLACE_SITE_WIDTH) 0.480
set ::env(PLACE_SITE_HEIGHT) 4.07
