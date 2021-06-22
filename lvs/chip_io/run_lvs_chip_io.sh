#!/bin/sh
#

./maglef2lvs.sh chip_io.mag
netgen -batch lvs "chip_io.maglef.lvs.lay.spice chip_io" "chip_io.v chip_io" sky130A_setup.tcl chip_io_comp.out
cat chip_io_comp.out
