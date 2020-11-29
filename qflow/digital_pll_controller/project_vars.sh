#!/bin/tcsh -f
#------------------------------------------------------------
# project variables for project ~/gits/caravel/qflow/digital_pll_controller
#------------------------------------------------------------

# Flow options:
# -------------------------------------------
set synthesis_tool = yosys
set placement_tool = graywolf
set sta_tool = opensta
set router_tool = qrouter
set migrate_tool = magic_db
set lvs_tool = netgen_lvs
set drc_tool = magic_drc
set gds_tool = magic_gds
set display_tool = magic_view

# Synthesis command options:
# -------------------------------------------
# set hard_macros =
# set yosys_options =
# set yosys_script =
# set yosys_debug =
# set abc_script =
# set nobuffers =
# set inbuffers =
# set postproc_options = "-anchors"
# set xspice_options = "-io_time=500p -time=50p -idelay=5p -odelay=50p -cload=250f"
# set fill_ratios = "0,70,10,20"
# set nofanout =
# set fanout_options = "-l 200 -c 20"
# set source_file_list =
# set is_system_verilog =

# Placement command options:
# -------------------------------------------
# set initial_density =
# set graywolf_options =
set addspacers_options = "-stripe 2.5 50.0 PG"

# Router command options:
# -------------------------------------------
set route_show = 1
# set route_layers = "5"
# set via_use =
# set via_stacks =
# set qrouter_options =
# set qrouter_nocleanup =

# STA command options:
# -------------------------------------------

# Minimum period of the clock use "--period value" (value in ps)
# set opensta_options =
set vesta_options = "--long"

# Other options:
# -------------------------------------------
# set migrate_options =
# set lef_options =
# set drc_gdsview =
# set drc_options =
# set gds_options =

#------------------------------------------------------------

