set PROJECT_ROOT ~/foss/designs/caravel.mpw-one-final-metal-fix 

addpath ${PDKPATH}/libs.ref/sky130_ml_xx_hd/mag
addpath $PROJECT_ROOT/mag/hexdigits
addpath $PROJECT_ROOT/mag/
 
drc off
crashbackups stop

#load $PROJECT_ROOT/mag/${1} -dereference
load $::env(DESIGN_NAME) -dereference

