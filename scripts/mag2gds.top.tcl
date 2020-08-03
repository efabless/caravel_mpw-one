# assumes an /ef tree or at least a symlink
drc off
gds readonly true
gds rescale false
set ::env(MAGTYPE) mag

gds read ../gds/sram_1rw1r_32_256_8_sky130.gds

load striVe2_soc -dereference
load striVe_spi -dereference
load striVe_clkrst -dereference
load digital_pll -dereference
load lvlshiftdown -dereference
load striVe2 -dereference

move origin -1209um -1452um
box position 0 0
getcell advSeal_6um_gen

select top cell

cif *hier write disable

gds write striVe2.gds
