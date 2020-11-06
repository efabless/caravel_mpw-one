#!/bin/bash
#
# Run netgen on striVe (top level)
#

NETGEN_SETUP=$PDK_ROOT/EFS8A/libs.tech/netgen/EFS8A_setup.tcl

netgen -batch lvs "../spi/openram_tc_1kb.spice openram_tc_1kb" "../verilog/gl/openram_tc_1kb.synthesis.v openram_tc_1kb" ${NETGEN_SETUP} openram_tc_1kb_comp.out -json | tee openram_tc_1kb_comp_lvs.log
