#!/bin/sh
#
export NETGEN=/ef/apps/ocd/netgen/1.5.190-202106241453/bin/netgen

\rm -rf caravel.spice comp.out-one-error

cd ../../mag

mv ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag 	../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag.tmp
mv ../maglef/chip_io.mag 					../maglef/chip_io.mag.tmp

maglef2lvs.sh caravel.mag

mv ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag.tmp 	../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag
mv ../maglef/chip_io.mag.tmp					../maglef/chip_io.mag

cd ../lvs/caravel

$NETGEN -batch lvs "caravel.spice caravel" "../../verilog/gl/caravel.v caravel" sky130A_setup.tcl comp.out-one-error
#	|& tee netgen.log
