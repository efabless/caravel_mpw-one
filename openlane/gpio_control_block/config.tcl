set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) gpio_control_block
set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/gpio_control_block.v"
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set ::env(CLOCK_PORT) "serial_clock"
set ::env(CLOCK_PERIOD) "10"

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 175 95"

set ::env(PL_TARGET_DENSITY) 0.4
set ::env(PL_BASIC_PLACEMENT) 1

# set ::env(FP_IO_VEXTEND) 20
# set ::env(FP_IO_HEXTEND) 20
set ::env(RIGHT_MARGIN_MULT) 272
set ::env(FP_IO_HLENGTH) 200
set ::env(GLB_RT_MAXLAYER) 4
