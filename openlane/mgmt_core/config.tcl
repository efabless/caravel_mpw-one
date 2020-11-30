set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) mgmt_core

set ::env(CLOCK_PORT) "clock"
set ::env(CLOCK_PERIOD) "50"
set ::env(SYNTH_STRATEGY) 2
set ::env(SYNTH_MAX_FANOUT) 4

set ::env(FP_PDN_VPITCH) 50
set ::env(PDN_CFG) $script_dir/pdn.tcl

set ::env(FP_VERTICAL_HALO) 6
#set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(FP_CONTEXT_DEF) $script_dir/../caravel/runs/caravel/tmp/floorplan/verilog2def_openroad.def.macro_placement.def
set ::env(FP_CONTEXT_LEF) $script_dir/../caravel/runs/caravel/tmp/merged_unpadded.lef
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 2150 850"


set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro_placement.cfg
set ::env(PL_TARGET_DENSITY) 0.52
set ::env(PL_TARGET_DENSITY_CELLS) 0.38
set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 1
set ::env(CELL_PAD) 4

set ::env(GLB_RT_ADJUSTMENT) 0
set ::env(GLB_RT_TILES) 14

set ::env(DIODE_INSERTION_STRATEGY) 1

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/storage_bridge_wb.v\
	$script_dir/../../verilog/rtl/clock_div.v\
	$script_dir/../../verilog/rtl/caravel_clocking.v\
	$script_dir/../../verilog/rtl/mgmt_core.v\
	$script_dir/../../verilog/rtl/mgmt_soc.v\
	$script_dir/../../verilog/rtl/housekeeping_spi.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/DFFRAM.v
	$script_dir/../../verilog/rtl/digital_pll.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/DFFRAM.lef
	$script_dir/../../lef/digital_pll.lef"
set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/DFFRAM.gds
	$script_dir/../../gds/digital_pll.gds"

