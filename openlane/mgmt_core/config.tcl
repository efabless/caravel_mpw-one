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

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) mgmt_core

set ::env(RUN_KLAYOUT) 0

set ::env(CLOCK_PORT) "clock"
set ::env(CLOCK_NET) "core_clk"
set ::env(CLOCK_PERIOD) "50"

set ::env(SYNTH_STRATEGY) "AREA 2"
set ::env(SYNTH_MAX_FANOUT) 4

set ::env(FP_PDN_VPITCH) 50
set ::env(FP_PDN_HPITCH) 130
set ::env(PDN_CFG) $script_dir/pdn.tcl

set ::env(FP_VERTICAL_HALO) 6
set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 2250 840"

set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro_placement.cfg
set ::env(PL_TARGET_DENSITY) 0.25
set ::env(CELL_PAD) 0

# Disable resizer design optimizations to prevent adding a buffer after tristate cells
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 1

set ::env(GLB_RT_ADJUSTMENT) 0
set ::env(GLB_RT_L2_ADJUSTMENT) 0.21
set ::env(GLB_RT_L3_ADJUSTMENT) 0.21
set ::env(GLB_RT_L4_ADJUSTMENT) 0.1
set ::env(GLB_RT_L5_ADJUSTMENT) 0.1
set ::env(GLB_RT_L6_ADJUSTMENT) 0.1
set ::env(GLB_RT_TILES) 14
set ::env(GLB_RT_MAXLAYER) 5
set ::env(GLB_RT_ALLOW_CONGESTION) 0
set ::env(GLB_RT_OVERFLOW_ITERS) 200

# Add met4 routing obstruction on DFFRAM macro
set ::env(GLB_RT_OBS) "\
   met4 122.000 111.000 872.000 636.000"

set ::env(DIODE_INSERTION_STRATEGY) 4

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/storage_bridge_wb.v\
	$script_dir/../../verilog/rtl/clock_div.v\
	$script_dir/../../verilog/rtl/caravel_clocking.v\
	$script_dir/../../verilog/rtl/mgmt_core.v\
	$script_dir/../../verilog/rtl/mgmt_soc.v\
	$script_dir/../../verilog/rtl/housekeeping_spi.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/DFFRAM.v
	$script_dir/../../verilog/rtl/digital_pll.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/DFFRAM.lef
	$script_dir/../../lef/digital_pll.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/DFFRAM.gds
	$script_dir/../../gds/digital_pll.gds"

