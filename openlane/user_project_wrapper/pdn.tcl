# Power nets
set ::power_nets vccd1
set ::ground_nets vssd1

set ::macro_blockage_layer_list "li1 met1 met2 met3 met4 met5"

pdngen::specify_grid stdcell {
    name grid
	core_ring {
		met5 {width 2 spacing 2 core_offset 3}
		met4 {width 2 spacing 2 core_offset 3}
	}
	rails {
	    met1 {width 0.48 pitch $::env(PLACE_SITE_HEIGHT) offset 0}
	}
    straps {
	    met5 {width 1.6 pitch $::env(FP_PDN_HPITCH) offset $::env(FP_PDN_HOFFSET)}
    }
    connect {{met1 met4} {met4 met5}}
}

pdngen::specify_grid macro {
    power_pins "VPWR"
    ground_pins "VGND"
    blockages "li1 met1 met2 met3 met4"
    straps { 
    } 
    connect {{met4_PIN_ver met5}}
}


set ::halo 0

# Metal layer for rails on every row
set ::rails_mlayer "met1" ;

# POWER or GROUND #Std. cell rails starting with power or ground rails at the bottom of the core area
set ::rails_start_with "POWER" ;

# POWER or GROUND #Upper metal stripes starting with power or ground rails at the left/bottom of the core area
set ::stripes_start_with "POWER" ;

