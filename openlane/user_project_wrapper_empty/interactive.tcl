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

prep -design $script_dir -tag user_project_wrapper -overwrite
set save_path $script_dir/../..

verilog_elaborate

init_floorplan

# making it "empty"
remove_nets -input $::env(CURRENT_DEF)
remove_components -input $::env(CURRENT_DEF)

place_io_ol

apply_route_obs

run_power_grid_generation

# pdngen-related hack
# remove .extra\d+ "pins" so that magic
# generates shapes for each stripes without the ".extra" postfix
# until OpenDB can understand this syntax...
exec sed \
    -i -E {/^PINS/,/^END PINS/ s/\.extra[[:digit:]]+(.*USE (GROUND|POWER))/\1/g} \
    $::env(CURRENT_DEF)
        

run_magic

save_views       -lef_path $::env(magic_result_file_tag).lef \
                 -def_path $::env(CURRENT_DEF) \
                 -gds_path $::env(magic_result_file_tag).gds \
                 -mag_path $::env(magic_result_file_tag).mag \
                 -spice_path $::env(magic_result_file_tag).spice \
                 -save_path $save_path \
                 -tag $::env(RUN_TAG)

# produce "obstructed" LEF to be used for routing
set gap 0.4
set llx [expr [lindex $::env(DIE_AREA) 0]-$gap]
set lly [expr [lindex $::env(DIE_AREA) 1]-$gap]
set urx [expr [lindex $::env(DIE_AREA) 2]+$gap]
set ury [expr [lindex $::env(DIE_AREA) 3]+$gap]

exec python3 $::env(OPENLANE_ROOT)/scripts/rectify.py $llx $lly $urx $ury \
	< $::env(magic_result_file_tag).lef \
	| python3 $::env(OPENLANE_ROOT)/scripts/obs.py -42.88 -37.53 2962.50 3557.21 met4,met5 \
	| python3 $::env(OPENLANE_ROOT)/scripts/obs.py {*}$::env(DIE_AREA) li1,met1,met2,met3 \
	> $::env(magic_result_file_tag).obstructed.lef
file copy -force $::env(magic_result_file_tag).obstructed.lef $save_path/lef

generate_final_summary_report