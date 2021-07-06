v {xschem version=2.9.9 file_version=1.2 

* Copyright 2020 Stefan Frederik Schippers
* 
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.

}
G {}
K {}
V {}
S {}
E {}
P 4 7 750 -280 750 -240 740 -240 750 -220 760 -240 750 -240 750 -280 {fill=true}
T {$ set SKYWATER_STDCELLS /home/schippes/projects/foundry/skywater-pdk/libraries/sky130_fd_sc_hd/latest} 20 -920 0 0 0.5 0.5 {layer=6 font=Monospace}
T {This code block invokes "sky130_models" procedure 
that returns the .include lines needed to
simulate the standard cells} 590 -390 0 0 0.6 0.6 {layer=8 slant=italic}
T {For this example to work you need to set TCL variable 
SKYWATER_STDCELLS in xschemrc to point to the desired
standard cells library, example: } 20 -1070 0 0 0.6 0.6 {layer=8 slant=italic}
T {Next the xschemrc file includes a "sky130_models.tcl" script that wil be executed
during netlist and returning the .include lines needed for the spice netlists
of  the *used* standard cells in this circuit and all its subcircuits.} 20 -860 0 0 0.6 0.6 {layer=8 slant=italic}
T {Ctrl-Click
to open link} 1050 -290 0 0 0.3 0.3 {layer=11}
N 60 -310 60 -290 { lab=A}
N 60 -200 60 -180 { lab=B}
N 380 -260 480 -260 { lab=X}
N 60 -450 60 -430 { lab=CLK}
N 60 -570 60 -550 { lab=RESET_B}
N 410 -600 450 -600 { lab=Y}
N 860 -630 880 -630 { lab=Qlatch}
N 780 -610 790 -610 { lab=#net1}
N 1180 -580 1200 -580 { lab=#net2}
N 1180 -640 1180 -580 { lab=#net2}
N 1150 -640 1180 -640 { lab=#net2}
N 410 -700 410 -600 { lab=Y}
N 1310 -600 1360 -600 { lab=#net3}
N 1320 -560 1360 -560 { lab=#net4}
N 1360 -520 1360 -500 { lab=Q}
N 350 -600 410 -600 { lab=Y}
N 450 -500 1360 -500 { lab=Q}
N 1350 -480 1350 -430 { lab=RESET_B}
N 1350 -480 1360 -480 { lab=RESET_B}
N 860 -540 1200 -540 { lab=Qlatch}
N 860 -630 860 -540 { lab=Qlatch}
N 1520 -540 1570 -540 { lab=XSCHEM}
N 270 -430 1350 -430 { lab=RESET_B}
N 270 -460 270 -430 { lab=RESET_B}
N 980 -700 980 -660 { lab=Y}
N 980 -660 1030 -660 { lab=Y}
N 780 -630 860 -630 { lab=Qlatch}
N 410 -700 980 -700 { lab=Y}
N 980 -700 1150 -700 { lab=Y}
N 1310 -700 1310 -600 { lab=#net3}
N 1230 -700 1310 -700 { lab=#net3}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/code.sym} 540 -190 0 0 {name=STIMULI 
only_toplevel=true
value=" 
.temp 25
vvcc vcc 0 dc 1.8
vvss vss 0 0
.control
tran 30p 80n
plot a b+2 clk+4 reset_b+6 x+8 y+10 q+12 qlatch+14
.endc
"}
C {devices/lab_pin.sym} 260 -280 0 0 {name=p1 lab=A}
C {devices/lab_pin.sym} 260 -240 0 0 {name=p2 lab=B}
C {devices/lab_pin.sym} 480 -260 0 1 {name=p3 lab=X}
C {sky130_stdcells/nand2_1.sym} 320 -260 0 0 {name=x1 VGND=VSS VNB=VSS VPB=VCC VPWR=VCC prefix=sky130_fd_sc_hd__ }
C {devices/sqwsource.sym} 60 -260 0 0 {name=V1 vhi=1.8 freq=0.09e9}
C {devices/sqwsource.sym} 60 -150 0 0 {name=V2 vhi=1.8 freq=0.02e9}
C {devices/lab_pin.sym} 60 -120 0 0 {name=p4 lab=0}
C {devices/lab_pin.sym} 60 -230 0 0 {name=p5 lab=0}
C {devices/lab_pin.sym} 60 -310 0 1 {name=p6 lab=A}
C {devices/lab_pin.sym} 60 -200 0 1 {name=p7 lab=B}
C {devices/parax_cap.sym} 420 -250 0 0 {name=C1 gnd=0 value=3f m=1}
C {sky130_stdcells/dfrtp_1.sym} 360 -480 0 0 {name=x2 VGND=VSS VNB=VSS VPB=VCC VPWR=VCC prefix=sky130_fd_sc_hd__ 
}
C {devices/sqwsource.sym} 60 -400 0 0 {name=V3 vhi=1.8 freq=0.2e9}
C {devices/lab_pin.sym} 60 -370 0 0 {name=p8 lab=0}
C {devices/lab_pin.sym} 60 -450 0 1 {name=p9 lab=CLK}
C {devices/lab_pin.sym} 270 -500 0 0 {name=p10 lab=CLK}
C {devices/lab_pin.sym} 270 -480 0 0 {name=p11 lab=A}
C {devices/sqwsource.sym} 60 -520 0 0 {name=V4 vhi=1.8 freq=0.7e8}
C {devices/lab_pin.sym} 60 -490 0 0 {name=p12 lab=0}
C {devices/lab_pin.sym} 60 -570 0 1 {name=p13 lab=RESET_B}
C {devices/lab_pin.sym} 270 -460 0 0 {name=p14 lab=RESET_B}
C {devices/lab_wire.sym} 550 -500 0 1 {name=l15 lab=Q}
C {devices/parax_cap.sym} 490 -490 0 0 {name=C2 gnd=0 value=3f m=1}
C {devices/code.sym} 690 -190 0 0 {name=STDCELL_MODELS 
only_toplevel=true
place=end
format="tcleval(@value )"
value="[sky130_models]"
}
C {devices/lab_pin.sym} 230 -620 0 0 {name=p16 lab=A}
C {devices/lab_pin.sym} 230 -580 0 0 {name=p17 lab=B}
C {devices/lab_pin.sym} 450 -600 0 1 {name=p18 lab=Y}
C {devices/parax_cap.sym} 390 -590 0 0 {name=C3 gnd=0 value=3f m=1}
C {sky130_stdcells/nor2b_1.sym} 290 -600 0 0 {name=x3 VGND=VSS VNB=VSS VPB=VCC VPWR=VCC prefix=sky130_fd_sc_hd__ }
C {devices/launcher.sym} 1130 -240 0 0 {name=h2
descr="sky130_models.tcl"
tclcommand="eval exec $editor scripts/sky130_models.tcl"
}
C {devices/code.sym} 860 -190 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include \\\\$::SKYWATER_MODELS\\\\/cells/nfet_01v8/sky130_fd_pr__nfet_01v8__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/nfet_01v8_lvt/sky130_fd_pr__nfet_01v8_lvt__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/pfet_01v8/sky130_fd_pr__pfet_01v8__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/nfet_03v3_nvt/sky130_fd_pr__nfet_03v3_nvt__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/nfet_05v0_nvt/sky130_fd_pr__nfet_05v0_nvt__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/esd_nfet_01v8/sky130_fd_pr__esd_nfet_01v8__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/pfet_01v8_lvt/sky130_fd_pr__pfet_01v8_lvt__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/pfet_01v8_hvt/sky130_fd_pr__pfet_01v8_hvt__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/esd_pfet_g5v0d10v5/sky130_fd_pr__esd_pfet_g5v0d10v5__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/pfet_g5v0d10v5/sky130_fd_pr__pfet_g5v0d10v5__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/pfet_g5v0d16v0/sky130_fd_pr__pfet_g5v0d16v0__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/nfet_g5v0d10v5/sky130_fd_pr__nfet_g5v0d10v5__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/nfet_g5v0d16v0/sky130_fd_pr__nfet_g5v0d16v0__tt_discrete.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/esd_nfet_g5v0d10v5/sky130_fd_pr__esd_nfet_g5v0d10v5__tt.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/models/corners/tt/nonfet.spice
* Mismatch parameters
.include \\\\$::SKYWATER_MODELS\\\\/cells/nfet_01v8/sky130_fd_pr__nfet_01v8__mismatch.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/pfet_01v8/sky130_fd_pr__pfet_01v8__mismatch.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/nfet_01v8_lvt/sky130_fd_pr__nfet_01v8_lvt__mismatch.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/pfet_01v8_lvt/sky130_fd_pr__pfet_01v8_lvt__mismatch.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/pfet_01v8_hvt/sky130_fd_pr__pfet_01v8_hvt__mismatch.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/nfet_g5v0d10v5/sky130_fd_pr__nfet_g5v0d10v5__mismatch.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/pfet_g5v0d10v5/sky130_fd_pr__pfet_g5v0d10v5__mismatch.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/nfet_05v0_nvt/sky130_fd_pr__nfet_05v0_nvt__mismatch.corner.spice
.include \\\\$::SKYWATER_MODELS\\\\/cells/nfet_03v3_nvt/sky130_fd_pr__nfet_03v3_nvt__mismatch.corner.spice
* Resistor\\\\$::SKYWATER_MODELS\\\\/Capacitor
.include \\\\$::SKYWATER_MODELS\\\\/models/r+c/res_typical__cap_typical.spice
.include \\\\$::SKYWATER_MODELS\\\\/models/r+c/res_typical__cap_typical__lin.spice
* Special cells
.include \\\\$::SKYWATER_MODELS\\\\/models/corners/tt/specialized_cells.spice
* All models
.include \\\\$::SKYWATER_MODELS\\\\/models/all.spice
* Corner
.include \\\\$::SKYWATER_MODELS\\\\/models/corners/tt/rf.spice
"}
C {sky130_stdcells/dlrbn_1.sym} 690 -610 0 0 {name=x4 VGND=VSS VNB=VSS VPB=VCC VPWR=VCC prefix=sky130_fd_sc_hd__ }
C {devices/lab_pin.sym} 600 -610 0 0 {name=p19 lab=CLK}
C {devices/lab_pin.sym} 600 -630 0 0 {name=p20 lab=A}
C {devices/lab_pin.sym} 600 -590 0 0 {name=p21 lab=RESET_B}
C {devices/lab_pin.sym} 880 -630 0 1 {name=p22 lab=Qlatch}
C {devices/parax_cap.sym} 820 -620 0 0 {name=C4 gnd=0 value=3f m=1}
C {devices/lab_pin.sym} 1030 -620 0 0 {name=p24 lab=B}
C {sky130_stdcells/nor2b_1.sym} 1090 -640 0 0 {name=x5 VGND=VSS VNB=VSS VPB=VCC VPWR=VCC prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/nand2_1.sym} 1260 -560 0 0 {name=x6 VGND=VSS VNB=VSS VPB=VCC VPWR=VCC prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/a31o_2.sym} 1440 -540 0 0 {name=x7 VGND=VSS VNB=VSS VPB=VCC VPWR=VCC prefix=sky130_fd_sc_hd__ }
C {devices/lab_pin.sym} 1570 -540 0 1 {name=p15 lab=XSCHEM}
C {devices/noconn.sym} 790 -610 2 0 {name=l2}
C {devices/noconn.sym} 1530 -540 3 0 {name=l3}
C {sky130_stdcells/inv_2.sym} 1190 -700 0 0 {name=x8 VGND=VGND VNB=VNB VPB=VPB VPWR=VPWR prefix=sky130_fd_sc_hd__ }
