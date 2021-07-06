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
N 660 -230 660 -200 { lab=E2}
N 410 -80 660 -80 { lab=VSS}
N 570 -170 570 -140 { lab=#net1}
N 570 -170 620 -170 { lab=#net1}
N 500 -170 500 -140 { lab=#net2}
N 450 -170 500 -170 { lab=#net2}
N 380 -170 410 -170 { lab=VSS}
N 660 -320 660 -290 { lab=MINUS}
N 410 -380 410 -200 { lab=PLUS}
N 410 -900 1040 -900 { lab=VBG}
N 660 -170 690 -170 { lab=VSS}
N 1020 -350 1040 -350 { lab=VBG}
N 1040 -900 1040 -350 { lab=VBG}
N 1040 -900 1110 -900 { lab=VBG}
N 410 -380 860 -380 { lab=PLUS}
N 410 -420 410 -380 { lab=PLUS}
N 660 -320 860 -320 { lab=MINUS}
N 660 -420 660 -320 { lab=MINUS}
N 1280 -430 1300 -430 { lab=#net3}
N 1300 -360 1300 -280 { lab=#net3}
N 1280 -280 1300 -280 { lab=#net3}
N 1300 -360 1470 -360 { lab=#net3}
N 1300 -430 1300 -360 { lab=#net3}
N 1740 -450 1760 -450 { lab=#net4}
N 1740 -170 1760 -170 { lab=#net4}
N 1740 -390 1740 -170 { lab=#net4}
N 1630 -390 1740 -390 { lab=#net4}
N 1740 -450 1740 -390 { lab=#net4}
N 2040 -450 2140 -450 { lab=ADJ2}
N 2040 -170 2140 -170 { lab=ADJ}
N 1230 -700 1440 -700 {lab=CLK}
N 1440 -800 1540 -800 {lab=CLK}
N 1440 -700 1440 -600 {lab=CLK}
N 1440 -800 1440 -700 {lab=CLK}
N 1440 -600 1460 -600 { lab=CLK}
N 1980 -680 1980 -620 { lab=#net5}
N 1540 -730 1980 -680 { lab=#net5}
N 1540 -760 1540 -730 { lab=#net5}
N 1980 -780 1980 -720 { lab=#net6}
N 1540 -670 1980 -720 { lab=#net6}
N 1540 -670 1540 -640 { lab=#net6}
N 2040 -450 2040 -360 { lab=ADJ2}
N 1840 -450 2040 -450 { lab=ADJ2}
N 2040 -280 2040 -170 { lab=ADJ}
N 1840 -170 2040 -170 { lab=ADJ}
N 2060 -850 2060 -780 { lab=F2}
N 2060 -620 2060 -550 { lab=F1}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/ipin.sym} 80 -130 0 0 {name=p1 lab=EN_N}
C {devices/opin.sym} 170 -130 0 0 {name=p2 lab=VBG}
C {sky130_fd_pr/pnp_05v5.sym} 430 -170 0 1 {name=Q1
model="pnp_05v5_W0p68L0p68 m=1"
spiceprefix=X
}
C {sky130_fd_pr/pnp_05v5.sym} 640 -170 0 0 {name=Q2
model="pnp_05v5_W0p68L0p68 m=8"
spiceprefix=X
}
C {devices/lab_pin.sym} 1110 -900 0 1 {name=l2 sig_type=std_logic lab=VBG}
C {devices/ammeter.sym} 410 -110 0 0 {name=Vc1 net_name=true}
C {devices/ammeter.sym} 500 -110 0 0 {name=Vb1 net_name=true}
C {devices/ammeter.sym} 570 -110 0 0 {name=Vb2 net_name=true}
C {devices/ammeter.sym} 660 -110 0 0 {name=Vc2 net_name=true}
C {devices/lab_pin.sym} 410 -390 0 1 {name=l26 sig_type=std_logic lab=PLUS}
C {devices/lab_pin.sym} 660 -210 0 1 {name=l27 sig_type=std_logic lab=E2}
C {devices/lab_pin.sym} 660 -330 0 1 {name=l28 sig_type=std_logic lab=MINUS}
C {sky130_tests/bandgap_opamp.sym} 940 -350 0 0 {name=x1}
C {devices/lab_pin.sym} 860 -220 0 0 {name=l30 sig_type=std_logic lab=VCC}
C {devices/lab_pin.sym} 860 -200 0 0 {name=l31 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 860 -240 0 0 {name=l32 sig_type=std_logic lab=EN_N}
C {devices/ipin.sym} 80 -110 0 0 {name=p3 lab=VCC}
C {devices/lab_pin.sym} 410 -80 0 0 {name=l3 sig_type=std_logic lab=VSS}
C {devices/ipin.sym} 80 -90 0 0 {name=p4 lab=VSS}
C {devices/lab_pin.sym} 380 -170 0 0 {name=l6 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 690 -170 0 1 {name=l7 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 390 -750 0 0 {name=l4 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 390 -690 0 0 {name=l5 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 390 -630 0 0 {name=l8 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 390 -570 0 0 {name=l9 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 390 -510 0 0 {name=l10 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 390 -450 0 0 {name=l11 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 640 -750 0 0 {name=l12 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 640 -690 0 0 {name=l13 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 640 -630 0 0 {name=l14 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 640 -570 0 0 {name=l16 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 640 -510 0 0 {name=l17 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 640 -450 0 0 {name=l18 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 640 -260 0 0 {name=l19 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 390 -810 0 0 {name=l15 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 640 -810 0 0 {name=l20 sig_type=std_logic lab=VSS}
C {devices/ammeter.sym} 410 -870 0 0 {name=V1 net_name=true}
C {devices/ammeter.sym} 660 -870 0 0 {name=V2 net_name=true}
C {devices/lab_pin.sym} 860 -260 0 0 {name=p5 lab=ADJ}
C {devices/lab_pin.sym} 860 -280 0 0 {name=p6 lab=START}
C {sky130_tests/zero_opamp.sym} 1550 -390 0 0 {name=x2}
C {sky130_tests/passgate.sym} 1240 -430 0 0 {name=x3 W_N=0.5 L_N=0.15 W_P=0.5 L_P=0.15 VCCBPIN=VCC VSSBPIN=VSS m=1}
C {sky130_tests/passgate.sym} 1240 -280 0 0 {name=x4 W_N=0.5 L_N=0.15 W_P=0.5 L_P=0.15 VCCBPIN=VCC VSSBPIN=VSS m=1}
C {devices/lab_pin.sym} 1240 -250 0 0 {name=l23 sig_type=std_logic lab=F1}
C {devices/lab_pin.sym} 1240 -400 0 0 {name=l24 sig_type=std_logic lab=F2}
C {devices/lab_pin.sym} 1240 -460 0 0 {name=l66 sig_type=std_logic lab=F2N}
C {devices/lab_pin.sym} 1240 -310 0 0 {name=l67 sig_type=std_logic lab=F1N}
C {devices/lab_pin.sym} 1470 -420 0 0 {name=l25 sig_type=std_logic lab=PLUS}
C {devices/lab_pin.sym} 1200 -430 0 0 {name=l29 sig_type=std_logic lab=PLUS}
C {devices/lab_pin.sym} 1200 -280 0 0 {name=l33 sig_type=std_logic lab=MINUS}
C {sky130_tests/passgate.sym} 1800 -450 0 0 {name=x5 W_N=0.5 L_N=0.15 W_P=0.5 L_P=0.15 VCCBPIN=VCC VSSBPIN=VSS m=1}
C {sky130_tests/passgate.sym} 1800 -170 0 0 {name=x6 W_N=0.5 L_N=0.15 W_P=0.5 L_P=0.15 VCCBPIN=VCC VSSBPIN=VSS m=1}
C {devices/lab_pin.sym} 1800 -140 0 0 {name=l34 sig_type=std_logic lab=F1}
C {devices/lab_pin.sym} 1800 -420 0 0 {name=l35 sig_type=std_logic lab=F2}
C {devices/lab_pin.sym} 1800 -480 0 0 {name=l36 sig_type=std_logic lab=F2N}
C {devices/lab_pin.sym} 1800 -200 0 0 {name=l37 sig_type=std_logic lab=F1N}
C {devices/lab_pin.sym} 2140 -450 0 1 {name=l38 lab=ADJ2}
C {devices/lab_pin.sym} 2140 -170 0 1 {name=l255 lab=ADJ}
C {devices/lab_pin.sym} 1470 -320 0 0 {name=l41 lab=ADJ2}
C {devices/lab_pin.sym} 1470 -280 0 0 {name=l42 sig_type=std_logic lab=VCC}
C {devices/lab_pin.sym} 1470 -260 0 0 {name=l43 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 1470 -300 0 0 {name=l44 sig_type=std_logic lab=EN_N}
C {devices/lab_pin.sym} 2060 -780 0 1 {name=l243 sig_type=std_logic lab=F2}
C {devices/lab_pin.sym} 2060 -620 0 1 {name=l244 sig_type=std_logic lab=F1}
C {devices/lab_pin.sym} 2140 -850 0 1 {name=l61 sig_type=std_logic lab=F2N}
C {devices/lab_pin.sym} 2140 -550 0 1 {name=l62 sig_type=std_logic lab=F1N}
C {sky130_tests/lvnand.sym} 1590 -780 0 0 {name=x8 WidthN=1 LenN=0.15 WidthP=1 LenP=0.15 m=1}
C {sky130_tests/lvnand.sym} 1590 -620 2 1 {name=x9 WidthN=1 LenN=0.15 WidthP=1 LenP=0.15 m=1}
C {sky130_tests/not.sym} 1500 -600 0 0 {name=x10 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {sky130_tests/not.sym} 2020 -780 0 0 {name=x11 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {sky130_tests/not.sym} 1700 -780 0 0 {name=x12 m=1 VCCPIN=VCC VSSPIN=VSS W_N=0.5 L_N=1 W_P=1 L_P=1}
C {sky130_tests/not.sym} 1780 -780 0 0 {name=x13 m=1 VCCPIN=VCC VSSPIN=VSS W_N=0.5 L_N=1 W_P=1 L_P=1}
C {sky130_tests/not.sym} 1860 -780 0 0 {name=x14 m=1 VCCPIN=VCC VSSPIN=VSS W_N=0.5 L_N=1 W_P=1 L_P=1}
C {sky130_tests/not.sym} 1940 -780 0 0 {name=x15 m=1 VCCPIN=VCC VSSPIN=VSS W_N=0.5 L_N=1 W_P=1 L_P=1}
C {sky130_tests/not.sym} 1700 -620 0 0 {name=x16 m=1 VCCPIN=VCC VSSPIN=VSS W_N=0.5 L_N=1 W_P=1 L_P=1}
C {sky130_tests/not.sym} 1780 -620 0 0 {name=x17 m=1 VCCPIN=VCC VSSPIN=VSS W_N=0.5 L_N=1 W_P=1 L_P=1}
C {sky130_tests/not.sym} 1860 -620 0 0 {name=x18 m=1 VCCPIN=VCC VSSPIN=VSS W_N=0.5 L_N=1 W_P=1 L_P=1}
C {sky130_tests/not.sym} 1940 -620 0 0 {name=x19 m=1 VCCPIN=VCC VSSPIN=VSS W_N=0.5 L_N=1 W_P=1 L_P=1}
C {sky130_tests/not.sym} 2020 -620 0 0 {name=x20 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {devices/capa.sym} 850 -870 0 0 {name=c2 value=5p}
C {devices/lab_pin.sym} 850 -840 0 0 {name=l45 sig_type=std_logic lab=VSS}
C {sky130_tests/passgate.sym} 2040 -320 1 0 {name=x7 W_N=0.5 L_N=0.15 W_P=0.5 L_P=0.15 VCCBPIN=VCC VSSBPIN=VSS m=1}
C {sky130_tests/not.sym} 140 -260 0 0 {name=x21 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {devices/lab_pin.sym} 100 -260 0 0 {name=p15 lab=START}
C {devices/lab_pin.sym} 180 -260 0 1 {name=p16 lab=START_N}
C {devices/lab_pin.sym} 2010 -320 0 0 {name=p8 lab=START}
C {devices/lab_pin.sym} 2070 -320 0 1 {name=p9 lab=START_N}
C {sky130_tests/not.sym} 2100 -550 0 0 {name=x22 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {sky130_tests/not.sym} 2100 -850 0 0 {name=x23 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {devices/lab_pin.sym} 1230 -700 0 0 {name=l22 sig_type=std_logic lab=CLK}
C {devices/ipin.sym} 80 -150 0 0 { name=p10 lab=CLK }
C {devices/ipin.sym} 80 -170 0 0 { name=p7 lab=START }
C {devices/lab_pin.sym} 1910 -390 0 0 {name=l21 sig_type=std_logic lab=VSS}
C {sky130_fd_pr/cap_mim_m3_2.sym} 1910 -420 0 0 {name=C2 model=cap_mim_m3_2 W=10 L=10 MF=5 spiceprefix=X }
C {devices/lab_pin.sym} 1910 -110 0 0 {name=l40 sig_type=std_logic lab=VSS}
C {sky130_fd_pr/cap_mim_m3_2.sym} 1910 -140 0 0 {name=C1 model=cap_mim_m3_2 W=10 L=10 MF=20 spiceprefix=X }
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 660 -810 0 0 {name=R1
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 660 -750 0 0 {name=R2
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 660 -690 0 0 {name=R3
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 660 -630 0 0 {name=R4
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 660 -570 0 0 {name=R5
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 660 -510 0 0 {name=R6
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 660 -450 0 0 {name=R7
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 410 -810 0 0 {name=R8
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 410 -750 0 0 {name=R9
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 410 -690 0 0 {name=R10
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 410 -630 0 0 {name=R11
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 410 -570 0 0 {name=R12
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 410 -510 0 0 {name=R13
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 410 -450 0 0 {name=R14
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 660 -260 0 0 {name=R15
W=0.69
L=10
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
