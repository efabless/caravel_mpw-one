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
set ::env(DESIGN_NAME) mprj_logic_high

# Change if needed
set ::env(VERILOG_FILES) $script_dir/../../verilog/rtl/mprj_logic_high.v
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

# set ::env(FP_CONTEXT_DEF) $script_dir/../mgmt_protect/runs/mgmt_protect/tmp/floorplan/ioPlacer.def.macro_placement.def
# set ::env(FP_CONTEXT_LEF) $script_dir/../mgmt_protect/runs/mgmt_protect/tmp/merged_unpadded.lef

# Fill this
set ::env(CLOCK_TREE_SYNTH) 0

set ::env(CELL_PAD) 0

set ::env(VDD_NETS) "vccd1"
set ::env(GND_NETS) "vssd1"

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

set ::env(PL_RANDOM_INITIAL_PLACEMENT) 1
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 300 23"
set ::env(PL_TARGET_DENSITY) 0.9
set ::env(BOTTOM_MARGIN_MULT) 2
set ::env(TOP_MARGIN_MULT) 2
set ::env(LEFT_MARGIN_MULT) 15
set ::env(RIGHT_MARGIN_MULT) 15
