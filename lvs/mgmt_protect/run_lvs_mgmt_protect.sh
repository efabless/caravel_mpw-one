#!/bin/sh
#

cd ../../mag
mv ../maglef/mgmt_protect.mag ../maglef/mgmt_protect.mag.tmp
mv ../maglef/mgmt_protect_hv.mag ../maglef/mgmt_protect_hv.mag.tmp

maglef2lvs.sh mgmt_protect.mag

mv ../maglef/mgmt_protect.mag.tmp ../maglef/mgmt_protect.mag
mv ../maglef/mgmt_protect_hv.mag.tmp ../maglef/mgmt_protect_hv.mag

cd ../lvs/mgmt_protect



netgen -batch lvs "mgmt_protect.spice mgmt_protect" "../../verilog/gl/mgmt_protect.v mgmt_protect" \
	sky130A_setup.tcl comp.out
#	|& tee netgen.log
