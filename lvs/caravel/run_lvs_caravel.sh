#!/bin/sh
#

# cd $PROJECT_ROOT
# mkdir -p ./lvs/caravel
# cd ./lvs/caravel	
# for x in `ls ../../mag/*.mag` ; do ln -s $x . ; done

cd ../../mag
maglef2lvs.sh caravel.mag
cd ../lvs/caravel
netgen -batch lvs "caravel.maglef.lay.spice caravel" "../../verilog/gl/caravel.v caravel" sky130A_setup.tcl caravel_comp.out
cat caravel_comp.out
