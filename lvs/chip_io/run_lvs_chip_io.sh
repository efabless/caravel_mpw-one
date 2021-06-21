#!/bin/sh
#

cd ../../mag
mv ../maglef/chip_io.mag ../maglef/chip_io.mag.tmp
maglef2lvs.sh chip_io.mag
mv ../maglef/chip_io.mag.tmp ../maglef/chip_io.mag
cd ../lvs/chip_io

netgen -batch lvs "chip_io.maglef.lay.spice chip_io" "../../verilog/gl/chip_io.v chip_io" sky130A_setup.tcl chip_io_comp.out
cat chip_io_comp.out
