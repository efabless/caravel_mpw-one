package require openlane
set script_dir [file dirname [file normalize [info script]]]
prep -design $script_dir -tag caravel -overwrite
set save_path $script_dir/../..

set ::env(SYNTH_DEFINES) "TOP_ROUTING"
verilog_elaborate
#logic_equiv_check -lhs $top_rtl -rhs $::env(yosys_result_file_tag).v

init_floorplan

add_macro_placement padframe 0 0 N
add_macro_placement storage 279.960 219.360 N
add_macro_placement soc 813.755 226.905 N
add_macro_placement mprj 251.520 1279.800 N
add_macro_placement mgmt_buffers 887.200 1158.940 N
add_macro_placement porb_level 778.715 1099.725 N
add_macro_placement rstb_level 826.125 1099.725 N
add_macro_placement user_id_value 778.715 1158.940 N
add_macro_placement por 2903.225 2184.205 N

# west
# gpio_control_blocks: 37 ... 32
set x 38.560
set y 1119.130
set pitch 227
set orient N
for {set i 37} {$i >= 32} {incr i -1} {
	add_macro_placement "gpio_control_in\\\[$i\\\]" $x $y $orient
	set y [expr {$y + $pitch}]
}

# gpio_control_in: 31 ... 25
set y [expr {$y + 2 * $pitch}]
for {set i 31} {$i >= 25} {incr i -1} {
	add_macro_placement "gpio_control_in\\\[$i\\\]" $x $y $orient
	set y [expr {$y + $pitch}]
}

# gpio_control_in: 24
set y [expr {$y + $pitch}]
add_macro_placement "gpio_control_in\\\[24\\\]" $x $y $orient

# east
# gpio_control_bidir: 0 ... 1
set x 3111.080
set y 696.300
set pitch 238
set orient N; # mirror
for {set i 0} {$i <= 1} {incr i} {
	add_macro_placement "gpio_control_bidir\\\[$i\\\]" $x $y $orient
	set y [expr {$y + $pitch}]
}

# gpio_control_in: 2 ... 6
for {set i 2} {$i <= 6} {incr i} {
	add_macro_placement "gpio_control_in\\\[$i\\\]" $x $y $orient
	set y [expr {$y + $pitch}]
}

set y [expr {$y + $pitch}]
# gpio_control_in: 7 ... 13
for {set i 7} {$i <= 13} {incr i} {
	add_macro_placement "gpio_control_in\\\[$i\\\]" $x $y $orient
	set y [expr {$y + $pitch}]
}

# gpio_control_in: 14
set y [expr {$y + 2 * $pitch - 7}]
add_macro_placement "gpio_control_in\\\[14\\\]" $x $y $orient

# north
# gpio_control_in: 23 ... 15
set x 468.460
set y 5207.760
set pitch 241
set orient R270
for {set i 23} {$i >= 15} {incr i -1} {
	add_macro_placement "gpio_control_in\\\[$i\\\]" $x $y $orient
	set x [expr {$x + $pitch}]
}


manual_macro_placement f

run_magic

save_views       -lef_path $::env(magic_result_file_tag).lef \
                 -def_path $::env(tritonRoute_result_file_tag).def \
                 -gds_path $::env(magic_result_file_tag).gds \
                 -mag_path $::env(magic_result_file_tag).mag \
                 -save_path $save_path \
                 -tag $::env(RUN_TAG)
