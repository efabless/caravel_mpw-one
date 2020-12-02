lef read $::env(PDKPATH)/libs.ref/techLEF/scs8hd/scs8hd_tech.lef
set macro_mags "openram_tc_core.mag"

# lef read ../lef/sram_1rw1r_32_256_8_sky130_lp1.lef

foreach ff $macro_mags { drc off; after 500; load $ff -dereference; select top cell; property LEFview TRUE }

load openram_tc_1kb -dereference

select top cell
extract do local
extract
ext2spice lvs
ext2spice openram_tc_1kb.ext
feedback save extract.tcl.log
exit
