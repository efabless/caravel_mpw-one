#!/bin/sh
#

cd ../../mag
mv ../maglef/digital_pll.mag ../maglef/digital_pll.mag.tmp
maglef2lvs.sh digital_pll.mag
mv ../maglef/digital_pll.mag.tmp ../maglef/digital_pll.mag
cd ../lvs/digital_pll

netgen -batch lvs "digital_pll.spice digital_pll" "../../verilog/gl/digital_pll.v digital_pll" \
	sky130A_setup.tcl comp.out
#	|& tee netgen.log
