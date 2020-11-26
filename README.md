# Multi Project Harness

* This is a proposal for handling multiple projects in the user project area of the [Caravel harness](https://github.com/efabless/caravel)
* This is a fork of caravel with https://github.com/mattvenn/mpw-multi-project-harness added to /verilog/rtl/
* user_project_wrapper is then adjusted to instantiate https://github.com/mattvenn/mpw-multi-project-harness/blob/main/multi_project_harness.v

# Sub projects

See https://github.com/mattvenn/mpw-multi-project-harness/blob/main/.gitmodules
for the list of currently included projects.

# Preparation

See https://github.com/mattvenn/mpw-multi-project-harness for details on adding new projects.

# Simulation / Verification.

For formal and cocotb simulation of each module see https://github.com/mattvenn/mpw-multi-project-harness

For caravel system simulation see the tests under verilog/dv/caravel/user_proj_example/

# GDS

See https://github.com/mattvenn/mpw-multi-project-harness/blob/main/docs/hardening.md for details on hardening each module into the main macro.
This macro's GDS/LEF is then added to openlane/user_project_wrapper

For configuration sees:

* openlane/user_project_wrapper/config.tcl 
* openlane/user_project_wrapper/interactive.tcl

To generate the final GDS, run this command:

    make user_project_wrapper OPENLANE_IMAGE_NAME=openlane:rc5

# Todo

* when the toolchain is fully working, generate the GDS and add it to the repo
* info.yaml : update user_level_netlist
