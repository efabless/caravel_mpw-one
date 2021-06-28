#!/bin/sh
#

cd ../../mag
mv ../maglef/storage.mag ../maglef/storage.mag.tmp
maglef2lvs.sh storage.mag
mv ../maglef/storage.mag.tmp ../maglef/storage.mag
cd ../lvs/storage

netgen -batch lvs "storage.spice storage" "../../verilog/gl/storage.v storage" \
	sky130A_setup.tcl comp.out
#	|& tee netgen.log
