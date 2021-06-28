#!/bin/sh
#

cd ../../mag
mv ../maglef/user_id_programming.mag ../maglef/user_id_programming.mag.tmp
maglef2lvs.sh user_id_programming.mag
mv ../maglef/user_id_programming.mag.tmp ../maglef/user_id_programming.mag
cd ../lvs/user_id_programming

netgen -batch lvs "user_id_programming.spice user_id_programming" "../../verilog/gl/user_id_programming.v user_id_programming" \
	sky130A_setup.tcl comp.out
#	|& tee netgen.log
