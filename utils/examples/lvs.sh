#!/bin/sh
/ef/apps/bin/netgen -noconsole << EOF
readnet spice $1.spice
readnet spice $1.sp
lvs {$1.spice sram_2_16_sky130} {sram_2_16_sky130.sp sram_2_16_sky130} setup.tcl sram_2_16_sky130.lvs.report
quit
EOF
