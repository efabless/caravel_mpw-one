
lef read /home/xrex/usr/devel/pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /project/openlane/storage/runs/storage/results/routing/storage.def
load storage -dereference
cd /project/openlane/storage/runs/storage/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice storage.ext
feedback save /project/openlane/storage/runs/storage/logs/magic/magic_ext2spice.feedback.txt
# exec cp storage.spice /project/openlane/storage/runs/storage/results/magic/storage.spice

