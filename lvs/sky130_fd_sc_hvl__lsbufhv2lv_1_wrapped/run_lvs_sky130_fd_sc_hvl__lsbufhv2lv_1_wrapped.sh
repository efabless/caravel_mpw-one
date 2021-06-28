#!/bin/sh
#

cd ../../mag
mv ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag.tmp

maglef2lvs.sh sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag

mv ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag.tmp ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag
cd ../lvs/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped

netgen -batch lvs "sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.spice sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped" "../../verilog/gl/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.v sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped" \
	sky130A_setup.tcl comp.out
#	|& tee netgen.log
