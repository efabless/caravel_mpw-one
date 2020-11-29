#!/bin/tcsh -f
#-------------------------------------------
# qflow exec script for project ~/gits/caravel/qflow/digital_pll_controller
#-------------------------------------------

# /usr/local/share/qflow/scripts/yosys.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller ~/gits/caravel/qflow/digital_pll_controller/source/digital_pll_controller.v || exit 1
# /usr/local/share/qflow/scripts/graywolf.sh -d ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/opensta.sh  ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/qrouter.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/opensta.sh  -d ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/magic_db.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/magic_drc.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/netgen_lvs.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/magic_gds.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/cleanup.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
/usr/local/share/qflow/scripts/cleanup.sh -p ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/magic_view.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
