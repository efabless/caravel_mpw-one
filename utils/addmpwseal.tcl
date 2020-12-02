drc off
gds readonly true
gds rescale false
gds read ../gds/sram_1rw1r_32_256_8_sky130_lp1.gds
load ./caravel.mag
select top cell
move origin -7.165um -7.120um
box position 0 0
getcell advSeal_6um_gen
gds write caravel.mpw.gds
