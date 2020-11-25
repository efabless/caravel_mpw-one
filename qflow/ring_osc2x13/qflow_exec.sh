#!/bin/tcsh -f
#-------------------------------------------
# qflow exec script for project ~/gits/caravel/qflow/ring_osc2x13
#-------------------------------------------

# /usr/local/share/qflow/scripts/yosys.sh ~/gits/caravel/qflow/ring_osc2x13 ring_osc2x13 ~/gits/caravel/qflow/ring_osc2x13/source/ring_osc2x13.v || exit 1
# /usr/local/share/qflow/scripts/graywolf.sh -d ~/gits/caravel/qflow/ring_osc2x13 ring_osc2x13 || exit 1
# /usr/local/share/qflow/scripts/vesta.sh  ~/gits/caravel/qflow/ring_osc2x13 ring_osc2x13 || exit 1
# /usr/local/share/qflow/scripts/qrouter.sh ~/gits/caravel/qflow/ring_osc2x13 ring_osc2x13 || exit 1
# /usr/local/share/qflow/scripts/vesta.sh  -d ~/gits/caravel/qflow/ring_osc2x13 ring_osc2x13 || exit 1
# /usr/local/share/qflow/scripts/magic_db.sh ~/gits/caravel/qflow/ring_osc2x13 ring_osc2x13 || exit 1
# /usr/local/share/qflow/scripts/magic_drc.sh ~/gits/caravel/qflow/ring_osc2x13 ring_osc2x13 || exit 1
# /usr/local/share/qflow/scripts/netgen_lvs.sh ~/gits/caravel/qflow/ring_osc2x13 ring_osc2x13 || exit 1
# /usr/local/share/qflow/scripts/magic_gds.sh ~/gits/caravel/qflow/ring_osc2x13 ring_osc2x13 || exit 1
# /usr/local/share/qflow/scripts/cleanup.sh ~/gits/caravel/qflow/ring_osc2x13 ring_osc2x13 || exit 1
/usr/local/share/qflow/scripts/cleanup.sh -p ~/gits/caravel/qflow/ring_osc2x13 ring_osc2x13 || exit 1
# /usr/local/share/qflow/scripts/magic_view.sh ~/gits/caravel/qflow/ring_osc2x13 ring_osc2x13 || exit 1
