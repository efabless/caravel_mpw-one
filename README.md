# Prerequisites and Installation
In order to edit and simulate the schematics and the layout the following tools need to be installed:
 - [xschem](http://repo.hu/projects/xschem/) - A schematic capture tool that allows to run simulations using ngspice.
 - [ngspice](http://ngspice.sourceforge.net/) - A circuit simulator.
 - [magic](http://opencircuitdesign.com/magic/index.html) - A VLSI layout tool.
 
After cloning this repository and installing the previous mencioned tools, the PDK form SkyWater needs to be installed. In order to do that, run the [install_pdk](install_pdk.sh) script in the repo. This script clones the following repositories:
 - [Google-Skywater 130nm Open Source PDK](https://github.com/google/skywater-pdk)
 - [Open PDK](http://opencircuitdesign.com/open_pdks/) - Standard layout files for the Google-Skywater 130nm Open Source PDK.
 - [Xschem SKY130 PDK Symbols](https://github.com/StefanSchippers/xschem_sky130) - Xschem symbol libraries for the Google-Skywater 130nm Open Source PDK.

# General Purpose Open Source Operational Amplifier (OpAmp)
This project is a test chip, which contains several two stages operationals amplifiers with Miller compensation. This is an all analog desing implemented on the [Google-Skywater 130nm Open Source PDK](https://skywater-pdk.readthedocs.io/en/latest/). It is an Open Source project under[Apache License 2.0] (LICENSE).

The OpAmp desing is located in an Open Source SoC Harness obtained from the [efabless](https://efabless.com/) [Caravel Project](https://github.com/efabless/caravel). 

# OpAmp Desing
## General Specifications:
 - V_{dd}
 - I_{ref}
 - Power Consumption
 - DC Gain 
 - Bandwidth
 - Chip Area
 
# CIIC Harness  

A template SoC for Google SKY130 free shuttles. It is still WIP. The current SoC architecture is given below.

<p align=”center”>
<img src="/doc/ciic_harness.png" width="75%" height="75%"> 
</p>

## Managment SoC
The managment SoC runs firmware that can be used to:
- Configure Mega Project I/O pads
- Observe and control Mega Project signals (through on-chip logic analyzer probes)
- Control the Mega Project power supply

The memory map of the management SoC can be found [here](verilog/rtl/README)

## Mega Project Area
This is the user space. It has limited silicon area (TBD, about 3.1mm x 3.8mm) as well as a fixed number of I/O pads (37) and power pads (10).  See [the Caravel  premliminary datasheet](doc/caravel_datasheet.pdf) for details.
The repository contains a [sample mega project](/verilog/rtl/user_proj_example.v) that contains a binary 32-bit up counter.  </br>

<p align=”center”>
<img src="/doc/counter_32.png" width="50%" height="50%">
</p>

The firmware running on the Management Area SoC, configures the I/O pads used by the counter and uses the logic probes to observe/control the counter. Three firmware examples are provided:
1. Configure the Mega Project I/O pads as o/p. Observe the counter value in the testbench: [IO_Ports Test](verilog/dv/caravel/user_proj_example/io_ports).
2. Configure the Mega Project I/O pads as o/p. Use the Chip LA to load the counter and observe the o/p till it reaches 500: [LA_Test1](verilog/dv/caravel/user_proj_example/la_test1).
3. Configure the Mega Project I/O pads as o/p. Use the Chip LA to control the clock source and reset signals and observe the counter value for five clock cylcles:  [LA_Test2](verilog/dv/caravel/user_proj_example/la_test2).
