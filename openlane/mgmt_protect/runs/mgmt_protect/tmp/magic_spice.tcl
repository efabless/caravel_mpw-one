
lef read /home/xrex/usr/devel/pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /project/openlane/mgmt_protect/runs/mgmt_protect/results/routing/mgmt_protect.def
load mgmt_protect -dereference
cd /project/openlane/mgmt_protect/runs/mgmt_protect/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice mgmt_protect.ext
feedback save /project/openlane/mgmt_protect/runs/mgmt_protect/logs/magic/magic_ext2spice.feedback.txt
# exec cp mgmt_protect.spice /project/openlane/mgmt_protect/runs/mgmt_protect/results/magic/mgmt_protect.spice

