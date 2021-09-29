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
# User config
set ::env(DESIGN_NAME) digital_pll

# Change if needed
set ::env(VERILOG_FILES) $script_dir/../../verilog/rtl/digital_pll.v
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

# Fill this
set ::env(CLOCK_TREE_SYNTH) 0

set ::env(PDN_CFG) $script_dir/pdn.tcl
set ::env(FP_PDN_CORE_RING) 0
set ::env(FP_PDN_VPITCH) 50
set ::env(FP_PDN_HPITCH) 50


set ::env(SYNTH_BUFFERING) 0
set ::env(SYNTH_SIZING) 0

set ::env(CELL_PAD) 4

set ::env(FP_CORE_UTIL) 50
set ::env(PL_TARGET_DENSITY) 0.55
set ::env(SYNTH_MAX_FANOUT) 6

set ::env(FP_PDN_CORE_RING) 1
set ::env(DESIGN_IS_CORE) 0
set ::env(GLB_RT_MAXLAYER) 5
