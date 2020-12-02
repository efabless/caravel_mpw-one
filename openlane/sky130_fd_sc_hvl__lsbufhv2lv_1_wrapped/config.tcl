# This is an analog design. It will be designed by hand.
# This is a placeholder to get things going.
set script_dir [file dirname [file normalize [info script]]]
# User config
set ::env(DESIGN_NAME) sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped
set ::env(STD_CELL_LIBRARY) sky130_fd_sc_hvl

# Change if needed
set ::env(VERILOG_FILES) $script_dir/../../verilog/rtl/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.v
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

# Fill this
set ::env(CLOCK_TREE_SYNTH) 0

set ::env(CELL_PAD) 0

set ::env(PL_RANDOM_GLB_PLACEMENT) 1

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 25 25"
set ::env(BOTTOM_MARGIN_MULT) 0
set ::env(TOP_MARGIN_MULT) 0
set ::env(LEFT_MARGIN_MULT) 0
set ::env(RIGHT_MARGIN_MULT) 0

set ::env(PLACE_SITE) "unithvdbl"
set ::env(PLACE_SITE_WIDTH) 0.480
set ::env(PLACE_SITE_HEIGHT) 8.14
