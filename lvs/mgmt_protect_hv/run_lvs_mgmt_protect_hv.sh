#!/bin/sh
#

cd ../../mag
mv ../maglef/mgmt_protect_hv.mag ../maglef/mgmt_protect_hv.mag.tmp

maglef2lvs.sh mgmt_protect_hv.mag

mv ../maglef/mgmt_protect_hv.mag.tmp ../maglef/mgmt_protect_hv.mag
cd ../lvs/mgmt_protect_hv



netgen -batch lvs "mgmt_protect_hv.spice mgmt_protect_hv" "../../verilog/gl/mgmt_protect_hv.v mgmt_protect_hv" \
	sky130A_setup.tcl comp.out
#	|& tee netgen.log
