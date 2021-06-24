#!/bin/sh
#

cd ../../mag
mv ../maglef/gpio_control_block.mag ../maglef/gpio_control_block.mag.tmp
maglef2lvs.sh gpio_control_block.mag
mv ../maglef/gpio_control_block.mag.tmp ../maglef/gpio_control_block.mag
cd ../lvs/gpio_control_block

netgen -batch lvs "gpio_control_block.spice gpio_control_block" "../../verilog/gl/gpio_control_block.v gpio_control_block" \
	sky130A_setup.tcl comp.out
#	|& tee netgen.log
