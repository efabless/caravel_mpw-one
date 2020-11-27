set script_dir [file dirname [file normalize [info script]]]
# User config
set ::env(DESIGN_NAME) digital_pll

# Change if needed
set ::env(VERILOG_FILES) $script_dir/../../verilog/rtl/digital_pll.v
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

# Fill this
set ::env(CLOCK_TREE_SYNTH) 0

set ::env(PDN_CFG) $script_dir/pdn.tcl
set ::env(FP_PDN_CORE_RING) 0
set ::env(FP_PDN_VPITCH) 50
set ::env(FP_PDN_HPITCH) 50


set ::env(SYNTH_BUFFERING) 0
set ::env(SYNTH_SIZING) 0

set ::env(CELL_PAD) 4

set ::env(FP_CORE_UTIL) 50
set ::env(PL_TARGET_DENSITY) 0.55
set ::env(SYNTH_MAX_FANOUT) 6

set ::env(FP_PDN_CORE_RING) 1
set ::env(DESIGN_IS_CORE) 0
set ::env(GLB_RT_MAXLAYER) 5
