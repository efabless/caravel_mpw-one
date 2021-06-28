#!/bin/sh
#

cd ../../mag
mv ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag 	../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag.tmp
mv ../maglef/mgmt_protect.mag 					../maglef/mgmt_protect.mag.tmp
mv ../maglef/mgmt_protect_hv.mag 				../maglef/mgmt_protect_hv.mag.tmp
mv ../maglef/mgmt_core.mag 					../maglef/mgmt_core.mag.tmp

maglef2lvs.sh caravel.mag

mv ../maglef/mgmt_core.mag.tmp 					../maglef/mgmt_core.mag
mv ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag.tmp 	../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag
mv ../maglef/mgmt_protect.mag.tmp 				../maglef/mgmt_protect.mag
mv ../maglef/mgmt_protect_hv.mag.tmp 				../maglef/mgmt_protect_hv.mag
cd ../lvs/caravel



netgen -batch lvs "caravel.spice caravel" "../../verilog/gl/caravel.v caravel" \
	sky130A_setup.tcl comp.out
#	|& tee netgen.log

#netgen -batch lvs "../../verilog/gl/caravel.v caravel" "/home/mk/foss/designs/caravel.mpw-one-final/verilog/gl/caravel.v caravel" \
#	sky130A_setup.tcl comp.out-vlog2vlog-delta-mpw-one-final-vs-mpw-one-final+m2fix 
	#|& tee netgen.log


