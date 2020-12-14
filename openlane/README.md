<!---
# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0
-->
# Using OpenLANE to Harden Your Design:

You can utilize the Makefile existing here in this directory to do that.

But, first you need to specify 2 things:
```bash
export PDK_ROOT=<The location where the pdk is installed>
export OPENLANE_ROOT=<the absolute path to the openlane directory cloned or to be cloned>
```

**NOTE:** caravel is still a WIP so expect to run into some issues when using it.

If you don't have openlane already, then you can get it from [here](https://github.com/efabless/openlane). Alternatively, you can clone and build openlane through:
```bash
    make openlane
```

**NOTE:** We are developing caravel using openlane:rc6 which is the current master branch.

**NOTE:** rc6 (current openlane master) and rc4 (previous openlane master) are using two different concepts of cell padding. rc4 is modifying the LEF, while rc6 is relying on openroad to handle the cell padding. Also, rc4 is using the standalone version of openDP while rc6 is using the one integrated in the openroad app. This affects the concept of PL_TARGET_DENSITY and while in rc4 it was preferred to have PL_TARGET_DENSITY=(FP_CORE_UTIL-(5\~10)/100). Now, in rc6 it is preferred to be  PL_TARGET_DENSITY=(FP_CORE_UTIL+(1\~5)/100).
FP_CORE_UTIL should be relaxed as well as it became more representative of the actual core utilization, which wasn't so much the case earlier. So, the perception of these two variables as well as CELL_PAD changed between rc4 and rc6 which necessitates a change in the configurations of almost every single design.
CELL_PAD should be 4~6 for the skywater libraries in rc6 unlike rc4 which was 8.

Then, you have two options:
1. Create a macro for your design and harden it, then insert it into user_project_wrapper.

2. Flatten your design with the user_project_wrapper and harden them as one.


**NOTE:** The OpenLANE documentation should cover everything you might need to create your design. You can find that [here](https://github.com/efabless/openlane/blob/master/README.md).

## Option 1:

This could be done by creating a directory for your design here in this directory, and adding a configuration file for it under the same directory. You can follow the instructions given [here](https://github.com/efabless/openlane#adding-a-design) to generate an initial configuration file for your design, or you can start with the following:

```tcl
set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) <Your Design Name>

set ::env(DESIGN_IS_CORE) 0
set ::env(FP_PDN_CORE_RING) 0
set ::env(GLB_RT_MAXLAYER) 5

set ::env(VERILOG_FILES) "$script_dir/../../verilog/rtl/<Your RTL.v>"

set ::env(CLOCK_PORT) <Clock port name if it exists>
set ::env(CLOCK_PERIOD) <Desired clock period>
```

Then you can add them as you see fit to get the desired DRC/LVS clean outcome.

After that, run the following command:
```bash
make <your design directory name>
```

Then, follow the instructions given in Option 2.

**NOTE:** You might have other macros inside your design. In which case, you may need to have some special power configurations. This is covered [here](https://github.com/efabless/openlane/blob/master/doc/hardening_macros.md#power-grid-pdn).

## Option 2:

1. Add your design to the RTL of the [user_project_wrapper](../verilog/rtl/user_project_wrapper.v).

2. Modify the configuration file [here](./user_project_wrapper/config.tcl) to include any extra files you may need. Make sure to change these accordingly:
```tcl
set ::env(CLOCK_NET) "mprj.clk"

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_proj_example.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/user_proj_example.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/user_proj_example.gds"
```
**NOTE:** Don't change the size or the pin order!

3. If your design has standard cells then you need to modify the configuration file [here](./user_project_wrapper/config.tcl) to remove or change these configs accordingly:
```tcl
# The following is because there are no std cells in the example wrapper project.
set ::env(SYNTH_TOP_LEVEL) 1
set ::env(PL_RANDOM_GLB_PLACEMENT) 1
set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0
set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(TAP_DECAP_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0
```

4. Remove this line `set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg` from the configuration file [here](./user_project_wrapper/config.tcl) entirely if you have no macros. Alternatively, if you do have macros inside your design, then control their placement by modifying [this file](./user_project_wrapper/macro.cfg)

5. Run your design through the flow: `make user_project_wrapper`

6. You may want to take a look at the [Extra Pointers](#extra-pointers) to apply any necessary changes to the interactive script.

7. Re-iterate until you have what you want.

8. Go back to the main [README.md](../README.md) and continue the process of boarding the chip.

**NOTE:** In both cases you might have other macros inside your design. In which case, you may need to have some special power configurations. This is covered [here](https://github.com/efabless/openlane/blob/master/doc/hardening_macros.md#power-grid-pdn).

## Extra Pointers

- The OpenLANE documentation should cover everything you might need to create your design. You can find that [here](https://github.com/efabless/openlane/blob/master/README.md).
- The OpenLANE [FAQs](https://github.com/efabless/openlane/wiki) can guide through your troubles.
- [Here](https://github.com/efabless/openlane/blob/master/configuration/README.md) you can find all the configurations and how to use them.
- [Here](https://github.com/efabless/openlane/blob/master/doc/advanced_readme.md) you can learn how to write an interactive script.
- [Here](https://github.com/efabless/openlane/blob/master/doc/OpenLANE_commands.md) you can find a full documentation for all OpenLANE commands.
- [This documentation](https://github.com/efabless/openlane/blob/master/regression_results/README.md) describes how to use the exploration script to achieve an LVS/DRC clean design.
- [This documentation](https://github.com/efabless/openlane/blob/master/doc/hardening_macros.md) walks you through hardening a macro and all the decisions you should make.
