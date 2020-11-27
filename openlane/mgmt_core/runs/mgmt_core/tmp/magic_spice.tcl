
lef read /home/aag/current_pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /project/openlane/mgmt_core/runs/mgmt_core/results/routing/mgmt_core.def
load mgmt_core -dereference
cd /project/openlane/mgmt_core/runs/mgmt_core/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice mgmt_core.ext
feedback save /project/openlane/mgmt_core/runs/mgmt_core/logs/magic/magic_ext2spice.feedback.txt
# exec cp mgmt_core.spice /project/openlane/mgmt_core/runs/mgmt_core/results/magic/mgmt_core.spice

