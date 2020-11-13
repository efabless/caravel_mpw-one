
lef read /home/xrex/usr/devel/pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /project/openlane/user_id_programming/runs/user_id_programming/results/routing/user_id_programming.def
load user_id_programming -dereference
cd /project/openlane/user_id_programming/runs/user_id_programming/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice user_id_programming.ext
feedback save /project/openlane/user_id_programming/runs/user_id_programming/logs/magic/magic_ext2spice.feedback.txt
# exec cp user_id_programming.spice /project/openlane/user_id_programming/runs/user_id_programming/results/magic/user_id_programming.spice

