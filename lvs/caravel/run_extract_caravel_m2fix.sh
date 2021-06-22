#!/bin/sh
#

magic \
    -noconsole \
    -dnull \
    -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc  \
    run_extract_caravel_m2fix.tcl \
    </dev/null \
    |& tee magic_drc.log

netgen -batch lvs "caravel.mixed-abstraction.lay.spice caravel" "../../verilog/gl/caravel.v caravel" sky130A_setup.tcl caravel_comp.out |& tee netgen.log
##cat caravel_comp.out
##\rm *.ext


