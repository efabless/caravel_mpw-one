#!/bin/sh
export MAGIC=/ef/apps/ocd/magic/8.3.179-202106141345/bin/magic
export NETGEN=/ef/apps/ocd/netgen/1.5.190-202106241453/bin/netgen

export PDKPATH=$PDK_ROOT/sky130A ; 
export PROJECT_ROOT=../..
export CELL=caravel


##cd ../../mag

MAGTYPE=maglef $MAGIC -dnull -noconsole -rcfile $PDKPATH/libs.tech/magic/sky130A.magicrc  <<EOF


#########


path search [concat "$PROJECT_ROOT/$MAGTYPE" [path search]]
addpath ${PDKPATH}/libs.ref/sky130_ml_xx_hd/mag
addpath $PROJECT_ROOT/mag/hexdigits

###addpath ../mag/

#########

echo $CELL;
echo $PROJECT_ROOT;


drc off;
load $PROJECT_ROOT/mag/$CELL.mag -dereference;

#set cname chip_io 					; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname
#set cname mgmt_protect 					; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname
#set cname sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped 	; cellname list filepath $cname $PROJECT_ROOT/mag ; flush $cname

cellname list filepath chip_io $PROJECT_ROOT/mag ; flush chip_io
cellname list filepath mgmt_protect $PROJECT_ROOT/mag ; flush mgmt_protect
cellname list filepath sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped $PROJECT_ROOT/mag ; flush sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped

select top cell
expand

#########

extract do local
extract all			    
feedback save $CELL.ext.tcl
ext2spice lvs			    
ext2spice -o $CELL.maglef.spice

#########

quit -noprompt
EOF



#\rm ../mag*/*.ext*
#\mv ${1%.mag}.maglef.lay.spice ../lvs/${1%.mag}/${1%.mag}.spice
#\cp ../lvs/${1%.mag}/${1%.mag}.spice ../spi/lvs/${1%.mag}.spice




$NETGEN -batch lvs "caravel.spice caravel" "../../verilog/gl/caravel.v caravel" \
	sky130A_setup.tcl comp.out
#	|& tee netgen.log

