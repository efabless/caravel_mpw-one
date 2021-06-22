#!/bin/sh
#

cd ../../mag
mv ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag.tmp
maglef2lvs.sh caravel.mag
mv ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag.tmp ../maglef/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag
cd ../lvs/caravel
netgen -batch lvs "../spi/lvs/caravel.spice caravel" "../../verilog/gl/caravel.v caravel" sky130A_setup.tcl caravel_comp.out |& tee netgen.log
cat caravel_comp.out
