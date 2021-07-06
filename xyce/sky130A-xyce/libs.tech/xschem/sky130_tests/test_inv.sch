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
T {Simple ring oscillator for
speed testing} 80 -440 0 0 0.6 0.6 {layer=4}
N 690 -280 690 -120 { lab=Z[2]}
N 770 -280 770 -120 { lab=Z[3]}
N 850 -280 850 -120 { lab=Z[4]}
N 930 -280 930 -120 { lab=Z[5]}
N 1010 -280 1010 -120 { lab=Z[6]}
N 1090 -180 1090 -120 { lab=Z[0]}
N 1090 -180 1150 -180 { lab=Z[0]}
N 1150 -180 1150 -70 { lab=Z[0]}
N 490 -70 1150 -70 { lab=Z[0]}
N 490 -180 490 -70 { lab=Z[0]}
N 490 -180 530 -180 { lab=Z[0]}
N 530 -280 530 -180 { lab=Z[0]}
N 540 -290 1090 -290 {bus=true lab=Z[6:0]}
N 690 -540 690 -380 { lab=Y[2]}
N 770 -540 770 -380 { lab=Y[3]}
N 850 -540 850 -380 { lab=Y[4]}
N 930 -540 930 -380 { lab=Y[5]}
N 1010 -540 1010 -380 { lab=Y[6]}
N 1090 -440 1090 -380 { lab=Y[0]}
N 1090 -440 1150 -440 { lab=Y[0]}
N 1150 -440 1150 -330 { lab=Y[0]}
N 490 -330 1150 -330 { lab=Y[0]}
N 490 -440 490 -330 { lab=Y[0]}
N 490 -440 530 -440 { lab=Y[0]}
N 530 -540 530 -440 { lab=Y[0]}
N 540 -550 1090 -550 {bus=true lab=Y[6:0]}
N 610 -280 610 -120 { lab=Z[1]}
N 610 -540 610 -380 { lab=Y[1]}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/code_shown.sym} 0 -700 0 0 {name=NGSPICE
only_toplevel=true
value="
vvss vss 0 dc 0
vvcc vcc 0 pwl 0 0 10n 0 10.1n 1.8 20n 1.8 20.1n 0

.control
.save all
tran 0.01n 30n
plot \\"z[2]\\" \\"z[3]\\" \\"z[4]\\"
plot \\"y[2]\\" \\"y[3]\\" \\"y[4]\\"
write test_inv.raw
.endc
"}
C {devices/parax_cap.sym} 610 -110 0 0 {name=C1 gnd=0 value=4f m=1}
C {devices/parax_cap.sym} 690 -110 0 0 {name=C2 gnd=0 value=4f m=1}
C {devices/parax_cap.sym} 770 -110 0 0 {name=C3 gnd=0 value=4f m=1}
C {devices/parax_cap.sym} 850 -110 0 0 {name=C4 gnd=0 value=4f m=1}
C {devices/parax_cap.sym} 930 -110 0 0 {name=C5 gnd=0 value=4f m=1}
C {devices/parax_cap.sym} 1010 -110 0 0 {name=C6 gnd=0 value=4f m=1}
C {devices/parax_cap.sym} 1090 -110 0 0 {name=C7 gnd=0 value=4.01f m=1}
C {devices/bus_connect.sym} 1020 -290 3 1 {name=l2 lab=Z[6]}
C {devices/bus_connect.sym} 940 -290 3 1 {name=l3 lab=Z[5]}
C {devices/bus_connect.sym} 860 -290 3 1 {name=l4 lab=Z[4]}
C {devices/bus_connect.sym} 780 -290 3 1 {name=l5 lab=Z[3]}
C {devices/bus_connect.sym} 700 -290 3 1 {name=l6 lab=Z[2]}
C {devices/bus_connect.sym} 620 -290 3 1 {name=l7 lab=Z[1]}
C {devices/bus_connect.sym} 540 -290 3 1 {name=l8 lab=Z[0]}
C {devices/lab_pin.sym} 1090 -290 0 1 {name=l9 sig_type=std_logic lab=Z[6:0]}
C {devices/parax_cap.sym} 610 -370 0 0 {name=C8 gnd=0 value=4f m=1}
C {devices/parax_cap.sym} 690 -370 0 0 {name=C9 gnd=0 value=4f m=1}
C {devices/parax_cap.sym} 770 -370 0 0 {name=C10 gnd=0 value=4f m=1}
C {devices/parax_cap.sym} 850 -370 0 0 {name=C11 gnd=0 value=4f m=1}
C {devices/parax_cap.sym} 930 -370 0 0 {name=C12 gnd=0 value=4f m=1}
C {devices/parax_cap.sym} 1010 -370 0 0 {name=C13 gnd=0 value=4f m=1}
C {devices/parax_cap.sym} 1090 -370 0 0 {name=C14 gnd=0 value=4.01f m=1}
C {devices/bus_connect.sym} 1020 -550 3 1 {name=l10 lab=Y[6]}
C {devices/bus_connect.sym} 940 -550 3 1 {name=l11 lab=Y[5]}
C {devices/bus_connect.sym} 860 -550 3 1 {name=l12 lab=Y[4]}
C {devices/bus_connect.sym} 780 -550 3 1 {name=l13 lab=Y[3]}
C {devices/bus_connect.sym} 700 -550 3 1 {name=l14 lab=Y[2]}
C {devices/bus_connect.sym} 620 -550 3 1 {name=l15 lab=Y[1]}
C {devices/bus_connect.sym} 540 -550 3 1 {name=l16 lab=Y[0]}
C {devices/lab_pin.sym} 1090 -550 0 1 {name=l17 sig_type=std_logic lab=Y[6:0]}
C {sky130_tests/not.sym} 570 -180 0 0 {name=x4 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {sky130_tests/not.sym} 650 -180 0 0 {name=x1 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {sky130_tests/not.sym} 730 -180 0 0 {name=x2 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {sky130_tests/not.sym} 810 -180 0 0 {name=x3 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {sky130_tests/not.sym} 890 -180 0 0 {name=x5 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {sky130_tests/not.sym} 970 -180 0 0 {name=x6 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {sky130_tests/not.sym} 1050 -180 0 0 {name=x7 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {sky130_tests/lvtnot.sym} 570 -440 0 0 {name=x8 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.35}
C {sky130_tests/lvtnot.sym} 650 -440 0 0 {name=x9 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.35}
C {sky130_tests/lvtnot.sym} 730 -440 0 0 {name=x10 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.35}
C {sky130_tests/lvtnot.sym} 810 -440 0 0 {name=x11 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.35}
C {sky130_tests/lvtnot.sym} 890 -440 0 0 {name=x12 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.35}
C {sky130_tests/lvtnot.sym} 970 -440 0 0 {name=x13 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.35}
C {sky130_tests/lvtnot.sym} 1050 -440 0 0 {name=x14 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.35}
C {devices/code.sym} 40 -180 0 0 {name=TT_MODELS
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
