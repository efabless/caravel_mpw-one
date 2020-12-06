#!/bin/sh

NETGEN_SETUP=$PDK_ROOT/sky130A/libs.tech/netgen/sky130A_setup.tcl

netgen -batch lvs "$1 $3" "$2 $3" ${NETGEN_SETUP} $2_comp.out -json | tee $2_comp_lvs.log
