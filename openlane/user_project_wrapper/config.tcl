set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_project_wrapper
set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(CLOCK_PORT) "user_clock2"
set ::env(CLOCK_NET) "mprj.clk"

set ::env(CLOCK_PERIOD) "10"

set ::env(FP_PDN_CORE_RING) 1
set ::env(PDN_CFG) $script_dir/pdn.tcl
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 2920 3520"
set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0
set ::env(DIODE_INSERTION_STRATEGY) 0

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/multi_project_harness/multi_project_harness.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/multi_project_harness.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/multi_project_harness.gds"
