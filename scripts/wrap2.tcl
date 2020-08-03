drc off
gds readonly yes
gds rescale no

lef read ../lef/sram.abs.con.lef
load sram_1rw1r_32_256_8_sky130

select top cell
expand
property LEFview ""
property LEFsymmetry ""
property LEFclass ""

box position 5um 5um
getcell pk_sram_1rw1r_32_256_8_sky130

save sram_1rw1r_32_256_8_sky130.mag

gds write output.gds

save
