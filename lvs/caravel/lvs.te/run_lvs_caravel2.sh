#!/bin/sh
#
export MAGIC=/ef/apps/ocd/magic/8.3.179-202106141345/bin/magic
#export MAGIC=/ef/apps/ocd/magic/8.3.165-202105171922/bin/magic
export MAGTYPE=mag; 
export PROJECT_ROOT=$DESIGNS/caravel.mpw-one-final-metal-fix

$MAGIC -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc  <<EOF

set PROJECT_ROOT ~/foss/designs/caravel.mpw-one-final-metal-fix 

addpath ${PDKPATH}/libs.ref/sky130_ml_xx_hd/mag
addpath $PROJECT_ROOT/mag/hexdigits
addpath $PROJECT_ROOT/mag/
 
drc off
crashbackups stop

set MAGTYPE maglef
load $PROJECT_ROOT/mag/caravel.mag -dereference

set cname mgmt_protect 					; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname 
set cname mgmt_protect_hv 				; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname 
set cname mproj_logic_high 				; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname 
set cname mproj2_logic_high 				; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname 
set cname sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped	; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname 
set cname simple_por					; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname
set cname gpio_control_block 				; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname
set cname chip_io 					; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname

#set cname storage 					; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname
#set cname DFFRAM 					; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname
#set cname digital_pll 					; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname
#set cname mgmt_core 					; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname
#set cname user_id_programming				; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname
#set sram_1rw1r_32_256_8_sky130				; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname

select top cell
expand
extract do local
extract all
ext2spice lvs
ext2spice -o caravel.mixed-abstraction.lay.spice

EOF
