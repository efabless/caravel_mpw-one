#!/bin/sh
#
# Script for running mixed-mode simulation on hydra_v2p0_test

function killit {
    echo "FAILED!"
   exit 1
}
trap killit ERR

# Path to VPI source files (which have been copied here)
VPIPATH=../source

iverilog-vpi -DD_HDL_BROKEN_CBREADWRITESYNCH \
             $VPIPATH/d_hdl_vpi.c $VPIPATH/d_hdl_vlog.c
iverilog -ohydra_v2p0_test.vo hydra_v2p0_test.v
vvp -M. -md_hdl_vpi hydra_v2p0_test.vo

# Clean up
rm -f *.o *.vpi *.vo simulator_pipe
