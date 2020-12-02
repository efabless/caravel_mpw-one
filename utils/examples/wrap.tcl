drc off
gds readonly yes
gds rescale no

gds read ../macros/sram/riscv-sky130/sram_1rw1r_32_256_8_sky130.gds
load sram_1rw1r_32_256_8_sky130

select top cell
property LEFview "TRUE"

save pk_sram_1rw1r_32_256_8_sky130.mag

# exec sed -i -E "/^.*GDS_END.*$/d" sram_1rw1r_32_256_8_sky130_original.mag
