# XSCHEM Device symbols for the Google-Skywater SKY130 Process Design Kit (PDK) 

## *Warning: This is currently Work in progress.*

This directory contains symbols to be used in the [XSCHEM](https://github.com/StefanSchippers/xschem)
schematic editor. For a quick XSCHEM introduction see this 
[presentation](https://xschem.sourceforge.io/stefan/xschem_man/tutorial_xschem_slides.html).<br>
These symbols represent the available silicon devices as documented on the 
[Skywater-pdk](https://skywater-pdk.readthedocs.io/en/latest/rules/device-details.html) website
in the `device details` section.

## GOAL

Provide a set of symbols that can be used to draw circuit schematics in XSCHEM.
Netlists in various target formats can be extracted for simulation or Layout vs Schematic checks.
The set of symbols is designed to correctly link to the Skywater PDK model files, allowing to
seamlessly simulate the circuit with SPICE simulators.
A good tutorial for starting with xschem and Sky130 pdk can be found
[here](https://github.com/bluecmd/learn-sky130/blob/main/schematic/xschem/getting-started.md). Thanks Bluecmd!

## SYMBOL DRAWINGS

Up to now this is the list of devices that have been created. There are a lot of missing devices,
as this is a work in progress and the whole PDK is evolving.

![Devices Drawings](doc/devices.svg)

---

## DEVICE LIST
| File name | Description |
| ----------- | ----------- |
| `diode.sym` |Diode used to describe various p-n junction between p-n wells and p-n diffusions|
| `lvsdiode.sym` |Diodes used for LVS matching ? or for parasitic|
| `nfet_01v8_lvt.sym` |1.8V low threshold N-type Fet|
| `nfet_01v8.sym` | 1.8V standard N-type Fet|
| `nfet_03v3_nvt.sym` |3.3V native threshold N-type Fet |
| `nfet_05v0_nvt.sym` |5V native threshold N-type Fet|
| `nfet_20v0.sym` |20V Vds, 5V Vgs N-type Fet|
| `nfet_20v0_zvt.sym` |20V Vds, 5V Vgs 'Zero threshold' N-type Fet|
| `nfet_20v0_iso.sym` |20V Vds, 5V Vgs N-type Fet in insulated p-well (uses deep nwell)|
| `nfet_20v0_nvt.sym` |20V Vds, 5V Vgs N-type Native Vth Fet in insulated p-well (uses deep nwell)|
| `nfet_g5v0d10v5.sym` |10.5V Vds, 5V Vgs N-type Fet|
| `nfet_g5v0d16v0.sym` |16V Vds, 5V Vgs N-type FET|
| `pfet_01v8_hvt.sym` |1.8V high threshold P-type Fet|
| `pfet_01v8_lvt.sym` |1.8V low threshold P-type Fet|
| `pfet_01v8.sym` |1.8V standard P-type Fet|
| `pfet_20v0.sym` |20V Vds, 5V Vgs P-type Fet|
| `pfet_g5v0d10v5.sym` |10.5V Vds, 5V Vgs P-type Fet|
| `pfet_g5v0d16v0.sym` |16V Vds, 5V Vgs P-type FET |
| `pnp_05v5.sym` |5V Vce PNP bipolar transistor|
| `res_generic_nd.sym` |N diffusion generic resistor|
| `res_generic_pd.sym` |P diffusion generic resistor|
| `res_generic_po.sym` |Generic Poly resistor|
| `res_high_po_0p35.sym` |High precision Poly resistor, 0.35um width|
| `res_high_po_0p69.sym` |High precision Poly resistor, 0.69um width|
| `res_high_po_1p41.sym` |High precision Poly resistor, 1.41um width|
| `res_high_po.sym` |High precision Poly resistor, custom size|
| `res_iso_pw.sym` |P-Well Poly resistor|
| `res_xhigh_po_0p35.sym` |High precision High resistivity Poly resistor, 0.35um width|
| `res_xhigh_po_0p69.sym` |High precision High resistivity Poly resistor, 0.69m width|
| `res_xhigh_po_1p41.sym` |High precision High resistivity Poly resistor, 1.41um width|
| `res_xhigh_po.sym` |High precision High resistivity Poly resistor, custom size|
| `cap_mim_m3_1.sym` |Metal3 Insulator Metal4 (MIM) capacitor|
| `cap_mim_m3_2.sym` |Metal4 Insulator Metal5 (MIM) capacitor|
| `vpp_cap.sym` |Vertical parallel plate metal capacitors|
| `cap_var_lvt.sym` |Variable capacitance (Varactor), LVT version|
| `cap_var_hvt.sym` |Variable capacitance (Varactor), HVT version|
| `vpp_cap.sym`     |Vertical Parallel Plate (VPP) capacitors|

## SYMBOL IMAGES

|   symbol image |   symbol image |   symbol image |   symbol image |
| ----           | ----           | ----           | ----           |
|![cap_mim_m3_1.svg](doc/cap_mim_m3_1.svg)|![nfet_20v0_zvt.svg](doc/nfet_20v0_zvt.svg)|![pfet_20v0.svg](doc/pfet_20v0.svg)|![res_high_po_0p35.svg](doc/res_high_po_0p35.svg)|
|![cap_mim_m3_2.svg](doc/cap_mim_m3_2.svg)|![nfet3_01v8_lvt.svg](doc/nfet3_01v8_lvt.svg)|![pfet3_01v8_hvt.svg](doc/pfet3_01v8_hvt.svg)|![res_high_po_0p69.svg](doc/res_high_po_0p69.svg)|
|![cap_var_hvt.svg](doc/cap_var_hvt.svg)|![nfet3_01v8.svg](doc/nfet3_01v8.svg)|![pfet3_01v8_lvt.svg](doc/pfet3_01v8_lvt.svg)|![res_high_po_1p41.svg](doc/res_high_po_1p41.svg)|
|![cap_var_lvt.svg](doc/cap_var_lvt.svg)|![nfet3_03v3_nvt.svg](doc/nfet3_03v3_nvt.svg)|![pfet3_01v8.svg](doc/pfet3_01v8.svg)|![res_high_po.svg](doc/res_high_po.svg)|
|![diode.svg](doc/diode.svg)|![nfet3_05v0_nvt.svg](doc/nfet3_05v0_nvt.svg)|![pfet3_20v0.svg](doc/pfet3_20v0.svg)|![res_iso_pw.svg](doc/res_iso_pw.svg)|
|![lvsdiode.svg](doc/lvsdiode.svg)|![nfet3_20v0.svg](doc/nfet3_20v0.svg)|![pfet3_g5v0d10v5.svg](doc/pfet3_g5v0d10v5.svg)|![res_xhigh_po_0p35.svg](doc/res_xhigh_po_0p35.svg)|
|![nfet_01v8_lvt.svg](doc/nfet_01v8_lvt.svg)|![nfet3_g5v0d10v5.svg](doc/nfet3_g5v0d10v5.svg)|![pfet3_g5v0d16v0.svg](doc/pfet3_g5v0d16v0.svg)|![res_xhigh_po_0p69.svg](doc/res_xhigh_po_0p69.svg)|
|![nfet_01v8.svg](doc/nfet_01v8.svg)|![nfet3_g5v0d16v0.svg](doc/nfet3_g5v0d16v0.svg)|![pfet_g5v0d10v5.svg](doc/pfet_g5v0d10v5.svg)|![res_xhigh_po_1p41.svg](doc/res_xhigh_po_1p41.svg)|
|![nfet_03v3_nvt.svg](doc/nfet_03v3_nvt.svg)|![nfet_g5v0d10v5.svg](doc/nfet_g5v0d10v5.svg)|![pfet_g5v0d16v0.svg](doc/pfet_g5v0d16v0.svg)|![res_xhigh_po.svg](doc/res_xhigh_po.svg)|
|![nfet_05v0_nvt.svg](doc/nfet_05v0_nvt.svg)|![nfet_g5v0d16v0.svg](doc/nfet_g5v0d16v0.svg)|![pnp_05v5.svg](doc/pnp_05v5.svg)|![vpp_cap.svg](doc/vpp_cap.svg)|
|![nfet_20v0_iso.svg](doc/nfet_20v0_iso.svg)|![pfet_01v8_hvt.svg](doc/pfet_01v8_hvt.svg)|![res_generic_nd.svg](doc/res_generic_nd.svg)|
|![nfet_20v0_nvt.svg](doc/nfet_20v0_nvt.svg)|![pfet_01v8_lvt.svg](doc/pfet_01v8_lvt.svg)|![res_generic_pd.svg](doc/res_generic_pd.svg)|
|![nfet_20v0.svg](doc/nfet_20v0.svg)|![pfet_01v8.svg](doc/pfet_01v8.svg)|![res_generic_po.svg](doc/res_generic_po.svg)|

