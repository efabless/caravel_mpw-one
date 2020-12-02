# assumes an /ef tree or at least a symlink
drc off
gds readonly true
gds rescale false
set ::env(MAGTYPE) mag

# gds read <hard macros read as-is.gds>
gds read ../gds/sram_1rw1r_32_256_8_sky130_lp1.gds

load sram_1rw1r_32_256_8_sky130 -dereference
load openram_tc_core -dereference
load openram_tc_1kb -dereference

select top cell

cif *hier write disable

gds write openram_tc_1kb.gds
