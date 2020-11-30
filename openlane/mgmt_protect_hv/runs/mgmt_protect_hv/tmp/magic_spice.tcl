
lef read /home/xrex/usr/devel/pdks/sky130A/libs.ref/sky130_fd_sc_hvl/techlef/sky130_fd_sc_hvl.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /project/openlane/mgmt_protect_hv/runs/mgmt_protect_hv/results/routing/mgmt_protect_hv.def
load mgmt_protect_hv -dereference
cd /project/openlane/mgmt_protect_hv/runs/mgmt_protect_hv/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice mgmt_protect_hv.ext
feedback save /project/openlane/mgmt_protect_hv/runs/mgmt_protect_hv/logs/magic/magic_ext2spice.feedback.txt
# exec cp mgmt_protect_hv.spice /project/openlane/mgmt_protect_hv/runs/mgmt_protect_hv/results/magic/mgmt_protect_hv.spice

