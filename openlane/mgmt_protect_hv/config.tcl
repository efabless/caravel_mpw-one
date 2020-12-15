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

set ::env(DESIGN_NAME) mgmt_protect_hv

set ::env(STD_CELL_LIBRARY) sky130_fd_sc_hvl

set ::env(DESIGN_IS_CORE) 1
set ::env(FP_PDN_LOWER_LAYER) met2
set ::env(FP_PDN_UPPER_LAYER) met3
set ::env(FP_PDN_AUTO_ADJUST) 0
set ::env(FP_PDN_VWIDTH) 0.3
set ::env(FP_PDN_HWIDTH) 0.3
set ::env(FP_PDN_CORE_RING_VSPACING) 0.4
set ::env(FP_PDN_CORE_RING_HSPACING) 0.4
set ::env(FP_PDN_VOFFSET) 10
set ::env(FP_PDN_HOFFSET) 1
set ::env(FP_PDN_VWIDTH) 0.3
set ::env(FP_PDN_HWIDTH) 0.3
set ::env(FP_PDN_VPITCH) 80
set ::env(FP_PDN_HPITCH) 10.8

set ::env(GLB_RT_MAXLAYER) 4
# set ::env(FP_PDN_CORE_RING) 1
set ::env(SYNTH_USE_PG_PINS_DEFINES) "USE_POWER_PINS"
set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/mgmt_protect_hv.v"

set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set ::env(SYNTH_TOP_LEVEL) 1

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 150 20"

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(CLOCK_TREE_SYNTH) 0

set ::env(CELL_PAD) 0

set ::env(PL_RANDOM_GLB_PLACEMENT) 1

set ::env(BOTTOM_MARGIN_MULT) 1
set ::env(TOP_MARGIN_MULT) 0
set ::env(LEFT_MARGIN_MULT) 10
set ::env(RIGHT_MARGIN_MULT) 0

set ::env(PLACE_SITE) "unithv"
set ::env(PLACE_SITE_WIDTH) 0.480
set ::env(PLACE_SITE_HEIGHT) 4.07
