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

set ::env(DESIGN_NAME) storage
set ::env(SYNTH_TOP_LEVEL) 1

set ::env(CLOCK_PORT) "mgmt_clk"
set ::env(CLOCK_PERIOD) "50"
set ::env(CLOCK_TREE_SYNTH) 0

set ::env(PDN_CFG) $script_dir/pdn.tcl

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
# set ::env(FP_CORE_UTIL) 40
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 450 950"

set ::env(FP_HORIZONTAL_HALO) 5
set ::env(FP_VERTICAL_HALO) 14
set ::env(FP_PDN_VOFFSET) 5
set ::env(FP_PDN_VPITCH) 20
set ::env(FP_PDN_HPITCH) 50


set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro_placement.cfg
set ::env(PL_TARGET_DENSITY) 0.99
set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0
set ::env(PL_RANDOM_GLB_PLACEMENT) 1
set ::env(PL_BASIC_PLACEMENT) 1

set ::env(GLB_RT_ADJUSTMENT) 0
set ::env(GLB_RT_TILES) 14
set ::env(GLB_RT_ALLOW_CONGESTION) 1

set ::env(DIODE_INSERTION_STRATEGY) 1

# magic drc checking on the sram block shows millions of false errors
set ::env(MAGIC_DRC_USE_GDS) 0

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/storage.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
	$script_dir/../../verilog/rtl/sram_1rw1r_32_256_8_sky130.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/sram_1rw1r_32_256_8_sky130_lp1.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/sram_1rw1r_32_256_8_sky130_lp1.gds"
