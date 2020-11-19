drc off
gds readonly true
gds rescale false

# Switch to GDS only (currently magic hangs if all statements are gds read?)
load chip_io -dereference

load gpio_control_block -dereference

load mgmt_protect -dereference

load simple_por -dereference

load digital_pll -dereference
load DFFRAM -dereference
load mgmt_core -dereference

gds read ../gds/sram_1rw1r_32_256_8_sky130_lp1.gds
load storage -dereference

load user_id_programming -dereference

# Your project goes aboard here
gds read ../gds/user_project_wrapper.gds

load caravel -dereference

select top cell

# cif *hier write disable

gds write caravel_out.gds
