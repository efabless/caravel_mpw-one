#!/usr/bin/tclsh
# Copyright 2020 Efabless Corporation
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


puts "Performing Spice Extractions..."

if { ![file isdirectory $::env(OUT_DIR)] } {
	exec mkdir $::env(OUT_DIR)/
}


if { $::env(TARGET_TYPE) == "gds"} {
	gds read $::env(TARGET_DIR)/$::env(DESIGN_NAME).gds
} else {
	if { $::env(TARGET_TYPE) == "mag" } {
		load $::env(TARGET_DIR)/$::env(DESIGN_NAME).mag
	} else {
		def read $::env(TARGET_DIR)/$::env(DESIGN_NAME).def
	}
}

load $::env(DESIGN_NAME) -dereference
cd $::env(OUT_DIR)/
extract do local
# extract warn all
extract
ext2spice lvs
ext2spice $::env(DESIGN_NAME).ext
feedback save $::env(OUT_DIR)/magic_extraction_feedback.txt

puts "Done!"