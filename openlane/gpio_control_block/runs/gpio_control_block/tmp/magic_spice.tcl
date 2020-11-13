
lef read /home/xrex/usr/devel/pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /project/openlane/gpio_control_block/runs/gpio_control_block/results/routing/gpio_control_block.def
load gpio_control_block -dereference
cd /project/openlane/gpio_control_block/runs/gpio_control_block/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice gpio_control_block.ext
feedback save /project/openlane/gpio_control_block/runs/gpio_control_block/logs/magic/magic_ext2spice.feedback.txt
# exec cp gpio_control_block.spice /project/openlane/gpio_control_block/runs/gpio_control_block/results/magic/gpio_control_block.spice

