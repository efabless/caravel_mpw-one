# This is an analog design. It will be designed by hand.
# This is a placeholder to get things going.
set script_dir [file dirname [file normalize [info script]]]
# User config
set ::env(DESIGN_NAME) simple_por
set ::env(STD_CELL_LIBRARY) sky130_fd_sc_hvl

# Change if needed
set ::env(VERILOG_FILES) $script_dir/../../verilog/rtl/simple_por.v
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

# Fill this
set ::env(CLOCK_TREE_SYNTH) 0

set ::env(CELL_PAD) 8

set ::env(FP_CORE_UTIL) 30
set ::env(PL_TARGET_DENSITY) 0.5
