#!/bin/sh
#
# Run top-level LVS with black-boxed SRAM and I/O cells
# (For the black-boxing, see run_extract_top.sh)

netgen -batch lvs "caravel.spice caravel" "../verilog/gl/caravel_lvs_top.v caravel_lvs_top" sky130A_setup.tcl caravel_comp.out

