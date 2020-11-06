set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) storage

set ::env(CLOCK_PORT) "mgmt_clk"
set ::env(CLOCK_PERIOD) "50"
set ::env(SYNTH_STRATEGY) 2

set ::env(PDN_CFG) $script_dir/pdn.tcl

#set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
# set ::env(FP_CORE_UTIL) 40
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 950 1900"

set ::env(FP_HORIZONTAL_HALO) 5
set ::env(FP_VERTICAL_HALO) 10
set ::env(FP_PDN_VPITCH) 50
set ::env(FP_PDN_HPITCH) 50


set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro_placement.cfg
set ::env(PL_TARGET_DENSITY) 0.45
set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0

set ::env(GLB_RT_ADJUSTMENT) 0
set ::env(GLB_RT_TILES) 14

set ::env(DIODE_INSERTION_STRATEGY) 0

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/storage.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
	$script_dir/../../verilog/rtl/sram_1rw1r_32_256_8_sky130.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/sram_1rw1r_32_256_8_sky130_lp1.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/sram_1rw1r_32_256_8_sky130_lp1.gds"
