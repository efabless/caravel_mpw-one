# XSCHEM symbols for the skywater `sky130_fd_sc_hd` high density standard cell library

## *Warning: This is currently Work in progress.*

This directory contains symbols to be used in the [XSCHEM](https://github.com/StefanSchippers/xschem)
schematic editor. For a quick XSCHEM introduction see this
[presentation](https://xschem.sourceforge.io/stefan/xschem_man/tutorial_xschem_slides.html).  
These symbols represent a tentative list of digital logic standard cells to be used to build 
digital circuit schematics in XSCHEM.  
The list is based on the google skywater
[repository](https://foss-eda-tools.googlesource.com/skywater-pdk/libs)
These symbols should bind correctly (same port order, same power pins) with the respective spice netlists
available in the skywater repository.

## GOAL
Provide a set of digital logic gates that can be used with xschem and seamlessly simulated using the 
Skywater 130 PDK simulation SPICE models. Allowing verilog simulation directly from Xschem is another 
goal.

## SYMBOL DRAWINGS
![list of gates](https://github.com/StefanSchippers/xschem_sky130/blob/main/sky130_stdcells/doc/gates.svg)

## CURRENT STATUS

The gates can be placed in a XSCHEM schematic and a valid spice netlist is generated for them. 
you must however include the spice netlists for all the used digital gates.
Below a simple trivial example of a combinatorial gate and a flip-flop simulated with ngspice.


![test sim](https://github.com/StefanSchippers/xschem_sky130/blob/main/sky130_stdcells/doc/test_sim.png)
