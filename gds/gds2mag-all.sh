#!/bin/sh


gunzip *.gz
mv sram_1rw1r_32_256_8_sky130_lp1.gds sram_1rw1r_32_256_8_sky130.gds

o-gds2mag-mag.sh simple_por.gds 
o-gds2mag-mag.sh gpio_control_block.gds
o-gds2mag-mag.sh digital_pll.gds
o-gds2mag-mag.sh storage.gds
o-gds2mag-mag.sh mgmt_core.gds
o-gds2mag-mag.sh chip_io.gds
o-gds2mag-mag.sh sram_1rw1r_32_256_8_sky130.gds

mv -f *.mag ../mag

gzip -9 storage.gds mgmt_core.gds chip_io.gds


