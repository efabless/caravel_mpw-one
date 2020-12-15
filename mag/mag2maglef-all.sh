#!/bin/sh
# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0


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

