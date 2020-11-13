
lef read /home/xrex/usr/devel/pdks/sky130A/libs.ref/sky130_fd_sc_hvl/techlef/sky130_fd_sc_hvl.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /project/openlane/simple_por/runs/simple_por/results/routing/simple_por.def
load simple_por -dereference
cd /project/openlane/simple_por/runs/simple_por/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice simple_por.ext
feedback save /project/openlane/simple_por/runs/simple_por/logs/magic/magic_ext2spice.feedback.txt
# exec cp simple_por.spice /project/openlane/simple_por/runs/simple_por/results/magic/simple_por.spice

