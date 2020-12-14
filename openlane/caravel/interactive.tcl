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

package require openlane
set script_dir [file dirname [file normalize [info script]]]
prep -design $script_dir -tag caravel -overwrite
set save_path $script_dir/../..

set ::env(SYNTH_DEFINES) "TOP_ROUTING"
verilog_elaborate
#logic_equiv_check -lhs $top_rtl -rhs $::env(yosys_result_file_tag).v

init_floorplan

add_macro_placement padframe 0 0 N
add_macro_placement storage 260.160 265.780 N
add_macro_placement soc 1052.110 268.010 N
add_macro_placement mprj 326.540 1393.580 N
add_macro_placement mgmt_buffers 1060.900 1234.240 N
add_macro_placement rstb_level 664.480 234.780  S
add_macro_placement user_id_value 3283.120 404.630 N
add_macro_placement por 3270.880 522.711 MX

# west
set west_x 42.835
add_macro_placement "gpio_control_in\\\[37\\\]" $west_x 1013.000 R0
add_macro_placement "gpio_control_in\\\[36\\\]" $west_x 1229.000 R0
add_macro_placement "gpio_control_in\\\[35\\\]" $west_x 1445.000 R0
add_macro_placement "gpio_control_in\\\[34\\\]" $west_x 1661.000 R0
add_macro_placement "gpio_control_in\\\[33\\\]" $west_x 1877.000 R0
add_macro_placement "gpio_control_in\\\[32\\\]" $west_x 2093.000 R0
add_macro_placement "gpio_control_in\\\[31\\\]" $west_x 2731.000 R0

add_macro_placement "gpio_control_in\\\[30\\\]" $west_x 2947.000 R0
add_macro_placement "gpio_control_in\\\[29\\\]" $west_x 3163.000 R0
add_macro_placement "gpio_control_in\\\[28\\\]" $west_x 3379.000 R0
add_macro_placement "gpio_control_in\\\[27\\\]" $west_x 3595.000 R0
add_macro_placement "gpio_control_in\\\[26\\\]" $west_x 3811.000 R0
add_macro_placement "gpio_control_in\\\[25\\\]" $west_x 4027.000 R0
add_macro_placement "gpio_control_in\\\[24\\\]" $west_x 4656.120 R0

# north
set north_y 4979.065
add_macro_placement "gpio_control_in\\\[23\\\]" 486.000 $north_y R270
add_macro_placement "gpio_control_in\\\[22\\\]" 743.000 $north_y R270
add_macro_placement "gpio_control_in\\\[21\\\]" 1000.000 $north_y R270
add_macro_placement "gpio_control_in\\\[20\\\]" 1257.000 $north_y R270
add_macro_placement "gpio_control_in\\\[19\\\]" 1515.000 $north_y R270
add_macro_placement "gpio_control_in\\\[18\\\]" 1767.000 $north_y R270
add_macro_placement "gpio_control_in\\\[17\\\]" 2104.000 $north_y R270
add_macro_placement "gpio_control_in\\\[16\\\]" 2489.000 $north_y R270
add_macro_placement "gpio_control_in\\\[15\\\]" 2746.000 $north_y R270

# east
set east_x 3373.015
add_macro_placement "gpio_control_bidir\\\[0\\\]" $east_x 605.000 MY
add_macro_placement "gpio_control_bidir\\\[1\\\]" $east_x 831.000 MY
add_macro_placement "gpio_control_in\\\[2\\\]" $east_x 1056.000 MY
add_macro_placement "gpio_control_in\\\[3\\\]" $east_x 1282.000 MY
add_macro_placement "gpio_control_in\\\[4\\\]" $east_x 1507.000 MY
add_macro_placement "gpio_control_in\\\[5\\\]" $east_x 1732.000 MY
add_macro_placement "gpio_control_in\\\[6\\\]" $east_x 1958.000 MY
add_macro_placement "gpio_control_in\\\[7\\\]" $east_x 2399.000 MY
add_macro_placement "gpio_control_in\\\[8\\\]" $east_x 2619.000 MY
add_macro_placement "gpio_control_in\\\[9\\\]" $east_x 2844.000 MY
add_macro_placement "gpio_control_in\\\[10\\\]" $east_x 3070.000 MY
add_macro_placement "gpio_control_in\\\[11\\\]" $east_x 3295.000 MY
add_macro_placement "gpio_control_in\\\[12\\\]" $east_x 3521.000 MY
add_macro_placement "gpio_control_in\\\[13\\\]" $east_x 3746.000 MY
add_macro_placement "gpio_control_in\\\[14\\\]" $east_x 4638.000 MY

manual_macro_placement f

# modify to a different file
remove_pins -input $::env(CURRENT_DEF)
remove_empty_nets -input $::env(CURRENT_DEF)

add_macro_obs \
	-defFile $::env(CURRENT_DEF) \
	-lefFile $::env(MERGED_LEF_UNPADDED) \
	-obstruction vddio_obs \
	-placementX 103.400 \
	-placementY 607.150 \
	-sizeWidth 94.500 \
	-sizeHeight 30 \
	-fixed 1 \
	-layerNames "met2 met4"

li1_hack_start
global_routing
detailed_routing
li1_hack_end

run_magic

save_views       -lef_path $::env(magic_result_file_tag).lef \
                 -def_path $::env(tritonRoute_result_file_tag).def \
                 -gds_path $::env(magic_result_file_tag).gds \
                 -mag_path $::env(magic_result_file_tag).mag \
				 -verilog_path $::env(CURRENT_NETLIST) \
                 -save_path $save_path \
                 -tag $::env(RUN_TAG)
