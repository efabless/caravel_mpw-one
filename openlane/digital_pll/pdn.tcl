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

# Power nets
set ::power_nets $::env(VDD_PIN)
set ::ground_nets $::env(GND_PIN)

set ::macro_blockage_layer_list "li1 met1 met2 met3 met4 met5"

pdngen::specify_grid stdcell {
    name grid
	core_ring {
		met3 {width $::env(FP_PDN_CORE_RING_HWIDTH) spacing $::env(FP_PDN_CORE_RING_HSPACING) core_offset $::env(FP_PDN_CORE_RING_HOFFSET)}
		met4 {width $::env(FP_PDN_CORE_RING_VWIDTH) spacing $::env(FP_PDN_CORE_RING_VSPACING) core_offset $::env(FP_PDN_CORE_RING_VOFFSET)}
	}
	rails {
	    met1 {width 0.48 pitch $::env(PLACE_SITE_HEIGHT) offset 0}
	}
    straps {
	    met4 {width 1.6 pitch $::env(FP_PDN_VPITCH) offset $::env(FP_PDN_VOFFSET)}
    }
    connect {{met1 met4} {met3 met4}}
}


set ::halo 0

# Metal layer for rails on every row
set ::rails_mlayer "met1" ;

# POWER or GROUND #Std. cell rails starting with power or ground rails at the bottom of the core area
set ::rails_start_with "POWER" ;

# POWER or GROUND #Upper metal stripes starting with power or ground rails at the left/bottom of the core area
set ::stripes_start_with "POWER" ;

