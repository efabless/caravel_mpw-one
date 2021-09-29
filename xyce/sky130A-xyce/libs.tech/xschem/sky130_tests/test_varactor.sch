v {xschem version=2.9.8 file_version=1.2

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
N 550 -430 550 -400 { lab=0}
N 550 -280 550 -210 { lab=G}
N 550 -150 550 -120 { lab=0}
N 700 -210 700 -190 { lab=REF}
N 700 -280 700 -270 { lab=G}
N 550 -280 700 -280 { lab=G}
N 860 -430 860 -400 { lab=0}
N 860 -280 860 -230 { lab=G1}
N 830 -100 830 -70 { lab=0}
N 1010 -210 1010 -190 { lab=REF}
N 1010 -280 1010 -270 { lab=G1}
N 860 -280 1010 -280 { lab=G1}
N 860 -340 860 -280 { lab=G1}
N 550 -340 550 -280 { lab=G}
N 830 -190 830 -100 { lab=0}
N 830 -100 890 -100 { lab=0}
N 890 -190 890 -100 { lab=0}
N 860 -190 860 -100 { lab=0}
N 1150 -430 1150 -400 { lab=0}
N 1150 -280 1150 -210 { lab=G2}
N 1150 -150 1150 -120 { lab=0}
N 1300 -210 1300 -190 { lab=REF}
N 1300 -280 1300 -270 { lab=G2}
N 1150 -280 1300 -280 { lab=G2}
N 1150 -340 1150 -280 { lab=G2}
N 420 -410 420 -390 { lab=REF}
N 1480 -430 1480 -400 { lab=0}
N 1480 -280 1480 -210 { lab=G3}
N 1480 -150 1480 -120 { lab=0}
N 1630 -210 1630 -190 { lab=REF}
N 1630 -280 1630 -270 { lab=G3}
N 1480 -280 1630 -280 { lab=G3}
N 1480 -340 1480 -280 { lab=G3}
C {devices/code_shown.sym} 30 -640 0 0 {name=NGSPICE
only_toplevel=true
value="
.control
tran 10n 9u
plot g g1 g2 g3
plot '100n/deriv(g)' vs v(g) ylimit 0 0.3p
plot '100n/deriv(g1)' vs v(g1) ylimit 0 0.3p
write test_varactor.raw

.endc
" }
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/lab_pin.sym} 550 -240 0 0 {name=p4 lab=G}
C {devices/isource.sym} 550 -370 0 0 {name=I1 value="pwl 0 0 1n 100n"}
C {devices/lab_pin.sym} 550 -430 0 0 {name=p1 lab=0}
C {devices/lab_pin.sym} 550 -120 0 0 {name=p2 lab=0}
C {devices/res.sym} 700 -240 0 0 {name=R1
value=1G
footprint=1206
device=resistor
m=1}
C {devices/lab_pin.sym} 700 -190 0 0 {name=p5 lab=REF}
C {devices/lab_pin.sym} 860 -250 0 0 {name=p6 lab=G1}
C {devices/isource.sym} 860 -370 0 0 {name=I2 value="pwl 0 0 1n 100n"}
C {devices/lab_pin.sym} 860 -430 0 0 {name=p7 lab=0}
C {devices/lab_pin.sym} 830 -70 0 0 {name=p8 lab=0}
C {devices/res.sym} 1010 -240 0 0 {name=R2
value=1G
footprint=1206
device=resistor
m=1}
C {devices/lab_pin.sym} 1010 -190 0 0 {name=p10 lab=REF}
C {devices/lab_pin.sym} 1150 -240 0 0 {name=p9 lab=G2}
C {devices/isource.sym} 1150 -370 0 0 {name=I3 value="pwl 0 0 1n 100n"}
C {devices/lab_pin.sym} 1150 -430 0 0 {name=p11 lab=0}
C {devices/lab_pin.sym} 1150 -120 0 0 {name=p12 lab=0}
C {devices/res.sym} 1300 -240 0 0 {name=R3
value=1G
footprint=1206
device=resistor
m=1}
C {devices/lab_pin.sym} 1300 -190 0 0 {name=p13 lab=REF}
C {devices/capa.sym} 1150 -180 0 0 {name=C1
m=1
value=0.19p
footprint=1206
device="ceramic capacitor"}
C {devices/vsource.sym} 420 -360 0 0 {name=V1 value=-2}
C {devices/lab_pin.sym} 420 -330 0 0 {name=p14 lab=0}
C {devices/lab_pin.sym} 420 -410 0 1 {name=p15 lab=REF}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 860 -210 1 0 {name=M1
L=5
W=5
ad="'W * 0.29'" pd="'2 * (W + 0.29)'"
as="'W * 0.29'" ps="'2 * (W + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
}
C {devices/lab_pin.sym} 1480 -240 0 0 {name=p16 lab=G3}
C {devices/isource.sym} 1480 -370 0 0 {name=I4 value="pwl 0 0 1n 100n"}
C {devices/lab_pin.sym} 1480 -430 0 0 {name=p17 lab=0}
C {devices/lab_pin.sym} 1480 -120 0 0 {name=p18 lab=0}
C {devices/res.sym} 1630 -240 0 0 {name=R4
value=1G
footprint=1206
device=resistor
m=1}
C {devices/lab_pin.sym} 1630 -190 0 0 {name=p19 lab=REF}
C {devices/capa.sym} 1480 -180 0 0 {name=C2
m=1
value="q=\{v(g3) * 0.19p\}"
footprint=1206
device="ceramic capacitor"}
C {sky130_fd_pr/cap_var_lvt.sym} 550 -180 0 0 {name=C4 model=cap_var_lvt W=5 L=5 VM=1 spiceprefix=X}
C {devices/lab_pin.sym} 510 -160 0 0 {name=p20 lab=0}
C {devices/code.sym} 90 -180 0 0 {name=TT_MODELS
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
