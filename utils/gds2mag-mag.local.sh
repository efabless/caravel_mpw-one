#!/bin/sh
export PDK_ROOT=~/foss/pdks/open_pdks/sky130;
export MAGTYPE=mag ; 
export PDKPATH=$PDK_ROOT/sky130A ;
export MAGIC=magic


$MAGIC  -dnull -noconsole << EOF
#------------------------------------------------------
drc off
#---------------------------------gds polygon subcell true
gds warning default
gds readonly true
gds rescale false
#---------------------------------tech unlock *
gds read $1
load ${1%.gds}
#---------------------------------readspice ${1%.gds}.sp
cellname delete "(UNNAMED)"
save ${1%.gds}.mag
quit -noprompt
EOF
