#!/bin/bash

export PDKPATH=/home/mk/zooz/pdks/ef-skywater-s8/EFS8A
export MAGTYPE=mag 

padring \
-L $PDKPATH/libs.ref/lef/s8iom0s8/s8iom0s8.lef \
-L $PDKPATH/libs.ref/lef/s8iom0s8/power_pads_lib.lef \
--def padframe.def padframe.cfg 

magic -rcfile $PDKPATH/libs.tech/magic/current/EFS8A.magicrc -noc -dnull <<EOF
def read padframe.def
save padframe
select top cell
lef write padframe.lef
gds write padframe.gds
exit
EOF





