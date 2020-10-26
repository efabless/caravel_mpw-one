package require openlane
set script_dir [file dirname [file normalize [info script]]]

prep -design $script_dir -tag chip_io -overwrite
set save_path $script_dir/../..

verilog_elaborate

init_floorplan

exec -ignorestderr python3 $::env(SCRIPTS_DIR)/padringer.py\
	--def-netlist $::env(CURRENT_DEF)\
	--design $::env(DESIGN_NAME)\
	--lefs $::env(TECH_LEF) {*}$::env(GPIO_PADS_LEF)\
	-cfg $script_dir/padframe.cfg\
	--working-dir $::env(TMP_DIR)\
	-o $::env(RESULTS_DIR)/floorplan/padframe.def

set_def $::env(RESULTS_DIR)/floorplan/padframe.def


label_macro_pins\
	-lef $::env(MERGED_LEF_UNPADDED)\
	-netlist_def $::env(CURRENT_DEF)\
	-pad_pin_name "PAD"\
	-extra_args {-v\
	--map mgmt_vdda_hvclamp_pad VDDA vdda INOUT\
	--map user1_vdda_hvclamp_pad\\\[0\\] VDDA vdda1 INOUT\
	--map user2_vdda_hvclamp_pad VDDA vdda2 INOUT\
	--map mgmt_vssa_hvclamp_pad VSSA vssa INOUT\
	--map user1_vssa_hvclamp_pad\\\[0\\] VSSA vssa1 INOUT\
	--map user2_vssa_hvclamp_pad VSSA vssa2 INOUT\
	--map mgmt_vccd_lvclamp_pad VCCD vccd INOUT\
	--map user1_vccd_lvclamp_pad VCCD vccd1 INOUT\
	--map user2_vccd_lvclamp_pad VCCD vccd2 INOUT\
	--map mgmt_vssd_lvclmap_pad VSSD vssd INOUT\
	--map user1_vssd_lvclmap_pad VSSD vssd1 INOUT\
	--map user2_vssd_lvclmap_pad VSSD vssd2 INOUT\
	--map mgmt_vddio_hvclamp_pad\\\[0\\] VDDIO vddio INOUT\
	--map mgmt_vssio_hvclamp_pad\\\[0\\] VSSIO vssio INOUT}

run_magic

run_magic_drc

save_views       -lef_path $::env(magic_result_file_tag).lef \
                 -def_path $::env(CURRENT_DEF) \
                 -gds_path $::env(magic_result_file_tag).gds \
                 -mag_path $::env(magic_result_file_tag).mag \
                 -save_path $save_path \
                 -tag $::env(RUN_TAG)


run_magic_spice_export
run_lvs
