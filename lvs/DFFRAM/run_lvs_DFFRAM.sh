#!/bin/sh
#

cd ../../mag
mv ../maglef/DFFRAM.mag ../maglef/DFFRAM.mag.tmp
maglef2lvs.sh DFFRAM.mag
mv ../maglef/DFFRAM.mag.tmp ../maglef/DFFRAM.mag
cd ../lvs/DFFRAM

MAGIC_EXT_USE_GDS=1 netgen -batch lvs "DFFRAM.spice DFFRAM" "../../verilog/gl/DFFRAM.v DFFRAM" \
	sky130A_setup.tcl comp.out
#	|& tee netgen.log
