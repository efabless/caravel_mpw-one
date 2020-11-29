
lef read /home/aag/current_pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /project/openlane/DFFRAM/runs/DFFRAM/results/routing/DFFRAM.def
load DFFRAM -dereference
cd /project/openlane/DFFRAM/runs/DFFRAM/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice DFFRAM.ext
feedback save /project/openlane/DFFRAM/runs/DFFRAM/logs/magic/magic_ext2spice.feedback.txt
# exec cp DFFRAM.spice /project/openlane/DFFRAM/runs/DFFRAM/results/magic/DFFRAM.spice

