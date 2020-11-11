# This design fails because it mixes HD and HVL cells
# It will be designed by hand. This is just a placeholder to get things going.
package require openlane
set script_dir [file dirname [file normalize [info script]]]

prep -design $script_dir -tag mgmt_protect -overwrite
set save_path $script_dir/../..

run_synthesis

set exit_code [catch {init_floorplan} error_msg]
if { $exit_code } {
	puts_err "Floorplanning fails, but will generate a blackbox."
	set_def $::env(verilog2def_tmp_file_tag)_openroad.def
}

place_io_ol -cfg $::env(FP_PIN_ORDER_CFG)

run_magic

save_views       -lef_path $::env(magic_result_file_tag).lef \
                 -def_path $::env(CURRENT_DEF) \
                 -gds_path $::env(magic_result_file_tag).gds \
                 -mag_path $::env(magic_result_file_tag).mag \
                 -save_path $save_path \
                 -tag $::env(RUN_TAG)
