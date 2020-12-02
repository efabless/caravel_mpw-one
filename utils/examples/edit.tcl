drc off
puts "Small delay..."
set macro_mags "digital_pll.mag lvlshiftdown.mag striVe2_soc.mag striVe_clkrst.mag striVe_spi.mag"

gds readonly yes
gds rescale no
gds read ../gds/sram_1rw1r_32_256_8_sky130.gds
lef read ../lef/sram.abs.lef
foreach ff $macro_mags { drc off; load $ff -dereference; after 1000; select top cell; property LEFview TRUE }
load striVe2 -dereference
select top cell
