#!/bin/sh
#

export NETGEN=/ef/apps/ocd/netgen/1.5.190-202106241453/bin/netgen

\rm -r caravel.spice comp.out-clean 

cd ../../mag

mv ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag 	../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag.tmp
mv ../maglef/mgmt_protect.mag 					../maglef/mgmt_protect.mag.tmp
mv ../maglef/chip_io.mag 					../maglef/chip_io.mag.tmp

maglef2lvs.sh caravel.mag

mv ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag.tmp 	../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag
mv ../maglef/mgmt_protect.mag.tmp 				../maglef/mgmt_protect.mag
mv ../maglef/chip_io.mag.tmp					../maglef/chip_io.mag

cd ../lvs/caravel

$NETGEN -batch lvs "caravel.spice caravel" "../../verilog/gl/caravel.v caravel" sky130A_setup.tcl comp.out-clean
#	|& tee netgen.log






#netgen -batch lvs "caravel.spice caravel" "../../../caravel.mpw-one-final/verilog/gl/caravel.v caravel" \
#	sky130A_setup.tcl comp.out-new-layout-vs-mpw-one-final-vlog
#	|& tee netgen.log

#netgen -batch lvs "../../verilog/gl/caravel.v caravel" "../../../caravel.mpw-one-final/verilog/gl/caravel.v caravel" \
#	sky130A_setup.tcl comp.out-vlog2vlog-delta-mpw-one-final-vs-mpw-one-final+m2fix 
#	|& tee netgen.log



##mv ../maglef/mgmt_core.mag 					../maglef/mgmt_core.mag.tmp
#mv ../maglef/mgmt_protect_hv.mag 				../maglef/mgmt_protect_hv.mag.tmp
##mv ../maglef/mprj_logic_high.mag 				../maglef/mprj_logic_high.mag.tmp
##mv ../maglef/mprj2_logic_high.mag 				../maglef/mprj2_logic_high.mag.tmp
#mv ../maglef/gpio_control_block.mag                             ../maglef/gpio_control_block.mag.tmp
#mv ../maglef/simple_por.mag                                     ../maglef/simple_por.mag.tmp
########
##mv ../maglef/mgmt_core.mag.tmp 					../maglef/mgmt_core.mag
##mv ../maglef/mgmt_protect_hv.mag.tmp 				../maglef/mgmt_protect_hv.mag
##mv ../maglef/mprj_logic_high.mag.tmp				../maglef/mprj_logic_high.mag
##mv ../maglef/mprj2_logic_high.mag.tmp				../maglef/mprj2_logic_high.mag
#mv ../maglef/gpio_control_block.mag.tmp                         ../maglef/gpio_control_block.mag
#mv ../maglef/simple_por.mag.tmp                                 ../maglef/simple_por.mag


