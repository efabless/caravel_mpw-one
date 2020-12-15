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
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set ::env(CLOCK_PORT) "serial_clock"
set ::env(CLOCK_PERIOD) "10"

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 175 95"

set ::env(PL_TARGET_DENSITY) 0.4
set ::env(PL_BASIC_PLACEMENT) 1

# set ::env(FP_IO_VEXTEND) 20
# set ::env(FP_IO_HEXTEND) 20
set ::env(RIGHT_MARGIN_MULT) 272
set ::env(FP_IO_HLENGTH) 200
set ::env(GLB_RT_MAXLAYER) 4
