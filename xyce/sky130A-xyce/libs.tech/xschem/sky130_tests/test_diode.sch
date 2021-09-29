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
T {Available models:
sky130_fd_pr__diode_pw2nd_05v5
sky130_fd_pr__diode_pw2nd_11v0
sky130_fd_pr__diode_pw2nd_05v5_nvt
sky130_fd_pr__diode_pw2nd_05v5_lvt
sky130_fd_pr__diode_pd2nw_05v5
sky130_fd_pr__diode_pd2nw_11v0
sky130_fd_pr__diode_pd2nw_05v5_hvt
sky130_fd_pr__diode_pd2nw_05v5_lvt
sky130_fd_pr__model__parasitic__rf_diode_ps2nw
sky130_fd_pr__model__parasitic__rf_diode_pw2dn
sky130_fd_pr__model__parasitic__diode_pw2dn
sky130_fd_pr__model__parasitic__diode_ps2dn
sky130_fd_pr__model__parasitic__diode_ps2nw} 500 -360 0 0 0.2 0.2 {}
T {Available_models:
sky130_fd_pr__diode_pw2nd_05v5
sky130_fd_pr__diode_pw2nd_11v0
sky130_fd_pr__diode_pd2nw_05v5
sky130_fd_pr__diode_pd2nw_11v0
sky130_fd_pr__model__parasitic__diode_ps2dn} 950 -280 0 0 0.2 0.2 {}
N 460 -390 460 -360 { lab=0}
N 460 -240 460 -170 { lab=K1}
N 460 -110 460 -80 { lab=0}
N 900 -390 900 -360 { lab=0}
N 900 -240 900 -170 { lab=K2}
N 900 -110 900 -80 { lab=0}
C {devices/code_shown.sym} 30 -530 0 0 {name=NGSPICE
only_toplevel=true
value="
.control
dc i1 0 50u 0.1u 
plot k1 k2

.endc
" }
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/lab_pin.sym} 460 -200 0 0 {name=p4 lab=K1}
C {devices/isource.sym} 460 -330 2 0 {name=I1 value=0}
C {devices/lab_pin.sym} 460 -390 0 0 {name=p1 lab=0}
C {devices/ammeter.sym} 460 -270 0 0 {name=Vk1 net_name=true}
C {sky130_fd_pr/diode.sym} 460 -140 0 0 {name=D1
model=diode_pw2nd_05v5
area=1

}
C {devices/lab_pin.sym} 460 -80 0 0 {name=p2 lab=0}
C {devices/lab_pin.sym} 900 -200 0 0 {name=p3 lab=K2}
C {devices/lab_pin.sym} 900 -390 0 0 {name=p5 lab=0}
C {devices/ammeter.sym} 900 -270 0 0 {name=Vk2 net_name=true}
C {sky130_fd_pr/lvsdiode.sym} 900 -140 0 0 {name=D2
model=diode_pw2nd_11v0
area=1

}
C {devices/lab_pin.sym} 900 -80 0 0 {name=p6 lab=0}
C {devices/cccs.sym} 900 -330 0 0 {name=F1 vnam=vk1 value=1}
C {devices/code.sym} 10 -180 0 0 {name=TT_MODELS
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
