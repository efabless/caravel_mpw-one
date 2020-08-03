lef read /ef/tech/SW/EFS8A/libs.ref/techLEF/scs8hd/scs8hd_tech.lef
set macro_mags "./scs8hd_tapvpwrvgnd_1.mag ./scs8hd_conb_1.mag digital_pll.mag lvlshiftdown.mag striVe2_soc.mag striVe_clkrst.mag striVe_spi.mag"
lef read ../lef/sram.abs.lef
foreach ff $macro_mags { drc off; after 500; load $ff -dereference; select top cell; property LEFview TRUE }

load striVe2 -dereference

select top cell
extract do local
extract
ext2spice lvs
ext2spice striVe2.ext
feedback save warnings.log
exit
