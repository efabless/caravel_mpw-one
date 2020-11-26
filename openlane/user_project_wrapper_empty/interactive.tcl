package require openlane
set script_dir [file dirname [file normalize [info script]]]

prep -design $script_dir -tag user_project_wrapper -overwrite
set save_path $script_dir/../..

verilog_elaborate

init_floorplan

place_io_ol

set gap 2.4
add_macro_obs \
	-defFile $::env(CURRENT_DEF) \
	-lefFile $::env(MERGED_LEF_UNPADDED) \
	-obstruction core_obs \
	-placementX $gap \
	-placementY $gap \
	-sizeWidth [expr [lindex $::env(DIE_AREA) 2]-$gap*2] \
	-sizeHeight [expr [lindex $::env(DIE_AREA) 3]-$gap*2] \
	-fixed 1 \
	-layerNames "met1 met2 met3 met4 met5"

set power_domains [list {vccd1 vssd1} {vccd2 vssd2} {vdda1 vssa1} {vdda2 vssa2}]

set ::env(_VDD_NET_NAME) vccd1
set ::env(_GND_NET_NAME) vssd1
set ::env(_V_OFFSET) 14
set ::env(_H_OFFSET) $::env(_V_OFFSET)
set ::env(_V_PITCH) 100
set ::env(_H_PITCH) 100
set ::env(_V_PDN_OFFSET) 0
set ::env(_H_PDN_OFFSET) 0

foreach domain $power_domains {
	set ::env(_VDD_NET_NAME) [lindex $domain 0]
	set ::env(_GND_NET_NAME) [lindex $domain 1]
	gen_pdn

	set ::env(_V_OFFSET) [expr $::env(_V_OFFSET) + 8]
	set ::env(_H_OFFSET) [expr $::env(_H_OFFSET) + 8]
	set ::env(_V_PDN_OFFSET) [expr $::env(_V_PDN_OFFSET)+9.6]
	set ::env(_H_PDN_OFFSET) [expr $::env(_H_PDN_OFFSET)+9.6]
}

run_magic
run_magic_spice_export

save_views       -lef_path $::env(magic_result_file_tag).lef \
                 -def_path $::env(tritonRoute_result_file_tag).def \
                 -gds_path $::env(magic_result_file_tag).gds \
                 -mag_path $::env(magic_result_file_tag).mag \
                 -save_path $save_path \
                 -tag $::env(RUN_TAG)
