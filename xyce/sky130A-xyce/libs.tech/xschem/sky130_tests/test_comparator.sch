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
L 3 250 -320 250 -130 {}
L 3 410 -320 410 -180 {}
L 3 570 -320 570 -130 {}
L 4 150 -110 250 -110 {}
L 4 250 -130 250 -110 {}
L 4 250 -130 570 -130 {}
L 4 570 -130 570 -110 {}
L 4 570 -110 690 -110 {}
L 4 150 -180 410 -180 {}
L 4 410 -180 410 -160 {}
L 4 410 -160 570 -160 {}
L 4 570 -180 570 -160 {}
L 4 570 -180 690 -180 {}
L 7 1310 -240 2740 -240 {}
T {CAL} 140 -190 0 1 0.4 0.4 {}
T {EN} 140 -140 0 1 0.4 0.4 {}
T {CALIBRATION
  30ns} 400 -310 0 1 0.4 0.4 {}
T {SENSING
  30ns} 530 -310 0 1 0.4 0.4 {}
T {OFF} 660 -310 0 1 0.4 0.4 {}
T {OFF} 210 -310 0 1 0.4 0.4 {}
T {NGSPICE MONTE CARLO SIMULATION} 1430 -290 0 0 0.8 0.8 {}
T {Offset-compensated comparator. Detects +/- 2mv differential signal on PLUS, MINUS.
Output on SAOUT
Gaussian Threshold variation is added to all MOS transistors.} 1330 -220 0 0 0.6 0.6 {}
N 120 -480 120 -460 {lab=TEMPERAT}
N 290 -1090 320 -1090 {lab=VSS}
N 290 -1060 290 -1030 {lab=VSS}
N 290 -1150 290 -1120 {lab=VSSI}
N 1120 -1100 1150 -1100 {lab=VSS}
N 1120 -1350 1150 -1350 {lab=VCC}
N 1090 -1430 1120 -1430 {lab=VCC}
N 1120 -1430 1120 -1380 {lab=VCC}
N 1090 -960 1120 -960 {lab=VSSI}
N 1120 -1000 1120 -960 {lab=VSSI}
N 980 -1100 1080 -1100 {lab=ZERO0}
N 980 -1270 980 -1100 {lab=ZERO0}
N 900 -1270 980 -1270 {lab=ZERO0}
N 780 -1270 820 -1270 {lab=OUTDIFF}
N 780 -1470 780 -1270 {lab=OUTDIFF}
N 780 -1470 1220 -1470 {lab=OUTDIFF}
N 1120 -1270 1220 -1270 {lab=OUTDIFF}
N 1610 -1100 1640 -1100 {lab=VSS}
N 1610 -1350 1640 -1350 {lab=VCC}
N 1580 -1430 1610 -1430 {lab=VCC}
N 1610 -1430 1610 -1380 {lab=VCC}
N 1580 -960 1610 -960 {lab=VSSI}
N 1610 -1000 1610 -960 {lab=VSSI}
N 1470 -1100 1570 -1100 {lab=ZERO1}
N 1470 -1270 1470 -1100 {lab=ZERO1}
N 1390 -1270 1470 -1270 {lab=ZERO1}
N 1270 -1270 1310 -1270 {lab=SAOUTF}
N 1270 -1470 1270 -1270 {lab=SAOUTF}
N 1270 -1470 1710 -1470 {lab=SAOUTF}
N 1610 -1270 1710 -1270 {lab=SAOUTF}
N 1220 -1470 1220 -1270 {lab=OUTDIFF}
N 1120 -1320 1120 -1270 {lab=OUTDIFF}
N 980 -1350 980 -1270 {lab=ZERO0}
N 1610 -1320 1610 -1270 {lab=SAOUTF}
N 1470 -1350 1470 -1270 {lab=ZERO1}
N 1710 -1470 1710 -1270 {lab=SAOUTF}
N 890 -650 920 -650 {lab=VSS}
N 1060 -650 1090 -650 {lab=VSS}
N 1090 -810 1120 -810 {lab=VCC}
N 860 -810 890 -810 {lab=VCC}
N 930 -810 1050 -810 {lab=GN}
N 930 -810 930 -770 {lab=GN}
N 890 -770 930 -770 {lab=GN}
N 890 -770 890 -680 {lab=GN}
N 1090 -720 1090 -680 {lab=OUTDIFF}
N 890 -880 890 -840 {lab=VCC}
N 990 -880 1090 -880 {lab=VCC}
N 1090 -880 1090 -840 {lab=VCC}
N 1090 -620 1090 -600 {lab=SN}
N 990 -600 1090 -600 {lab=SN}
N 890 -620 890 -600 {lab=SN}
N 990 -520 1020 -520 {lab=VSS}
N 990 -600 990 -550 {lab=SN}
N 990 -900 990 -880 {lab=VCC}
N 960 -380 990 -380 {lab=VSSI}
N 990 -420 990 -380 {lab=VSSI}
N 1470 -520 1500 -520 {lab=VSS}
N 1470 -810 1500 -810 {lab=VCC}
N 1440 -890 1470 -890 {lab=VCC}
N 1470 -890 1470 -840 {lab=VCC}
N 1440 -380 1470 -380 {lab=VSSI}
N 1470 -420 1470 -380 {lab=VSSI}
N 1470 -720 1470 -550 {lab=SAOUTF}
N 1220 -720 1360 -720 {lab=OUTDIFF}
N 890 -880 990 -880 {lab=VCC}
N 890 -600 990 -600 {lab=SN}
N 1120 -1270 1120 -1130 {lab=OUTDIFF}
N 1610 -1270 1610 -1130 {lab=SAOUTF}
N 1360 -720 1360 -520 {lab=OUTDIFF}
N 1220 -1270 1220 -720 {lab=OUTDIFF}
N 1710 -1270 1710 -720 {lab=SAOUTF}
N 1710 -720 1850 -720 {lab=SAOUTF}
N 1090 -720 1220 -720 {lab=OUTDIFF}
N 1090 -780 1090 -720 {lab=OUTDIFF}
N 1360 -810 1360 -720 {lab=OUTDIFF}
N 1470 -1350 1570 -1350 {lab=ZERO1}
N 980 -1350 1080 -1350 {lab=ZERO0}
N 1360 -810 1430 -810 {lab=OUTDIFF}
N 1360 -520 1430 -520 {lab=OUTDIFF}
N 1960 -520 1990 -520 {lab=VSS}
N 1960 -810 1990 -810 {lab=VCC}
N 1930 -890 1960 -890 {lab=VCC}
N 1960 -890 1960 -840 {lab=VCC}
N 1930 -380 1960 -380 {lab=VSSI}
N 1960 -420 1960 -380 {lab=VSSI}
N 1960 -720 1960 -550 {lab=SAOUT}
N 1850 -720 1850 -520 {lab=SAOUTF}
N 2100 -1100 2130 -1100 {lab=VSS}
N 2100 -1350 2130 -1350 {lab=VCC}
N 2070 -1430 2100 -1430 {lab=VCC}
N 2100 -1430 2100 -1380 {lab=VCC}
N 2070 -960 2100 -960 {lab=VSSI}
N 2100 -1000 2100 -960 {lab=VSSI}
N 1960 -1100 2060 -1100 {lab=ZERO2}
N 1960 -1270 1960 -1100 {lab=ZERO2}
N 1880 -1270 1960 -1270 {lab=ZERO2}
N 1760 -1270 1800 -1270 {lab=SAOUT}
N 1760 -1470 1760 -1270 {lab=SAOUT}
N 1760 -1470 2290 -1470 {lab=SAOUT}
N 2100 -1270 2290 -1270 {lab=SAOUT}
N 2100 -1320 2100 -1270 {lab=SAOUT}
N 1960 -1350 1960 -1270 {lab=ZERO2}
N 2290 -1470 2290 -1270 {lab=SAOUT}
N 2100 -1270 2100 -1130 {lab=SAOUT}
N 2290 -1270 2290 -720 {lab=SAOUT}
N 1960 -1350 2060 -1350 {lab=ZERO2}
N 1850 -810 1920 -810 {lab=SAOUTF}
N 1850 -520 1920 -520 {lab=SAOUTF}
N 1470 -720 1710 -720 {lab=SAOUTF}
N 2180 -720 2290 -720 {lab=SAOUT}
N 1850 -810 1850 -720 {lab=SAOUTF}
N 1960 -780 1960 -720 {lab=SAOUT}
N 1470 -780 1470 -720 {lab=SAOUTF}
N 2180 -820 2210 -820 {lab=VCC}
N 2150 -900 2180 -900 {lab=VCC}
N 2180 -900 2180 -850 {lab=VCC}
N 2180 -790 2180 -720 {lab=SAOUT}
N 590 -780 620 -780 {lab=VCC}
N 530 -850 620 -850 {lab=SP}
N 620 -850 620 -810 {lab=SP}
N 420 -850 530 -850 {lab=SP}
N 420 -780 450 -780 {lab=VCC}
N 390 -650 420 -650 {lab=VSS}
N 620 -650 650 -650 {lab=VSS}
N 460 -650 580 -650 {lab=GP}
N 460 -690 460 -650 {lab=GP}
N 420 -690 460 -690 {lab=GP}
N 420 -750 420 -690 {lab=GP}
N 620 -710 620 -680 {lab=OUTDIFF}
N 620 -620 620 -600 {lab=VSSI}
N 520 -600 620 -600 {lab=VSSI}
N 420 -620 420 -600 {lab=VSSI}
N 490 -560 520 -560 {lab=VSSI}
N 520 -600 520 -560 {lab=VSSI}
N 530 -920 560 -920 {lab=VCC}
N 530 -890 530 -850 {lab=SP}
N 530 -980 530 -950 {lab=VCC}
N 620 -710 680 -710 {lab=OUTDIFF}
N 950 -1020 980 -1020 {lab=VCC}
N 980 -1040 980 -1020 { lab=VCC}
N 1440 -1020 1470 -1020 {lab=VCC}
N 1470 -1040 1470 -1020 { lab=VCC}
N 1930 -1020 1960 -1020 {lab=VCC}
N 1960 -1040 1960 -1020 { lab=VCC}
N 420 -850 420 -810 { lab=SP}
N 990 -490 990 -480 { lab=#net1}
N 890 -780 890 -770 { lab=GN}
N 1120 -1070 1120 -1060 { lab=#net2}
N 1610 -1070 1610 -1060 { lab=#net3}
N 1470 -490 1470 -480 { lab=#net4}
N 1960 -490 1960 -480 { lab=#net5}
N 1960 -720 2180 -720 {lab=SAOUT}
N 620 -750 620 -710 {lab=OUTDIFF}
N 420 -600 520 -600 {lab=VSSI}
N 420 -690 420 -680 { lab=GP}
N 2100 -1070 2100 -1060 { lab=#net6}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/ipin.sym} 110 -860 0 0 { name=p92 lab=CAL }
C {devices/ipin.sym} 110 -920 0 0 { name=p93 lab=PLUS }
C {devices/ipin.sym} 110 -960 0 0 { name=p94 lab=MINUS }
C {devices/ipin.sym} 110 -1000 0 0 { name=p95 lab=EN }
C {devices/ipin.sym} 110 -790 0 0 { name=p96 lab=VSS }
C {devices/ipin.sym} 110 -820 0 0 { name=p97 lab=VCC }
C {devices/vsource_arith.sym} 120 -430 0 0 {name=E5 VOL=temper MAX=200 MIN=-200}
C {devices/lab_pin.sym} 120 -480 0 1 {name=p113 lab=TEMPERAT}
C {devices/lab_pin.sym} 120 -400 0 0 {name=p114 lab=VSS}
C {devices/opin.sym} 150 -910 0 0 { name=p116 lab=SAOUT }
C {devices/lab_pin.sym} 200 -580 0 1 {name=p126 lab=CALB}
C {devices/lab_pin.sym} 120 -580 0 0 {name=l50 lab=CAL}
C {devices/code.sym} 720 -340 0 0 {name=STIMULI 
only_toplevel=true
place=end
value="* .option SCALE=1e-6 
.option method=gear seed=12

* this experimental option enables mos model bin 
* selection based on W/NF instead of W
.option wnflag=1 

* .param VCC=1.8
.param VCCGAUSS=agauss(1.8, 0.05, 1)
.param VCC=VCCGAUSS
.param VDL='VCC/2+0.2'
.param ABSVAR=0.02
.temp 25

** to generate following file: 
** copy .../xschem_sky130/sky130_tests/stimuli.test_comparator to simulation directory
** then do 'Simulation->Utile Stimuli Editor (GUI)' and press 'Translate'
.include \\"stimuli_test_comparator.cir\\"

** variation marameters:
.param sky130_fd_pr__nfet_01v8_lvt__vth0_slope_spectre='agauss(0, ABSVAR, 3)/sky130_fd_pr__nfet_01v8_lvt__vth0_slope'
.param sky130_fd_pr__pfet_01v8_lvt__vth0_slope_spectre='agauss(0, ABSVAR, 3)/sky130_fd_pr__pfet_01v8_lvt__vth0_slope'

* .tran 0.1n 900n uic

.control
  let run=1
  dowhile run <= 20
    if run > 1
      reset
      set appendwrite
    end
    save all
    * save saout cal i(vvcc) en plus minus
    tran 0.1n 300n uic
    write test_comparator.raw
    let run = run + 1
  end
.endc
"}
C {devices/lab_pin.sym} 120 -710 0 0 {name=p15 lab=CALB}
C {devices/lab_pin.sym} 200 -710 0 1 {name=l4 lab=CALBB}
C {devices/lab_pin.sym} 320 -1090 0 1 {name=p283 lab=VSS}
C {devices/lab_pin.sym} 250 -1090 0 0 {name=l56 lab=EN}
C {devices/lab_pin.sym} 290 -1030 0 0 {name=p284 lab=VSS}
C {devices/lab_pin.sym} 290 -1150 0 0 {name=p199 lab=VSSI}
C {devices/parax_cap.sym} 290 -1020 0 0 {name=C38  value=2p}
C {devices/lab_pin.sym} 860 -1300 0 1 {name=l19 sig_type=std_logic lab=CALB}
C {devices/lab_pin.sym} 860 -1240 0 1 {name=l44 sig_type=std_logic lab=CALBB}
C {devices/lab_pin.sym} 1150 -1100 0 1 {name=p179 lab=VSS}
C {devices/lab_pin.sym} 1150 -1350 0 1 {name=p180 lab=VCC}
C {devices/lab_pin.sym} 1090 -1430 0 0 {name=p181 lab=VCC}
C {devices/lab_pin.sym} 1090 -960 0 0 {name=p182 lab=VSSI}
C {devices/lab_pin.sym} 1350 -1300 0 1 {name=l45 sig_type=std_logic lab=CALB}
C {devices/lab_pin.sym} 1350 -1240 0 1 {name=l46 sig_type=std_logic lab=CALBB}
C {devices/lab_pin.sym} 1640 -1100 0 1 {name=p183 lab=VSS}
C {devices/lab_pin.sym} 1640 -1350 0 1 {name=p184 lab=VCC}
C {devices/lab_pin.sym} 1580 -1430 0 0 {name=p185 lab=VCC}
C {devices/lab_pin.sym} 1580 -960 0 0 {name=p186 lab=VSSI}
C {devices/lab_pin.sym} 1470 -1330 0 0 {name=l47 lab=ZERO1}
C {devices/lab_pin.sym} 980 -1330 0 0 {name=l48 lab=ZERO0}
C {devices/lab_pin.sym} 920 -650 0 1 {name=p187 lab=VSS}
C {devices/lab_pin.sym} 1060 -650 0 0 {name=p188 lab=VSS}
C {devices/lab_pin.sym} 1120 -810 0 1 {name=p189 lab=VCC}
C {devices/lab_pin.sym} 860 -810 0 0 {name=p190 lab=VCC}
C {devices/lab_pin.sym} 1020 -520 0 1 {name=p191 lab=VSS}
C {devices/lab_pin.sym} 990 -900 0 0 {name=p192 lab=VCC}
C {devices/lab_pin.sym} 960 -380 0 0 {name=p193 lab=VSSI}
C {devices/lab_pin.sym} 1500 -520 0 1 {name=p194 lab=VSS}
C {devices/lab_pin.sym} 1500 -810 0 1 {name=p195 lab=VCC}
C {devices/lab_pin.sym} 1440 -890 0 0 {name=p196 lab=VCC}
C {devices/lab_pin.sym} 1440 -380 0 0 {name=p197 lab=VSSI}
C {devices/lab_pin.sym} 1710 -760 0 0 {name=l49 lab=SAOUTF}
C {devices/parax_cap.sym} 1540 -710 0 0 {name=C3  value=4f}
C {devices/lab_pin.sym} 1220 -760 0 0 {name=l51 lab=OUTDIFF}
C {devices/lab_pin.sym} 990 -580 0 0 {name=l52 lab=SN}
C {devices/lab_pin.sym} 930 -780 0 1 {name=l53 lab=GN}
C {devices/parax_cap.sym} 980 -800 0 0 {name=C5  value=4f}
C {devices/parax_cap.sym} 910 -590 0 0 {name=C30  value=2f}
C {devices/parax_cap.sym} 1180 -710 0 0 {name=C31  value=4f}
C {devices/lab_pin.sym} 950 -520 0 0 {name=p198 lab=VCC}
C {devices/lab_pin.sym} 1130 -650 0 1 {name=l54 lab=PLUS}
C {devices/lab_pin.sym} 850 -650 0 0 {name=l55 lab=MINUS}
C {devices/ammeter.sym} 990 -450 0 0 {name=v2}
C {devices/ammeter.sym} 1470 -450 0 0 {name=v3}
C {devices/ammeter.sym} 1610 -1030 0 0 {name=v4}
C {devices/ammeter.sym} 1120 -1030 0 0 {name=v6}
C {devices/lab_pin.sym} 1990 -520 0 1 {name=p9 lab=VSS}
C {devices/lab_pin.sym} 1990 -810 0 1 {name=p10 lab=VCC}
C {devices/lab_pin.sym} 1930 -890 0 0 {name=p11 lab=VCC}
C {devices/lab_pin.sym} 1930 -380 0 0 {name=p12 lab=VSSI}
C {devices/parax_cap.sym} 2030 -710 0 0 {name=C1  value=4f}
C {devices/ammeter.sym} 1960 -450 0 0 {name=v1}
C {devices/lab_pin.sym} 2290 -720 0 1 {name=l3 lab=SAOUT}
C {devices/lab_pin.sym} 1840 -1300 0 1 {name=l5 sig_type=std_logic lab=CALB}
C {devices/lab_pin.sym} 1840 -1240 0 1 {name=l6 sig_type=std_logic lab=CALBB}
C {devices/lab_pin.sym} 2130 -1100 0 1 {name=p13 lab=VSS}
C {devices/lab_pin.sym} 2130 -1350 0 1 {name=p14 lab=VCC}
C {devices/lab_pin.sym} 2070 -1430 0 0 {name=p16 lab=VCC}
C {devices/lab_pin.sym} 2070 -960 0 0 {name=p17 lab=VSSI}
C {devices/lab_pin.sym} 1960 -1330 0 0 {name=l8 lab=ZERO2}
C {devices/ammeter.sym} 2100 -1030 0 0 {name=v5}
C {devices/lab_pin.sym} 2210 -820 0 1 {name=p18 lab=VCC}
C {devices/lab_pin.sym} 2150 -900 0 0 {name=p19 lab=VCC}
C {devices/lab_pin.sym} 2140 -820 0 0 {name=l2 lab=EN}
C {devices/lab_pin.sym} 590 -780 0 0 {name=p20 lab=VCC}
C {devices/lab_pin.sym} 450 -780 0 1 {name=p21 lab=VCC}
C {devices/lab_pin.sym} 390 -650 0 0 {name=p22 lab=VSS}
C {devices/lab_pin.sym} 650 -650 0 1 {name=p23 lab=VSS}
C {devices/lab_pin.sym} 490 -560 0 0 {name=p24 lab=VSSI}
C {devices/lab_pin.sym} 560 -920 0 1 {name=p25 lab=VCC}
C {devices/lab_pin.sym} 530 -980 0 0 {name=p26 lab=VCC}
C {devices/lab_pin.sym} 490 -920 0 0 {name=l7 lab=VSS}
C {devices/lab_pin.sym} 460 -690 0 1 {name=l9 lab=GP}
C {devices/lab_pin.sym} 380 -780 0 0 {name=l10 lab=MINUS}
C {devices/lab_pin.sym} 660 -780 0 1 {name=l11 lab=PLUS}
C {devices/lab_pin.sym} 680 -710 0 1 {name=l12 lab=OUTDIFF}
C {devices/parax_cap.sym} 500 -640 0 0 {name=C7  value=4f}
C {devices/lab_pin.sym} 530 -870 0 0 {name=l13 lab=SP}
C {devices/launcher.sym} 910 -270 0 0 {name=h2 
descr="Simulate" 
tclcommand="xschem netlist; xschem simulate"}
C {sky130_tests/not.sym} 160 -710 0 0 {name=x4 m=1 
+ W_N=1 L_N=0.15 W_P=2 L_P=0.15 
+ VCCPIN=VCC VSSPIN=VSS}
C {sky130_tests/not.sym} 160 -580 0 0 {name=x5 m=1 
+ W_N=1 L_N=0.15 W_P=2 L_P=0.15 
+ VCCPIN=VCC VSSPIN=VSS}
C {sky130_fd_pr/pfet_01v8.sym} 510 -920 0 0 {name=M4
L=1
W=0.55
ad="'W * 0.29'" pd="'W + 2 * 0.29'"
as="'W * 0.29'" ps="'W + 2 * 0.29'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8_lvt.sym} 1070 -810 0 0 {name=M5
L=1
W=1
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8_lvt.sym} 910 -810 0 1 {name=M6
L=1
W=1
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8_lvt.sym} 1450 -810 0 0 {name=M8
L=1
W=1
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8_lvt.sym} 1940 -810 0 0 {name=M9
L=1
W=1
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8.sym} 2160 -820 0 0 {name=M11
L=0.15
W=1
ad="'W * 0.29'" pd="'W + 2 * 0.29'"
as="'W * 0.29'" ps="'W + 2 * 0.29'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8_lvt.sym} 2080 -1350 0 0 {name=M12
L=1
W=0.42
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8_lvt.sym} 1590 -1350 0 0 {name=M13
L=1
W=0.42
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8_lvt.sym} 1100 -1350 0 0 {name=M14
L=1
W=0.42
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8.sym} 270 -1090 0 0 {name=M1
L=0.15
W=1
ad="'W * 0.29'" pd="'W + 2 * 0.29'"
as="'W * 0.29'" ps="'W + 2 * 0.29'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=2
model=nfet_01v8
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 1100 -1100 0 0 {name=M2
L=1
W=0.42
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 1590 -1100 0 0 {name=M3
L=1
W=0.42
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 2080 -1100 0 0 {name=M7
L=1
W=0.42
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 1940 -520 0 0 {name=M15
L=1
W=1
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 1450 -520 0 0 {name=M10
L=1
W=1
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 970 -520 0 0 {name=M17
L=1
W=0.42
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 600 -650 0 0 {name=M18
L=1
W=1
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 440 -650 0 1 {name=M19
L=1
W=1
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8_lvt.sym} 640 -780 0 1 {name=M20
L=0.35
W=1
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8_lvt.sym} 400 -780 0 0 {name=M21
L=0.35
W=1
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 1110 -650 0 1 {name=M23
L=0.25
W=1
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 870 -650 0 0 {name=M16
L=0.25
W=1
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_tests/passgate_nlvt.sym} 860 -1270 0 1 {name=x1 m=1
W_N=0.42 L_N=0.15
W_P=0.42 L_P=0.15
ad=0.12 as=0.12 pd=0.9 ps=0.9
VCCBPIN=VCC VSSBPIN=VSS nf=1 }
C {sky130_tests/passgate_nlvt.sym} 1350 -1270 0 1 {name=x2 m=1
W_N=0.42 L_N=0.15
W_P=0.42 L_P=0.15
ad=0.12 as=0.12 pd=0.9 ps=0.9
VCCBPIN=VCC VSSBPIN=VSS nf=1 }
C {sky130_tests/passgate_nlvt.sym} 1840 -1270 0 1 {name=x3 m=1
W_N=0.42 L_N=0.15
W_P=0.42 L_P=0.15
ad=0.12 as=0.12 pd=0.9 ps=0.9
VCCBPIN=VCC VSSBPIN=VSS nf=1 }
C {devices/capa.sym} 980 -1070 0 0 {name=C2
m=1
value=15f
footprint=1206
device="ceramic capacitor"}
C {devices/lab_pin.sym} 950 -1020 0 0 {name=p5 lab=VCC}
C {devices/capa.sym} 1470 -1070 0 0 {name=C4
m=1
value=15f
footprint=1206
device="ceramic capacitor"}
C {devices/lab_pin.sym} 1440 -1020 0 0 {name=p6 lab=VCC}
C {devices/capa.sym} 1960 -1070 0 0 {name=C6
m=1
value=15f
footprint=1206
device="ceramic capacitor"}
C {devices/lab_pin.sym} 1930 -1020 0 0 {name=p7 lab=VCC}
C {devices/launcher.sym} 1150 -310 0 0 {name=h3
descr="Load file into gaw" 
comment="
  This launcher gets raw filename from current schematic using 'xschem get schname'
  and stripping off path and suffix.  It then loads raw file into gaw.
  This allow to use it in any schematic without changes.
"
tclcommand="
set rawfile [file tail [file rootname [xschem get schname]]].raw
gaw_cmd \\"tabledel $rawfile
load $netlist_dir/$rawfile
table_set $rawfile\\"
unset rawfile"
}
C {devices/code.sym} 720 -160 0 0 {name=TT_MODELS
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
