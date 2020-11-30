
lef read /home/xrex/usr/devel/pdks/sky130A/libs.ref/sky130_fd_sc_hvl/techlef/sky130_fd_sc_hvl.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /project/openlane/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped/runs/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped/results/routing/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.def
load sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped -dereference
cd /project/openlane/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped/runs/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.ext
feedback save /project/openlane/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped/runs/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped/logs/magic/magic_ext2spice.feedback.txt
# exec cp sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.spice /project/openlane/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped/runs/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped/results/magic/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.spice

