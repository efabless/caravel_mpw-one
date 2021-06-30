#!/bin/sh
#


export NETGEN=/ef/apps/ocd/netgen/1.5.190-202106241453/bin/netgen

\rm -r chip_io.spice comp.out-clean 


cd ../../mag
mv ../maglef/chip_io.mag ../maglef/chip_io.mag.tmp

maglef2lvs.sh chip_io.mag

mv ../maglef/chip_io.mag.tmp ../maglef/chip_io.mag
cd ../lvs/chip_io

$NETGEN -batch lvs "chip_io.spice chip_io" "../../verilog/gl/chip_io.v chip_io" sky130A_setup.tcl comp.out-clean

## |& tee netgen.log
