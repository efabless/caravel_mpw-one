#!/bin/tcsh
#---------------------------------------------------------------
# Shell script setting up all variables used by the qflow scripts
# for this project
#---------------------------------------------------------------

# The LEF file containing standard cell macros

set leffile=/software/PDKs/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef

# The SPICE netlist containing subcell definitions for all the standard cells
set spicefile=/software/PDKs/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice

# The liberty format file containing standard cell timing and function information
set libertyfile=/software/PDKs/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib

# If there is another LEF file containing technology information
# that is separate from the file containing standard cell macros,
# set this.  Otherwise, leave it defined as an empty string.

set techleffile=/software/PDKs/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef

# All cells below should be the lowest output drive strength value,
# if the standard cell set has multiple cells with different drive
# strengths.  Comment out any cells that do not exist.

set bufcell=sky130_fd_sc_hd__buf_1	;# Minimum drive strength buffer cell
set bufpin_in=A			;# Name of input port to buffer cell
set bufpin_out=X		;# Name of output port to buffer cell
set clkbufcell=sky130_fd_sc_hd__clkbuf_1	;# Minimum drive strength buffer cell
set clkbufpin_in=A		;# Name of input port to buffer cell
set clkbufpin_out=X		;# Name of output port to buffer cell

set fillcell=sky130_fd_sc_hd__fill_	;# Spacer (filler) cell (prefix, if more than one)
set decapcell=sky130_fd_sc_hd__decap_	;# Decap (filler) cell (prefix, if more than one)
set antennacell=sky130_fd_sc_hd__diode_	;# Antenna (filler) cell (prefix, if more than one)
set antennapin_in=vpb		;# Antenna cell input connection
set bodytiecell=sky130_fd_sc_hd__tapvpwrvgnd_	;# Body tie (filler) cell (prefix, if more than one)

# yosys tries to eliminate use of these; depends on source .v
set tiehi="sky130_fd_sc_hd__conb_1"	;# Cell to connect to power, if one exists
set tiehipin_out="HI"		;# Output pin name of tiehi cell, if it exists
set tielo="sky130_fd_sc_hd__conb_1"	;# Cell to connect to ground, if one exists
set tielopin_out="LO"		;# Output pin name of tielo cell, if it exists

set gndnet="vgnd,vnb"		;# Name used for ground pins and taps in standard cells
set vddnet="vpwr,vpb"		;# Name used for power pins and taps in standard cells

set separator=""		;# Separator between gate names and drive strengths
set techfile=/software/PDKs/sky130A/libs.tech/magic/sky130A.tech	;# magic techfile
set magicrc=/software/PDKs/sky130A/libs.tech/magic/sky130A.magicrc	;# magic startup script
set magic_display="XR" 	;# magic display, defeat display query and OGL preference
set netgen_setup=/software/PDKs/sky130A/libs.tech/netgen/sky130A_setup.tcl	;# netgen setup file for LVS
set gdsfile=/software/PDKs/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds	;# GDS database of standard cells
set verilogfile=/software/PDKs/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v	;# Verilog models of standard cells

# Set a conditional default in the project_vars.sh file for this process
set postproc_options="-anchors"
# Normally one does not want to use the top metal for signal routing
set route_layers = 5
set fill_ratios="0,70,10,20"
set fanout_options="-l 200 -c 20"
set addspacers_options="-stripe 2.5 50.0 PG"
set xspice_options="-io_time=500p -time=50p -idelay=5p -odelay=50p -cload=250f"
