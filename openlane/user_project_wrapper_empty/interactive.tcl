package require openlane
set script_dir [file dirname [file normalize [info script]]]

prep -design $script_dir -tag user_project_wrapper_empty -overwrite
set save_path $script_dir/../..

verilog_elaborate

init_floorplan

place_io_ol

add_macro_obs \
	-defFile $::env(CURRENT_DEF) \
	-lefFile $::env(MERGED_LEF_UNPADDED) \
	-obstruction core_obs \
	-placementX $::env(FP_IO_HLENGTH) \
	-placementY $::env(FP_IO_VLENGTH) \
	-sizeWidth [expr [lindex $::env(DIE_AREA) 2]-$::env(FP_IO_HLENGTH)*2] \
	-sizeHeight [expr [lindex $::env(DIE_AREA) 3]-$::env(FP_IO_VLENGTH)*2] \
	-fixed 1 \
	-layerNames "met1 met2 met3 met4 met5"

set ::env(_SPACING) 1.6
set ::env(_WIDTH) 3

set power_domains [list {vccd1 vssd1} {vccd2 vssd2} {vdda1 vssa1} {vdda2 vssa2}]

set ::env(_VDD_NET_NAME) vccd1
set ::env(_GND_NET_NAME) vssd1
set ::env(_V_OFFSET) 14
set ::env(_H_OFFSET) $::env(_V_OFFSET)
set ::env(_V_PITCH) 180
set ::env(_H_PITCH) 180
set ::env(_V_PDN_OFFSET) 0
set ::env(_H_PDN_OFFSET) 0

foreach domain $power_domains {
	set ::env(_VDD_NET_NAME) [lindex $domain 0]
	set ::env(_GND_NET_NAME) [lindex $domain 1]
	gen_pdn

	set ::env(_V_OFFSET) \
		[expr $::env(_V_OFFSET) + 2*($::env(_WIDTH)+$::env(_SPACING))]
	set ::env(_H_OFFSET) \
		[expr $::env(_H_OFFSET) + 2*($::env(_WIDTH)+$::env(_SPACING))]
	set ::env(_V_PDN_OFFSET) [expr $::env(_V_PDN_OFFSET)+6*$::env(_WIDTH)]
	set ::env(_H_PDN_OFFSET) [expr $::env(_H_PDN_OFFSET)+6*$::env(_WIDTH)]
}

# making it "empty"
remove_nets -input $::env(CURRENT_DEF)
remove_components -input $::env(CURRENT_DEF)

run_magic

save_views       -lef_path $::env(magic_result_file_tag).lef \
                 -def_path $::env(CURRENT_DEF) \
                 -gds_path $::env(magic_result_file_tag).gds \
                 -mag_path $::env(magic_result_file_tag).mag \
                 -save_path $save_path \
                 -tag $::env(RUN_TAG)

# produce "obstructed" LEF to be used for routing
set gap 0.4
set llx [expr [lindex $::env(DIE_AREA) 0]-$gap]
set lly [expr [lindex $::env(DIE_AREA) 1]-$gap]
set urx [expr [lindex $::env(DIE_AREA) 2]+$gap]
set ury [expr [lindex $::env(DIE_AREA) 3]+$gap]
exec python3 $::env(OPENLANE_ROOT)/scripts/rectify.py $llx $lly $urx $ury \
	< $::env(magic_result_file_tag).lef \
	| python3 $::env(OPENLANE_ROOT)/scripts/obs.py {*}$::env(DIE_AREA) \
	> $::env(magic_result_file_tag).obstructed.lef
file copy $::env(magic_result_file_tag).obstructed.lef $save_path/lef
