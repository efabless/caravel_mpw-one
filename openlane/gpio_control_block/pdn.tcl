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
set ::power_nets $::env(_VDD_NET_NAME)
set ::ground_nets $::env(_GND_NET_NAME)

if { $::env(VCCD_GRID) } {
	pdngen::specify_grid stdcell {
	    name grid
		core_ring {
			met5 {width $::env(_WIDTH) spacing $::env(_SPACING) core_offset $::env(_H_OFFSET)}
			met4 {width $::env(_WIDTH) spacing $::env(_SPACING) core_offset $::env(_V_OFFSET)}
		}
		rails {
		    met1 {width $::env(FP_PDN_RAIL_WIDTH) pitch $::env(PLACE_SITE_HEIGHT) offset $::env(FP_PDN_RAIL_OFFSET)}
	    }
	    straps {
		    met4 {width $::env(FP_PDN_VWIDTH) pitch $::env(FP_PDN_VPITCH) offset $::env(FP_PDN_VOFFSET)}
		    met5 {width $::env(FP_PDN_HWIDTH) pitch $::env(FP_PDN_HPITCH) offset $::env(FP_PDN_HOFFSET)}
	    }
	    connect {{met1 met4} {met4 met5}}
	}
} else {
	pdngen::specify_grid stdcell {
	    name grid
	    core_ring {
		met5 {width $::env(_WIDTH) spacing $::env(_SPACING) core_offset $::env(_H_OFFSET)}
		met4 {width $::env(_WIDTH) spacing $::env(_SPACING) core_offset $::env(_V_OFFSET)}
	    }
	    rails {

	    }
	    straps {
		    met4 {width $::env(FP_PDN_VWIDTH) pitch $::env(FP_PDN_VPITCH) offset $::env(FP_PDN_VOFFSET)}
		    met5 {width $::env(FP_PDN_HWIDTH) pitch $::env(FP_PDN_HPITCH) offset $::env(FP_PDN_HOFFSET)}
	    }
	    connect {{met4 met5}}
	}
}


if { $::env(CONNECT_GRIDS) } {
	pdngen::specify_grid macro {
	    orient {R0 R180 MX MY R90 R270 MXR90 MYR90}
	    power_pins "vccd1"
	    ground_pins "vssd1"
	    blockages "li1 met1 met2 met3 met4"
	    straps { 
	    } 
	    connect {{met4_PIN_ver met5}}
	}
} else {
	pdngen::specify_grid macro {
	    orient {R0 R180 MX MY R90 R270 MXR90 MYR90}
	    power_pins "VPWR"
	    ground_pins "VGND"
	    blockages "li1 met1 met2 met3 met4"
	    straps { 
	    } 
	    connect {}
	}
}

set ::halo 1

# POWER or GROUND #Std. cell rails starting with power or ground rails at the bottom of the core area
set ::rails_start_with "POWER" ;

# POWER or GROUND #Upper metal stripes starting with power or ground rails at the left/bottom of the core area
set ::stripes_start_with "POWER" ;

