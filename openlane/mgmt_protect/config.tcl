set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) mgmt_protect

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/mgmt_protect.v"

set ::env(EXTRA_LIBS) "\
	$::env(PDK_ROOT)/$::env(PDK)/libs.ref/sky130_fd_sc_hvl/lib/sky130_fd_sc_hvl__tt_025C_3v30.lib\
	$::env(PDK_ROOT)/$::env(PDK)/libs.ref/sky130_fd_sc_hvl/lib/sky130_fd_sc_hvl__tt_025C_3v30_lv1v80.lib"

set ::env(SYNTH_READ_BLACKBOX_LIB) 1

# set ::env(SYNTH_TOP_LEVEL) 1

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 2000 50"
