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
C {devices/code_shown.sym} 60 -770 0 0 {name=NGSPICE
only_toplevel=true
value="
vp P 0 1.8
vm M 0 0
vb B 0 0
.control
save all
* dc vp 0 3 0.01
dc temp -40 140 1
*plot v(p,m) / vr1#branch
*plot v(p,m) / vr2#branch
*plot v(p,m) / vr3#branch
plot v(p,m) / vr4#branch
plot v(p,m) / vr5#branch
plot v(p,m) / vr6#branch
*plot v(p,m) / vr7#branch
*plot v(p,m) / vr8#branch
plot v(p,m) / vr9#branch
plot v(p,m) / vr10#branch
*plot v(p,m) / vr11#branch
*plot v(p,m) / vr12#branch

.endc
" }
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/lab_pin.sym} 580 -500 0 0 {name=p22 lab=B}
C {sky130_fd_pr/res_iso_pw.sym} 600 -500 0 0 {name=R1
W=2.65
L=2.65
model=res_iso_pw
spiceprefix=X
 mult=1}
C {devices/lab_pin.sym} 600 -470 0 1 {name=p1 lab=M}
C {devices/lab_pin.sym} 600 -590 0 1 {name=p2 lab=P}
C {devices/ammeter.sym} 600 -560 0 0 {name=Vr1}
C {devices/ammeter.sym} 750 -560 0 0 {name=Vr2}
C {devices/lab_pin.sym} 750 -590 0 1 {name=p3 lab=P}
C {devices/lab_pin.sym} 750 -470 0 1 {name=p4 lab=M}
C {devices/lab_pin.sym} 730 -500 0 0 {name=p5 lab=B}
C {sky130_fd_pr/res_generic_nd.sym} 750 -500 0 0 {name=R2
W=1
L=1
model=res_generic_nd
spiceprefix=X
 mult=1}
C {devices/ammeter.sym} 930 -560 0 0 {name=Vr3}
C {devices/lab_pin.sym} 930 -590 0 1 {name=p6 lab=P}
C {devices/lab_pin.sym} 930 -470 0 1 {name=p7 lab=M}
C {devices/lab_pin.sym} 910 -500 0 0 {name=p8 lab=B}
C {sky130_fd_pr/res_generic_pd.sym} 930 -500 0 0 {name=R3
W=1
L=1
model=res_generic_pd
spiceprefix=X
 mult=1}
C {devices/ammeter.sym} 1100 -560 0 0 {name=Vr4}
C {devices/lab_pin.sym} 1100 -590 0 1 {name=p9 lab=P}
C {devices/lab_pin.sym} 1100 -470 0 1 {name=p10 lab=M}
C {sky130_fd_pr/res_generic_po.sym} 1100 -500 0 0 {name=R4
W=1
L=1
model=res_generic_po
spiceprefix=X
spice_ignore=false
 mult=1}
C {devices/ammeter.sym} 600 -370 0 0 {name=Vr5}
C {devices/lab_pin.sym} 600 -400 0 1 {name=p12 lab=P}
C {devices/lab_pin.sym} 600 -280 0 1 {name=p13 lab=M}
C {devices/lab_pin.sym} 580 -310 0 0 {name=p14 lab=B}
C {sky130_fd_pr/res_high_po.sym} 600 -310 0 0 {name=R5
W=1
L=1
model=res_high_po
spiceprefix=X
 mult=1}
C {devices/ammeter.sym} 750 -370 0 0 {name=Vr6}
C {devices/lab_pin.sym} 750 -400 0 1 {name=p15 lab=P}
C {devices/lab_pin.sym} 750 -280 0 1 {name=p16 lab=M}
C {devices/lab_pin.sym} 730 -310 0 0 {name=p17 lab=B}
C {sky130_fd_pr/res_high_po_0p35.sym} 750 -310 0 0 {name=R6
W=0.35
L=1
model=res_high_po_0p35
spiceprefix=X
 mult=1}
C {devices/ammeter.sym} 930 -370 0 0 {name=Vr7}
C {devices/lab_pin.sym} 930 -400 0 1 {name=p18 lab=P}
C {devices/lab_pin.sym} 930 -280 0 1 {name=p19 lab=M}
C {devices/lab_pin.sym} 910 -310 0 0 {name=p20 lab=B}
C {sky130_fd_pr/res_high_po_0p69.sym} 930 -310 0 0 {name=R7
W=0.69
L=0.69
model=res_high_po_0p69
spiceprefix=X
 mult=1}
C {devices/ammeter.sym} 1100 -370 0 0 {name=Vr8}
C {devices/lab_pin.sym} 1100 -400 0 1 {name=p21 lab=P}
C {devices/lab_pin.sym} 1100 -280 0 1 {name=p23 lab=M}
C {devices/lab_pin.sym} 1080 -310 0 0 {name=p24 lab=B}
C {sky130_fd_pr/res_high_po_1p41.sym} 1100 -310 0 0 {name=R8
W=1.41
L=1.41
model=res_high_po_1p41
spiceprefix=X
 mult=1}
C {devices/ammeter.sym} 600 -180 0 0 {name=Vr9}
C {devices/lab_pin.sym} 600 -210 0 1 {name=p25 lab=P}
C {devices/lab_pin.sym} 600 -90 0 1 {name=p26 lab=M}
C {devices/lab_pin.sym} 580 -120 0 0 {name=p27 lab=B}
C {sky130_fd_pr/res_xhigh_po.sym} 600 -120 0 0 {name=R9
W=1
L=1
model=res_xhigh_po
spiceprefix=X
 mult=1}
C {devices/ammeter.sym} 750 -180 0 0 {name=Vr10}
C {devices/lab_pin.sym} 750 -210 0 1 {name=p28 lab=P}
C {devices/lab_pin.sym} 750 -90 0 1 {name=p29 lab=M}
C {devices/lab_pin.sym} 730 -120 0 0 {name=p30 lab=B}
C {sky130_fd_pr/res_xhigh_po_0p35.sym} 750 -120 0 0 {name=R10
W=0.35
L=0.35
model=res_xhigh_po_0p35
spiceprefix=X
 mult=1}
C {devices/ammeter.sym} 930 -180 0 0 {name=Vr11}
C {devices/lab_pin.sym} 930 -210 0 1 {name=p31 lab=P}
C {devices/lab_pin.sym} 930 -90 0 1 {name=p32 lab=M}
C {devices/lab_pin.sym} 910 -120 0 0 {name=p33 lab=B}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 930 -120 0 0 {name=R11
W=0.69
L=0.69
model=res_xhigh_po_0p69
spiceprefix=X
 mult=1}
C {devices/ammeter.sym} 1100 -180 0 0 {name=Vr12}
C {devices/lab_pin.sym} 1100 -210 0 1 {name=p34 lab=P}
C {devices/lab_pin.sym} 1100 -90 0 1 {name=p35 lab=M}
C {devices/lab_pin.sym} 1080 -120 0 0 {name=p36 lab=B}
C {sky130_fd_pr/res_xhigh_po_1p41.sym} 1100 -120 0 0 {name=R12
W=1.41
L=1.41
model=res_xhigh_po_1p41
spiceprefix=X
 mult=1}
C {devices/ipin.sym} 310 -200 0 0 {name=p45 lab=P}
C {devices/ipin.sym} 310 -160 0 0 {name=p46 lab=M}
C {devices/ipin.sym} 310 -120 0 0 {name=p47 lab=B}
C {devices/code.sym} 30 -190 0 0 {name=TT_MODELS
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
