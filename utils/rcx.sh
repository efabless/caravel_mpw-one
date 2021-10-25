# RCX Extraction
# ./rcx.sh --input_def spm.def --input_sdc spm.sdc --input_gl spm.v --top_module spm
while [ "$1" != "" ]; do
    case $1 in
        -d | --input_def )
            shift
            input_def=$1
        ;;
        -d | --input_sdc )
            shift
            input_sdc=$1 
        ;;          
        -v | --input_gl )
            shift
            input_gl=$1 
        ;;  
        -t | --top_module )
            shift
            top_module=$1 
        ;;         
        -l | --input_lefs )
            shift
            input_lefs=$1    
        ;;
        * )      
            exit 1
    esac
    shift
done
​
output_directory=$PWD/$top_module
OPENLANE_IMAGE_NAME=efabless/openlane:2021.09.16_03.28.21
​
echo "Running RC Extraction on $input_def"
mkdir -p $output_directory
# merge techlef and standard cell lef files
python3 $OPENLANE_ROOT/scripts/mergeLef.py -i $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/lef/*.lef -o $output_directory/merged.lef
echo "\
    read_liberty $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib;\
    set std_cell_lef $output_directory/merged.lef;\
    if {[catch {read_lef \$std_cell_lef} errmsg]} {\
            puts stderr \$errmsg;\
            exit 1;\
    };\
    if { \"$input_lefs\" eq \"\"} {\
    } else {\
        foreach lef_file [list $input_lefs] {\
            if {[catch {read_lef \$lef_file} errmsg]} {\
                puts stderr \$errmsg;\
                exit 1;\
            }\
        };\
    };\
    if {[catch {read_def -order_wires $input_def} errmsg]} {\
        puts stderr \$errmsg;\
        exit 1;\
    };\
    read_sdc $input_sdc;\
    set_propagated_clock [all_clocks];\
    set rc_values \"mcon 9.249146E-3,via 4.5E-3,via2 3.368786E-3,via3 0.376635E-3,via4 0.00580E-3\";\
    set vias_rc [split \$rc_values ","];\
    foreach via_rc \$vias_rc {\
            set layer_name [lindex \$via_rc 0];\
            set resistance [lindex \$via_rc 1];\
            set_layer_rc -via \$layer_name -resistance \$resistance;\
    };\
    set_wire_rc -signal -layer met2;\
    set_wire_rc -clock -layer met5;\
    define_process_corner -ext_model_index 0 X;\
    extract_parasitics -ext_model_file $PDK_ROOT/sky130A/libs.tech/openlane/rcx_rules.info -corner_cnt 1 -max_res 50 -coupling_threshold 0.1 -cc_model 10 -context_depth 5;\
    write_spef $output_directory/$top_module.spef" > $output_directory/or_rcx_$top_module.tcl
## Generate Spef file
docker run -it -v $OPENLANE_ROOT:/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -v $PWD:/project -v $output_directory:$output_directory -e PDK_ROOT=$PDK_ROOT $OPENLANE_IMAGE_NAME \
sh -c " cd /project ;  openroad -exit $output_directory/or_rcx_$top_module.tcl |& tee $output_directory/or_rcx_$top_module.log" 
## Run OpenSTA
echo "\
    set std_cell_lef $output_directory/merged.lef;\
    if {[catch {read_lef \$std_cell_lef} errmsg]} {\
            puts stderr \$errmsg;\
            exit 1;\
    };\
    if { \"$input_lefs\" eq \"\"} {\
    } else {\
    foreach lef_file [list $input_lefs] {\
        if {[catch {read_lef \$lef_file} errmsg]} {\
            puts stderr \$errmsg;\
            exit 1;\
        }\
    };\
    };\
    set_cmd_units -time ns -capacitance pF -current mA -voltage V -resistance kOhm -distance um;\
    read_liberty $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib;\
    read_verilog $input_gl;\
    link_design $top_module;\
    read_spef $output_directory/$top_module.spef;\
    read_sdc -echo $input_sdc;\
    write_sdf $top_module.sdf;\
    report_checks -fields {capacitance slew input_pins nets fanout} -path_delay min_max -group_count 1000;\
    report_check_types -max_slew -max_capacitance -max_fanout -violators;\
    " > $output_directory/or_sta_$top_module.tcl 
​
docker run -it -v $OPENLANE_ROOT:/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -v $PWD:/project -v $output_directory:$output_directory -e PDK_ROOT=$PDK_ROOT $OPENLANE_IMAGE_NAME \
sh -c "cd /project; openroad -exit $output_directory/or_sta_$top_module.tcl |& tee $output_directory/or_sta_$top_module.log" 