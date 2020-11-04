set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) mgmt_core

set ::env(CLOCK_PORT) "clock"
set ::env(CLOCK_PERIOD) "50"
set ::env(SYNTH_STRATEGY) 2

set ::env(PDN_CFG) $script_dir/pdn.tcl

set ::env(FP_VERTICAL_HALO) 6
set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 1800 1900"


set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro_placement.cfg
set ::env(PL_TARGET_DENSITY) 0.37
set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0
set ::env(CELL_PAD) 10

set ::env(GLB_RT_ADJUSTMENT) 0
set ::env(GLB_RT_TILES) 14

set ::env(DIODE_INSERTION_STRATEGY) 0

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/storage_bridge_wb.v\
	$script_dir/../../verilog/rtl/clock_div.v\
	$script_dir/../../verilog/rtl/caravel_clocking.v\
	$script_dir/../../verilog/rtl/mgmt_core.v\
	$script_dir/../../verilog/rtl/mgmt_soc.v\
	$script_dir/../../verilog/rtl/housekeeping_spi.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
	$script_dir/../../verilog/rtl/digital_pll.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/digital_pll.lef"
set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/digital_pll.gds"

