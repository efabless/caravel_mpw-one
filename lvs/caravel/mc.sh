#!/bin/sh
#
export MAGIC=/ef/apps/ocd/magic/8.3.179-202106141345/bin/magic
#export MAGIC=/ef/apps/ocd/magic/8.3.165-202105171922/bin/magic
export PROJECT_ROOT=$DESIGNS/caravel.mpw-one-final-metal-fix
export DESIGN_NAME=$1

export MAGTYPE=maglef

$MAGIC -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc ./mc.tcl
