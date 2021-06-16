#!/bin/sh
export MAGIC=/ef/apps/ocd/magic/8.3.179-202106141345/bin/magic
export MAGTYPE=maglef; 
export PDKPATH=$PDK_ROOT/sky130A ; 

$MAGIC -dnull -noconsole -rcfile $PDKPATH/libs.tech/magic/sky130A.magicrc  <<EOF

#########
drc off
load ${1%.mag} -dereference
select top cell
expand
#########port makeall
#########
######### extract unique 	;# Turns off joinNetsByName - BY DEFAULT IT IS ON
extract style ngspice(sim)	;# styles/extract: ngspice(sim) --> with subckts, ngspice(lvs) --> explicit M for transistors, ngspice(si) <<- DO NOT USE si 
extract do local
#########extract no all
extract all			;# ensures no incremnetal greneration of per cell .ext files
feedback save ${1%.mag}.ext.tcl
#########
ext2spice lvs			;# = all the steps commented below
#########ext2spice hierarchy on		;#
#########ext2spice format ngspice
#########ext2spice scale off		;#
#########ext2spice renumber off		;# renumbers the subcircuit instances
#########ext2spice subcircuit top auto
#########ext2spice cthresh infinite
#########ext2spice rthresh infinite
#########ext2spice blackbox on		;# detects MAGTYPE=maglef files and netlists them as blackbox
#########ext2spice global off
ext2spice -o ${1%.mag}.maglef.lvs.lay.spice
#########
quit -noprompt
EOF
\rm *.ext

# feedback save ${1%.mag}.ext.tcl
# snap int
# source 	${1%.mag}.ext.tcl


