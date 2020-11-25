set script_dir [file dirname [file normalize [info script]]]
# User config
set ::env(DESIGN_NAME) user_id_programming

# Change if needed
set ::env(VERILOG_FILES) $script_dir/../../verilog/rtl/user_id_programming.v
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

# Fill this
set ::env(CLOCK_TREE_SYNTH) 0

set ::env(CELL_PAD) 0

set ::env(FP_CORE_UTIL) 20
set ::env(PL_RANDOM_GLB_PLACEMENT) 1

set ::env(BOTTOM_MARGIN_MULT) 2
set ::env(TOP_MARGIN_MULT) 2
