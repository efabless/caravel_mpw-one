#!/bin/sh
#--------------------------------------------------------------------------------
# Run LVS on the simple_por layout
#
# NOTE:  By specifying the testbench for the schematic-side netlist, the proper
# includes used by the testbench simulation are picked up.  Otherwise, the LVS
# itself compares just the simple_por subcircuit from the testbench.
#--------------------------------------------------------------------------------
netgen -batch lvs "simple_por.spice simple_por" "../ngspice/simple_por/simple_por_tb.spice simple_por" ~/projects/efabless/tech/SW/sky130A/libs.tech/netgen/sky130A_setup.tcl comp.out
