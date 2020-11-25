drc off
gds readonly true
gds rescale false

gds read chip_io.gds

gds read gpio_control_block.gds

gds read mgmt_protect.gds

gds read simple_por.gds

gds read digital_pll.gds
gds read DFFRAM.gds
gds read mgmt_core.gds

gds read storage.gds

gds read user_id_programming.gds

# Your project goes aboard here
gds read user_project_wrapper.gds

load ../mag/caravel.mag -dereference
property GDS_FILE ""
property GDS_START ""
property GDS_END ""

save caravel_out

select top cell

# cif *hier write disable

gds write caravel_out.gds
