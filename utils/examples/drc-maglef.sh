#!/bin/bash

export MAGTYPE=maglef ;
export BASE=/home/mk/zooz/ ;
export PDKPATH=$BASE/pdks/ef-skywater-s8/EFS8A ;

magic -dnull -noconsole -rcfile $PDKPATH/libs.tech/magic/current/EFS8A.magicrc <<EOF
gds polygon subcell true
gds warning default
gds read $1.gds
load $1
cellname delete \(UNNAMED\)
writeall force
select top cell
expand
drc on
drc euclidean on
drc check
drc catchup
drc listall 
drc listall why
drc count total
drc count
quit -noprompt
EOF
