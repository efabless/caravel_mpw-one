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
T {Clock gated latch} 1180 -750 0 0 0.4 0.4 {}
T {Edge trigger emulation with pulsed clock} 1050 -1110 0 0 0.4 0.4 {}
T {Some random logic stuff} 570 -1270 0 0 1 1 {}
N 60 -360 280 -360 { lab=D}
N 60 -360 60 -300 { lab=D}
N 420 -360 510 -360 { lab=QI}
N 480 -330 480 -140 { lab=CLK}
N 480 -330 510 -330 { lab=CLK}
N 650 -360 690 -360 { lab=Q}
N 650 -300 690 -300 { lab=QN}
N 30 -360 60 -360 { lab=D}
N 130 -200 160 -200 { lab=CLK}
N 140 -300 280 -300 { lab=DN}
N 160 -140 480 -140 { lab=CLK}
N 160 -200 160 -140 { lab=CLK}
N 240 -330 240 -200 { lab=#net1}
N 240 -330 280 -330 { lab=#net1}
N 420 -300 510 -300 { lab=QIN}
N 70 -580 70 -550 { lab=D}
N 70 -580 140 -580 { lab=D}
N 320 -580 320 -550 { lab=CLK}
N 320 -580 390 -580 { lab=CLK}
N 720 -920 720 -890 { lab=QN1}
N 600 -980 720 -920 { lab=QN1}
N 600 -1000 600 -980 { lab=QN1}
N 720 -1020 720 -990 { lab=Q1}
N 600 -950 720 -990 { lab=Q1}
N 600 -950 600 -930 { lab=Q1}
N 390 -760 390 -730 { lab=#net2}
N 390 -890 390 -860 { lab=#net3}
N 270 -800 390 -860 { lab=#net3}
N 270 -800 270 -770 { lab=#net3}
N 270 -850 270 -820 { lab=#net2}
N 270 -820 390 -760 { lab=#net2}
N 390 -1130 390 -1040 { lab=#net4}
N 270 -1190 390 -1130 { lab=#net4}
N 270 -1210 270 -1190 { lab=#net4}
N 390 -1230 390 -1200 { lab=#net5}
N 270 -1160 390 -1200 { lab=#net5}
N 270 -1160 270 -1140 { lab=#net5}
N 270 -960 270 -930 { lab=#net4}
N 270 -960 390 -1020 { lab=#net4}
N 390 -1040 390 -1020 { lab=#net4}
N 390 -890 600 -890 { lab=#net3}
N 390 -1040 600 -1040 { lab=#net4}
N 720 -1020 760 -1020 { lab=Q1}
N 720 -890 760 -890 { lab=QN1}
N 600 -850 600 -660 { lab=RESETB}
N 270 -660 600 -660 { lab=RESETB}
N 270 -690 270 -660 { lab=RESETB}
N 220 -1060 220 -660 { lab=RESETB}
N 220 -1060 270 -1060 { lab=RESETB}
N 190 -890 270 -890 { lab=CLK}
N 190 -990 190 -890 { lab=CLK}
N 190 -1100 270 -1100 { lab=CLK}
N 160 -990 190 -990 { lab=CLK}
N 270 -730 270 -720 { lab=D}
N 160 -720 270 -720 { lab=D}
N 240 -850 270 -850 { lab=#net2}
N 240 -1250 240 -850 { lab=#net2}
N 240 -1250 270 -1250 { lab=#net2}
N 700 -580 700 -550 { lab=RESETB}
N 700 -580 770 -580 { lab=RESETB}
N 220 -660 270 -660 { lab=RESETB}
N 170 -660 220 -660 { lab=RESETB}
N 190 -1100 190 -990 { lab=CLK}
N 1250 -550 1300 -550 { lab=D}
N 1060 -510 1080 -510 { lab=CLK}
N 1300 -630 1300 -550 { lab=D}
N 1300 -670 1510 -670 { lab=Q2}
N 1510 -670 1510 -550 { lab=Q2}
N 1480 -550 1510 -550 { lab=Q2}
N 1200 -530 1300 -530 { lab=#net6}
N 1080 -650 1180 -650 { lab=#net7}
N 1080 -650 1080 -550 { lab=#net7}
N 1510 -550 1550 -550 { lab=Q2}
N 930 -850 1360 -850 { lab=CLK}
N 930 -890 930 -850 { lab=CLK}
N 1480 -790 1640 -790 { lab=RESETB}
N 1640 -850 1640 -790 { lab=RESETB}
N 1480 -870 1640 -870 { lab=#net8}
N 1330 -890 1360 -890 { lab=#net9}
N 1010 -970 1010 -890 { lab=#net10}
N 1250 -970 1250 -890 { lab=#net11}
N 1600 -1100 1650 -1100 { lab=D}
N 1830 -1120 2000 -1120 { lab=#net12}
N 890 -850 930 -850 { lab=CLK}
N 1820 -890 1860 -890 { lab=Q3}
N 1570 -950 1640 -950 { lab=D}
N 1640 -950 1640 -890 { lab=D}
N 1510 -1120 1510 -870 { lab=#net8}
N 1510 -1120 1650 -1120 { lab=#net8}
N 1610 -1190 1660 -1190 { lab=D}
N 1840 -1210 1960 -1210 { lab=#net13}
N 1840 -1190 2000 -1190 { lab=#net14}
N 1960 -1210 2000 -1210 { lab=#net13}
N 1660 -1310 1660 -1210 { lab=CLK}
N 1660 -1310 1690 -1310 { lab=CLK}
N 1770 -1310 1860 -1310 { lab=#net15}
N 1940 -1310 2000 -1310 { lab=#net16}
N 1150 -1160 1200 -1160 { lab=D}
N 1380 -1180 1470 -1180 { lab=#net17}
N 1690 -670 1740 -670 { lab=D}
N 1670 -650 1740 -650 { lab=CLK}
N 1920 -670 1980 -670 { lab=Q4}
N 1920 -650 1980 -650 { lab=Q4B}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {sky130_stdcells/and2_1.sym} 1420 -870 0 0 {name=x17 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/dlrtp_1.sym} 1730 -870 0 0 {name=x16 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_tests/lvtnot.sym} 1130 -970 0 0 {name=x21 m=1 
+ W_N=0.6 L_N=0.8 W_P=0.6 L_P=0.4 
+ VCCPIN=VDD VSSPIN=GND}
C {sky130_tests/lvtnot.sym} 1210 -970 0 0 {name=x22 m=1 
+ W_N=0.6 L_N=0.8 W_P=0.6 L_P=0.4 
+ VCCPIN=VDD VSSPIN=GND}
C {sky130_stdcells/inv_1.sym} 1290 -890 2 1 {name=x15 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 970 -890 2 1 {name=x20 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/dfrtp_1.sym} 1740 -1100 0 0 {name=x18 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_tests/lvtnot.sym} 1050 -970 0 0 {name=x23 m=1 
+ W_N=0.6 L_N=0.8 W_P=0.6 L_P=0.4 
+ VCCPIN=VDD VSSPIN=GND}
C {devices/vsource.sym} 70 -520 0 0 {name=V1 value="pulse 0 1.8 15n .1n .1n 19.9n 40n"}
C {devices/gnd.sym} 70 -490 0 0 {name=l4 lab=GND}
C {devices/lab_pin.sym} 140 -580 0 1 {name=l5 sig_type=std_logic lab=D}
C {devices/vsource.sym} 320 -520 0 0 {name=V2 value="pulse 0 1.8 10n .1n .1n 9.9n 20n"}
C {devices/gnd.sym} 320 -490 0 0 {name=l6 lab=GND}
C {devices/lab_pin.sym} 390 -580 0 1 {name=l7 sig_type=std_logic lab=CLK}
C {devices/vsource.sym} 570 -520 0 0 {name=V3 value=1.8}
C {devices/gnd.sym} 570 -490 0 0 {name=l8 lab=GND}
C {devices/vdd.sym} 570 -550 0 0 {name=l9 lab=VDD}
C {devices/lab_pin.sym} 690 -360 0 1 {name=l10 sig_type=std_logic lab=Q}
C {devices/lab_pin.sym} 690 -300 0 1 {name=l11 sig_type=std_logic lab=QN}
C {devices/lab_wire.sym} 430 -360 0 1 {name=l12 sig_type=std_logic lab=QI}
C {devices/lab_wire.sym} 430 -300 0 1 {name=l13 sig_type=std_logic lab=QIN}
C {devices/lab_wire.sym} 160 -300 0 1 {name=l14 sig_type=std_logic lab=DN}
C {sky130_stdcells/nand2_1.sym} 330 -1230 0 0 {name=x5 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/nand3_1.sym} 330 -1100 0 0 {name=x6 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/nand3_1.sym} 330 -890 0 0 {name=x7 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/nand3_1.sym} 330 -730 0 0 {name=x8 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/nand3_1.sym} 660 -890 0 0 {name=x9 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/nand2_1.sym} 660 -1020 0 0 {name=x10 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {devices/lab_pin.sym} 760 -1020 0 1 {name=l15 sig_type=std_logic lab=Q1}
C {devices/lab_pin.sym} 760 -890 0 1 {name=l16 sig_type=std_logic lab=QN1}
C {devices/lab_pin.sym} 160 -990 0 0 {name=l17 sig_type=std_logic lab=CLK}
C {devices/lab_pin.sym} 160 -720 0 0 {name=l18 sig_type=std_logic lab=D}
C {devices/lab_pin.sym} 170 -660 0 0 {name=l19 sig_type=std_logic lab=RESETB}
C {devices/vsource.sym} 700 -520 0 0 {name=V4 value="pwl 0 0 10n 0 11n 1.8"}
C {devices/gnd.sym} 700 -490 0 0 {name=l20 lab=GND}
C {devices/lab_pin.sym} 770 -580 0 1 {name=l21 sig_type=std_logic lab=RESETB}
C {devices/code.sym} 990 -200 0 0 {name=STDCELL_MODELS 
only_toplevel=true
place=end
format="tcleval(@value )"
value="[sky130_models]"
}
C {sky130_stdcells/xor2_1.sym} 1240 -650 0 1 {name=x11 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/dlrtn_1.sym} 1390 -530 0 0 {name=x13 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {devices/lab_pin.sym} 1300 -510 0 0 {name=l22 sig_type=std_logic lab=RESETB}
C {devices/lab_pin.sym} 1250 -550 0 0 {name=l23 sig_type=std_logic lab=D}
C {devices/lab_pin.sym} 1060 -510 0 0 {name=l24 sig_type=std_logic lab=CLK}
C {devices/lab_pin.sym} 1550 -550 0 1 {name=l25 sig_type=std_logic lab=Q2}
C {sky130_stdcells/nand2_1.sym} 1140 -530 0 0 {name=x12 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_tests/lvtnot.sym} 100 -300 0 0 {name=x3 m=1 
+ W_N=1 L_N=0.15 W_P=2 L_P=0.35 
+ VCCPIN=VDD VSSPIN=GND}
C {devices/lab_pin.sym} 130 -200 0 0 {name=l3 sig_type=std_logic lab=CLK}
C {devices/lab_pin.sym} 1570 -950 0 0 {name=l31 sig_type=std_logic lab=D}
C {devices/lab_pin.sym} 890 -850 2 1 {name=l28 sig_type=std_logic lab=CLK}
C {devices/lab_pin.sym} 1480 -790 0 0 {name=l29 sig_type=std_logic lab=RESETB}
C {devices/lab_pin.sym} 1860 -890 0 1 {name=l30 sig_type=std_logic lab=Q3}
C {devices/code.sym} 840 -200 0 0 {name=STIMULI 
only_toplevel=true
place=end
value="

.save all
.options savecurrents
.tran 0.2n 100n
"}
C {sky130_tests/srlatch.sym} 350 -330 0 0 {name=x1}
C {sky130_tests/srlatch.sym} 580 -330 0 0 {name=x2}
C {devices/code.sym} 830 -350 0 0 {name=TT_MODELS
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
C {sky130_tests/lvtnot.sym} 200 -200 0 0 {name=x4 m=1 
+ W_N=1 L_N=0.15 W_P=2 L_P=0.35 
+ VCCPIN=VDD VSSPIN=GND}
C {devices/lab_pin.sym} 1600 -1100 0 0 {name=l26 sig_type=std_logic lab=D}
C {devices/lab_pin.sym} 1650 -1080 0 0 {name=l27 sig_type=std_logic lab=RESETB}
C {devices/lab_pin.sym} 30 -360 0 0 {name=l2 sig_type=std_logic lab=D}
C {sky130_stdcells/dfrbp_1.sym} 1750 -1190 0 0 {name=x14 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {devices/lab_pin.sym} 1660 -1170 0 0 {name=l32 sig_type=std_logic lab=RESETB}
C {devices/lab_pin.sym} 1610 -1190 0 0 {name=l33 sig_type=std_logic lab=D}
C {devices/lab_pin.sym} 1660 -1210 2 1 {name=l34 sig_type=std_logic lab=CLK}
C {sky130_tests/lvtnot.sym} 1730 -1310 0 0 {name=x19 m=1 
+ W_N=0.6 L_N=0.8 W_P=0.6 L_P=0.4 
+ VCCPIN=VDD VSSPIN=GND}
C {sky130_tests/lvtnot.sym} 1900 -1310 0 0 {name=x24 m=1 
+ W_N=0.6 L_N=0.8 W_P=0.6 L_P=0.4 
+ VCCPIN=VDD VSSPIN=GND}
C {sky130_stdcells/dfxtp_1.sym} 1290 -1170 0 0 {name=x25 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {devices/lab_pin.sym} 1150 -1160 0 0 {name=l35 sig_type=std_logic lab=D}
C {devices/lab_pin.sym} 1200 -1180 2 1 {name=l36 sig_type=std_logic lab=CLK}
C {sky130_stdcells/dlrbp_1.sym} 1830 -650 0 0 {name=x26 VGND=GND VNB=GND VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {devices/lab_pin.sym} 1740 -630 0 0 {name=l37 sig_type=std_logic lab=RESETB}
C {devices/lab_pin.sym} 1690 -670 0 0 {name=l38 sig_type=std_logic lab=D}
C {devices/lab_pin.sym} 1670 -650 0 0 {name=l39 sig_type=std_logic lab=CLK}
C {devices/lab_pin.sym} 1980 -670 0 1 {name=l40 sig_type=std_logic lab=Q4}
C {devices/lab_pin.sym} 1980 -650 0 1 {name=l41 sig_type=std_logic lab=Q4B}
