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
L 4 110 -160 250 -160 {}
L 4 110 -300 110 -160 {}
L 4 740 -550 1110 -550 {}
L 4 1110 -550 1120 -540 {}
L 4 730 -540 740 -550 {}
P 4 6 110 -430 110 -470 100 -470 110 -490 120 -470 110 -470 {}
P 4 6 250 -160 250 -190 240 -190 250 -210 260 -190 250 -190 {}
P 4 6 560 -380 540 -380 540 -370 520 -380 540 -390 540 -380 {}
T {ngspice_get_value
copy a spice variable as it appears 
in the raw file. You mught replace
the hierarchy path (x1.) with $\{path\}
so annotation works if this circuit
is simulated alone or within a parent
hierarchy} 490 -270 0 0 0.2 0.2 {layer=4}
T {ngspice_get_expr
You can give here a tcl expression
involving multiple spice variables
tcl is very verbose and spice names often
include square brackets (that tcl 
interprets as subcommands) so variables
with such characters must be enclosed
within \{\} braces.} 490 -170 0 0 0.2 0.2 {layer=4}
T {ngspice_probe} 220 -460 0 0 0.2 0.2 {layer=4}
T {ngspice_probe} 250 -630 0 0 0.2 0.2 {layer=4}
T {Annotate launcher works fetching data
from the .raw file of the top most schematic
where presumably simulation has been run.
If this is not the case open this schematic 
as the top level cell (File -> Open) and 
run simulation at *this* level} 760 -300 0 0 0.2 0.2 {layer=4}
T {This will display the raw file of the top
most schematic where presumably simulation
has been run} 760 -160 0 0 0.2 0.2 {layer=4}
T {These values will be
displayed only when
simulating this circuit
as the top level, other-
wise these nodes are 
available at the parent
level since these are
input ports.} 40 -410 0 0 0.2 0.2 {layer=4}
T {using the $\{path\} in the node
attribute ensures 
correct data is imported for any
instance of this schematic at any
hierarchy level} 570 -400 0 0 0.2 0.2 {layer=4}
T {This schematic contains annotators, ngspice_probe,
ngspice_get_value and ngspice_get_expr.
By using the $\{path\} expression instead of the
hierarchy path of this circuit you ensure 
multiple instances (even at different hierarchy
levels) will display each their own data.} 600 -750 0 0 0.4 0.4 {}
T {only_toplevel=true attribute set, 
will be netlisted only if toplevel cell} 830 -580 0 0 0.2 0.2 {layer=4}
N 180 -590 180 -530 { lab=#net1}
N 470 -580 470 -530 { lab=OUT}
N 470 -720 470 -680 { lab=VDD}
N 180 -720 470 -720 { lab=VDD}
N 180 -720 180 -680 { lab=VDD}
N 180 -470 180 -420 { lab=S}
N 410 -420 470 -420 { lab=S}
N 470 -470 470 -420 { lab=S}
N 240 -650 430 -650 { lab=#net1}
N 240 -650 240 -590 { lab=#net1}
N 180 -590 240 -590 { lab=#net1}
N 100 -500 140 -500 { lab=PLUS}
N 510 -500 550 -500 { lab=MINUS}
N 470 -580 630 -580 { lab=OUT}
N 320 -190 320 -160 { lab=GND}
N 240 -220 280 -220 { lab=NBIAS}
N 410 -420 410 -370 { lab=S}
N 850 -530 850 -500 { lab=PLUS}
N 940 -530 940 -500 { lab=NBIAS}
N 750 -530 750 -500 { lab=MINUS}
N 320 -320 320 -250 { lab=#net2}
N 320 -420 320 -380 { lab=S}
N 220 -650 240 -650 { lab=#net1}
N 180 -620 180 -590 { lab=#net1}
N 470 -620 470 -580 { lab=OUT}
N 320 -420 410 -420 { lab=S}
N 180 -420 320 -420 { lab=S}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/code.sym} 1050 -180 0 0 {name=STIMULI 
only_toplevel=true
place=end
value=".options savecurrents
.control
save @m.xm5.msky130_fd_pr__nfet_01v8[gm]
save all
op
write n_diffamp.raw
.endc
"}
C {devices/code.sym} 1040 -330 0 0 {name=TT_MODELS
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
C {sky130_fd_pr/nfet3_01v8_lvt.sym} 160 -500 0 0 {name=M1
L=0.3
W=2
body=GND
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8_lvt.sym} 490 -500 0 1 {name=M2
L=0.3
W=2
body=GND
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet3_01v8_lvt.sym} 450 -650 0 0 {name=M3
L=0.8
W=4
body=VDD
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet3_01v8_lvt.sym} 200 -650 0 1 {name=M4
L=0.8
W=4
body=VDD
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {devices/gnd.sym} 320 -160 0 0 {name=l2 lab=GND}
C {devices/vdd.sym} 350 -720 0 0 {name=l3 lab=VDD}
C {devices/ipin.sym} 100 -500 0 0 {name=p4 sig_type=std_logic lab=PLUS}
C {devices/ipin.sym} 550 -500 0 1 {name=p1 sig_type=std_logic lab=MINUS}
C {devices/opin.sym} 630 -580 0 0 {name=p2 sig_type=std_logic lab=OUT}
C {sky130_fd_pr/nfet3_01v8.sym} 300 -220 0 0 {name=M5
L=1.2
W=0.7
body=GND
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {devices/ipin.sym} 240 -220 0 0 {name=p3 sig_type=std_logic lab=NBIAS}
C {devices/ngspice_probe.sym} 230 -420 0 0 {name=r2}
C {devices/ngspice_probe.sym} 240 -590 0 0 {name=r1}
C {devices/launcher.sym} 830 -100 0 0 {name=h2
descr="View Raw file" 
tclcommand="textwindow $netlist_dir/[file tail [file rootname [ xschem get schname 0 ] ] ].raw"
}
C {devices/ngspice_get_expr.sym} 470 -130 0 1 {name=r4 node="[format %.4g [expr [ngspice::get_node \{i(@m.$\{path\}xm5.msky130_fd_pr__nfet_01v8[id])\}] * [ngspice::get_voltage s] ] ]"
descr="power [W]"}
C {devices/ngspice_get_value.sym} 470 -190 0 1 {name=r3 node=i(@m.$\{path\}xm5.msky130_fd_pr__nfet_01v8[id])
descr="Id="}
C {devices/launcher.sym} 830 -200 0 0 {name=h1
descr=Annotate 
tclcommand="ngspice::annotate"}
C {devices/ngspice_probe.sym} 250 -220 0 0 {name=r5}
C {devices/ngspice_probe.sym} 110 -500 0 0 {name=r6}
C {devices/ngspice_probe.sym} 530 -500 0 0 {name=r7}
C {devices/lab_pin.sym} 470 -420 0 1 {name=l4 sig_type=std_logic lab=S}
C {devices/ngspice_get_value.sym} 470 -240 0 1 {name=r8 node=@m.$\{path\}xm5.msky130_fd_pr__nfet_01v8[gm]
descr="gm="}
C {sky130_fd_pr/res_xhigh_po_0p35.sym} 410 -340 0 0 {name=R1
W=0.35
L=50
model=res_xhigh_po_0p35
spiceprefix=X
mult=1}
C {devices/gnd.sym} 410 -310 0 0 {name=l18 lab=GND}
C {devices/gnd.sym} 390 -340 0 1 {name=l19 lab=GND}
C {devices/ngspice_get_value.sym} 450 -360 0 0 {name=r9 node=i(@b.$\{path\}xr1.xsky130_fd_pr__res_xhigh_po_0p35.brbody[i])
descr="I="}
C {devices/vsource.sym} 850 -470 0 0 {name=V1 value=0.7 only_toplevel=true}
C {devices/gnd.sym} 850 -440 0 0 {name=l9 lab=GND}
C {devices/lab_pin.sym} 850 -530 0 1 {name=l10 sig_type=std_logic lab=PLUS}
C {devices/vsource.sym} 940 -470 0 0 {name=V2 value=0.9 only_toplevel=true}
C {devices/gnd.sym} 940 -440 0 0 {name=l11 lab=GND}
C {devices/lab_pin.sym} 940 -530 0 1 {name=l12 sig_type=std_logic lab=NBIAS}
C {devices/vsource.sym} 1090 -470 0 0 {name=V3 value=1.8 only_toplevel=true}
C {devices/gnd.sym} 1090 -440 0 0 {name=l13 lab=GND}
C {devices/vdd.sym} 1090 -500 0 0 {name=l14 lab=VDD}
C {devices/vsource.sym} 750 -470 0 0 {name=V4 value=0.7 only_toplevel=true}
C {devices/gnd.sym} 750 -440 0 0 {name=l5 lab=GND}
C {devices/lab_pin.sym} 750 -530 0 1 {name=l6 sig_type=std_logic lab=MINUS}
C {devices/ngspice_get_expr.sym} 1070 -470 0 1 {name=r10 node="[ngspice::get_current v3]"}
C {devices/ngspice_get_expr.sym} 290 -340 0 1 {name=r11 node="[ngspice::get_current V5]"}
C {devices/vsource.sym} 320 -350 0 0 {name=V5 value=0}
