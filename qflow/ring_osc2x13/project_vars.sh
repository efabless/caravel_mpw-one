#!/bin/tcsh -f
# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

#------------------------------------------------------------
# project variables for project ~/gits/caravel/qflow/ring_osc2x13
#------------------------------------------------------------

# Flow options:
# -------------------------------------------
# set synthesis_tool = yosys
# set placement_tool = graywolf
# set sta_tool = vesta
# set router_tool = qrouter
# set migrate_tool = magic_db
# set lvs_tool = netgen_lvs
# set drc_tool = magic_drc
# set gds_tool = magic_gds
# set display_tool = magic_view

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
# set addspacers_options = "-stripe 2.5 50.0 PG"

# Router command options:
# -------------------------------------------
# set route_show =
# set route_layers = "5"
# set via_use =
# set via_stacks =
# set qrouter_options =
# set qrouter_nocleanup =

# STA command options:
# -------------------------------------------

# Minimum period of the clock use "--period value" (value in ps)
# set opensta_options =
# set vesta_options =

# Other options:
# -------------------------------------------
# set migrate_options =
# set lef_options =
# set drc_gdsview =
# set drc_options =
# set gds_options =

#------------------------------------------------------------

