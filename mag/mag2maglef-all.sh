#!/bin/sh

o-mag2maglef-maglef.sh simple_por
o-mag2maglef-maglef.sh gpio_control_block
o-mag2maglef-maglef.sh digital_pll
o-mag2maglef-maglef.sh storage
o-mag2maglef-maglef.sh mgmt_core
o-mag2maglef-maglef.sh sram_1rw1r_32_256_8_sky130
o-mag2maglef-maglef.sh chip_io



MAGTYPE=maglef magic -rcfile ./dot.magicrc.dist -d XR simple_por.mag
MAGTYPE=mag    magic -rcfile ./dot.magicrc.dist -d XR simple_por.mag

MAGTYPE=maglef magic -rcfile ./dot.magicrc.dist -d XR simple_por.mag
MAGTYPE=mag    magic -rcfile ./dot.magicrc.dist -d XR simple_por.mag


load ./digital_pll.mag ; select top cell ; expand ; drc on ; drc style drc(full) ; drc check ; drc catchup




MAGTYPE=maglef magicDrc -T $PDK_ROOT/sky130A/libs.tech/magic/current/sky130A.tech  -S 'drc(full)' -l  simple_por.drc.out simple_por.mag 

MAGTYPE=maglef magicDrc -T $PDK_ROOT/sky130A/libs.tech/magic/current/sky130A.tech  -S 'drc(full)' -l  caravel..drc.out caravel.mag 



 
MAGTYPE=mag magicDrc -T $PDK_ROOT/sky130A/libs.tech/magic/current/sky130A.tech  -S 'drc(full)' -l  simple_por.drc.out simple_por.mag 

MAGTYPE=mag magicDrc -T $PDK_ROOT/sky130A/libs.tech/magic/current/sky130A.tech  -S 'drc(full)' -l  caravel..drc.out caravel.mag 


MAGTYPE=maglef magicDrc -T $PDK_ROOT/sky130A/libs.tech/magic/current/sky130A.tech  -S 'drc(full)' -l  chip_io.drc.out chip_io.mag 
MAGTYPE=mag magicDrc -T $PDK_ROOT/sky130A/libs.tech/magic/current/sky130A.tech  -S 'drc(full)' -l  chip_io.drc.out chip_io.mag

MAGTYPE=maglef magicDrc -T $PDK_ROOT/sky130A/libs.tech/magic/current/sky130A.tech  -S 'drc(full)' -l  digital_pll.drc.out digital_pll.mag 
MAGTYPE=mag magicDrc -T $PDK_ROOT/sky130A/libs.tech/magic/current/sky130A.tech  -S 'drc(full)' -l  digital_pll.drc.out digital_pll.mag 

MAGTYPE=mag magicDrc -T $PDK_ROOT/sky130A/libs.tech/magic/current/sky130A.tech  -S 'drc(full)' -l  simple_por.drc.out simple_por.mag 
MAGTYPE=maglef magicDrc -T $PDK_ROOT/sky130A/libs.tech/magic/current/sky130A.tech  -S 'drc(full)' -l  simple_por.drc.out simple_por.mag 



cd ~/foss/designs/openflow-drc-tests/torture_tests
git checkout master
git pull
mkdir -p $1
cp -f ~/design/caravel/gds/$1.gds $1
git add  $1/*
git commit -m "DRC check for $1"
git push

