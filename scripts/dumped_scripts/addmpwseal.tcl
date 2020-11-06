drc off
gds readonly true
gds read ../gds/sram_1rw1r_32_256_8_sky130_lp1.gds
load openram_tc_1kb.mag
select top cell
move origin -1015um -1272.5um
box position 0 0
getcell advSeal_6um_gen
save
gds write ../gds/openram_tc_1kb.gds

