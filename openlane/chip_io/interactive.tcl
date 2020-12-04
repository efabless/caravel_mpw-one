package require openlane
set script_dir [file dirname [file normalize [info script]]]
set save_path $script_dir/../..

# FOR LVS AND CREATING PORT LABELS
set ::env(USE_GPIO_ROUTING_LEF) 0
prep -design $script_dir -tag chip_io_lvs -overwrite

set ::env(SYNTH_DEFINES) ""
verilog_elaborate
init_floorplan
file copy -force $::env(CURRENT_DEF) $::env(TMP_DIR)/lvs.def
file copy -force $::env(CURRENT_NETLIST) $::env(TMP_DIR)/lvs.v

# ACTUAL CHIP INTEGRATION
set ::env(USE_GPIO_ROUTING_LEF) 1
prep -design $script_dir -tag chip_io -overwrite

file copy $script_dir/runs/chip_io_lvs/tmp/merged_unpadded.lef $::env(TMP_DIR)/lvs.lef
file copy $script_dir/runs/chip_io_lvs/tmp/lvs.def $::env(TMP_DIR)/lvs.def
file copy $script_dir/runs/chip_io_lvs/tmp/lvs.v $::env(TMP_DIR)/lvs.v

set ::env(SYNTH_DEFINES) "TOP_ROUTING"
verilog_elaborate

init_floorplan

puts_info "Generating pad frame"
exec -ignorestderr python3 $::env(SCRIPTS_DIR)/padringer.py\
	--def-netlist $::env(CURRENT_DEF)\
	--design $::env(DESIGN_NAME)\
	--lefs $::env(TECH_LEF) {*}$::env(GPIO_PADS_LEF)\
	-cfg $script_dir/padframe.cfg\
	--working-dir $::env(TMP_DIR)\
	-o $::env(RESULTS_DIR)/floorplan/padframe.def
puts_info "Generated pad frame"

set_def $::env(RESULTS_DIR)/floorplan/padframe.def

# modify to a different file
remove_pins -input $::env(CURRENT_DEF)
remove_empty_nets -input $::env(CURRENT_DEF)

add_macro_obs \
	-defFile $::env(CURRENT_DEF) \
	-lefFile $::env(MERGED_LEF_UNPADDED) \
	-obstruction core_obs \
	-placementX 230 \
	-placementY 240 \
	-sizeWidth 3132 \
	-sizeHeight 4710 \
	-fixed 1 \
	-layerNames "met1 met2 met3 met4 met5"

add_macro_obs \
	-defFile $::env(CURRENT_DEF) \
	-lefFile $::env(MERGED_LEF_UNPADDED) \
	-obstruction gpio_m3_pins \
	-placementX 469.965 \
	-placementY 4972.585 \
	-sizeWidth 1149.480 \
	-sizeHeight 16.200 \
	-fixed 1 \
	-layerNames "met3"

li1_hack_start
global_routing
detailed_routing
li1_hack_end

label_macro_pins\
	-lef $::env(TMP_DIR)/lvs.lef\
	-netlist_def $::env(TMP_DIR)/lvs.def\
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

# run_magic_drc

save_views       -lef_path $::env(magic_result_file_tag).lef \
                 -def_path $::env(CURRENT_DEF) \
                 -gds_path $::env(magic_result_file_tag).gds \
                 -mag_path $::env(magic_result_file_tag).mag \
                 -maglef_path $::env(magic_result_file_tag).lef.mag \
				 -verilog_path $::env(TMP)/lvs.v \
                 -save_path $save_path \
                 -tag $::env(RUN_TAG)

run_magic_spice_export
run_lvs $::env(magic_result_file_tag).spice $::env(TMP_DIR)/lvs.v
