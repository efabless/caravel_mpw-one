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

set ::env(DESIGN_NAME) gpio_control_block
set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v\
	$script_dir/../../verilog/rtl/gpio_control_block.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
	$script_dir/../../verilog/rtl/gpio_logic_high.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/gpio_logic_high.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/gpio_logic_high.gds"

set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set ::env(SYNTH_USE_PG_PINS_DEFINES) "USE_POWER_PINS"

set ::env(CLOCK_PORT) "serial_clock"
set ::env(CLOCK_PERIOD) "10"

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 170 70"

set ::env(PL_TARGET_DENSITY) 0.94
set ::env(PL_RANDOM_INITIAL_PLACEMENT) 1
set ::env(CELL_PAD) 0

set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro_placement.cfg

# Disable resizer design optimizations to prevent adding a buffer after tristate cells
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0

set ::env(FP_IO_VEXTEND) 20
#set ::env(FP_IO_HEXTEND) 100
set ::env(RIGHT_MARGIN_MULT) 262
set ::env(FP_IO_HLENGTH) 100
set ::env(GLB_RT_MAXLAYER) 4
set ::env(GLB_RT_OBS) \
	"met5 75 0 170 70, met4 75 0 170 70, met2 75 0 170 70, met1 75 0 170 70, met3 58.75 0 70.60000 70"

set ::env(LEFT_MARGIN_MULT) 10
set ::env(TOP_MARGIN_MULT) 4
set ::env(BOTTOM_MARGIN_MULT) 4

set ::env(FP_PDN_VWIDTH) 1.6
set ::env(FP_PDN_HWIDTH) 1.6

set ::env(FP_HORIZONTAL_HALO) 2
set ::env(FP_VERTICAL_HALO) 2

set ::env(FP_PDN_CORE_RING) 1
set ::env(FP_PDN_AUTO_ADJUST) 0

set ::env(FP_PDN_HOFFSET) 1.5
set ::env(FP_PDN_HPITCH) 15.5

set ::env(FP_PDN_VOFFSET) 1.5
set ::env(FP_PDN_VPITCH) 15.5

set ::env(FP_PDN_CORE_RING_VOFFSET) 2
set ::env(FP_PDN_CORE_RING_HOFFSET) 2

set ::env(FP_PDN_VSPACING) 3.4
set ::env(FP_PDN_HSPACING) 3.4
