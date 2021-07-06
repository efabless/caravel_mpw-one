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
N 790 -460 820 -460 {lab=VCC}
N 550 -460 580 -460 {lab=VCC}
N 520 -290 550 -290 {lab=VSS}
N 820 -290 850 -290 {lab=VSS}
N 590 -340 590 -290 {lab=G1}
N 550 -340 590 -340 {lab=G1}
N 550 -370 550 -340 {lab=G1}
N 820 -260 820 -200 {lab=VSS}
N 550 -260 550 -200 {lab=VSS}
N 680 -740 710 -740 {lab=VCC}
N 680 -800 680 -770 {lab=VCC}
N 550 -200 820 -200 {lab=VSS}
N 550 -340 550 -320 { lab=G1}
N 680 -590 820 -590 {lab=SP}
N 1450 -370 1480 -370 {lab=VSS}
N 1600 -520 1670 -520 {lab=DIFFOUT}
N 820 -590 820 -550 { lab=SP}
N 550 -590 550 -550 { lab=SP}
N 820 -430 820 -370 {lab=G2}
N 1450 -900 1450 -870 {lab=VCC}
N 1450 -430 1450 -400 { lab=DIFFOUT}
N 340 -460 370 -460 {lab=VCC}
N 340 -430 340 -370 { lab=G1}
N 340 -590 340 -550 { lab=SP}
N 1450 -340 1450 -260 { lab=#net1}
N 680 -650 680 -590 { lab=SP}
N 550 -590 680 -590 {lab=SP}
N 1600 -300 1630 -300 {lab=VSS}
N 1600 -520 1600 -330 { lab=DIFFOUT}
N 1450 -520 1600 -520 {lab=DIFFOUT}
N 1600 -270 1600 -200 { lab=VSS}
N 340 -590 550 -590 { lab=SP}
N 340 -370 550 -370 { lab=G1}
N 550 -430 550 -370 {lab=G1}
N 950 -910 980 -910 {lab=VCC}
N 950 -970 950 -940 {lab=VCC}
N 950 -830 980 -830 {lab=VCC}
N 950 -880 950 -860 { lab=#net2}
N 950 -730 980 -730 {lab=VSS}
N 950 -770 950 -760 { lab=#net3}
N 950 -800 950 -770 { lab=#net3}
N 910 -830 910 -730 { lab=ADJ}
N 950 -650 980 -650 {lab=VSS}
N 950 -620 950 -610 { lab=VSS}
N 820 -200 1600 -200 { lab=VSS}
N 950 -700 950 -680 { lab=#net4}
N 950 -770 1090 -770 { lab=#net3}
N 1130 -830 1130 -800 { lab=START}
N 1130 -740 1130 -710 { lab=START_N}
N 1170 -770 1210 -770 { lab=G2}
N 1210 -770 1210 -370 { lab=G2}
N 820 -370 1210 -370 { lab=G2}
N 820 -370 820 -320 {lab=G2}
N 1350 -720 1410 -720 { lab=EN_N}
N 1450 -720 1480 -720 {lab=VCC}
N 1450 -810 1450 -750 { lab=#net5}
N 590 -290 780 -290 { lab=G1}
N 1450 -690 1450 -520 { lab=DIFFOUT}
N 1210 -370 1410 -370 { lab=G2}
N 1450 -520 1450 -430 { lab=DIFFOUT}
N 1300 -460 1300 -430 { lab=#net6}
N 1300 -560 1300 -520 { lab=DIFFOUT}
N 1300 -560 1450 -560 { lab=DIFFOUT}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/ipin.sym} 100 -520 0 0 { name=p93 lab=PLUS }
C {devices/ipin.sym} 100 -540 0 0 { name=p94 lab=MINUS }
C {devices/ipin.sym} 100 -580 0 0 { name=p95 lab=EN_N }
C {devices/ipin.sym} 100 -430 0 0 { name=p96 lab=VSS }
C {devices/ipin.sym} 100 -460 0 0 { name=p97 lab=VCC }
C {devices/opin.sym} 140 -550 0 0 { name=p116 lab=DIFFOUT }
C {devices/code.sym} 40 -370 0 0 {name=STIMULI 
only_toplevel=true
place=end
value="* .option SCALE=1e-6 
.option method=gear seed=12

* this experimental option enables mos model bin 
* selection based on W/NF instead of W
.option wnflag=1 

.param VCC=1.6
* .param VCCGAUSS=agauss(1.8, 0.05, 1)
* .param VCC=VCCGAUSS
.param VDL=0.7
.param ABSVAR=0.0
.temp 25

** to generate following file: 
** copy .../xschem_sky130/sky130_tests/stimuli.test_comparator to simulation directory
** then do 'Simulation->Utile Stimuli Editor (GUI)' and press 'Translate'
.include \\"stimuli_bandgap_opamp.cir\\"

** variation marameters:
* .param sky130_fd_pr__nfet_01v8_lvt__vth0_slope_spectre='agauss(0, ABSVAR, 3)/sky130_fd_pr__nfet_01v8_lvt__vth0_slope'
* .param sky130_fd_pr__pfet_01v8_lvt__vth0_slope_spectre='agauss(0, ABSVAR, 3)/sky130_fd_pr__pfet_01v8_lvt__vth0_slope'

* .tran 0.1n 900n uic

.control
  let run=1
  dowhile run <= 1
    if run > 1
      reset
      set appendwrite
    end
    save all
    * save saout cal i(vvcc) en plus minus
    tran 1n 10000n uic
    plot diffout
    plot plus minus
    write bandgap_opamp.raw
    let run = run + 1
  end
.endc
"}
C {devices/lab_pin.sym} 790 -460 0 0 {name=p20 lab=VCC}
C {devices/lab_pin.sym} 580 -460 0 1 {name=p21 lab=VCC}
C {devices/lab_pin.sym} 520 -290 0 0 {name=p22 lab=VSS}
C {devices/lab_pin.sym} 850 -290 0 1 {name=p23 lab=VSS}
C {devices/lab_pin.sym} 550 -200 0 0 {name=p24 lab=VSS}
C {devices/lab_pin.sym} 710 -740 0 1 {name=p25 lab=VCC}
C {devices/lab_pin.sym} 680 -800 0 0 {name=p26 lab=VCC}
C {devices/lab_pin.sym} 640 -740 0 0 {name=l9 lab=EN_N}
C {devices/lab_pin.sym} 510 -460 0 0 {name=l11 lab=MINUS}
C {devices/lab_pin.sym} 860 -460 0 1 {name=l12 lab=PLUS}
C {devices/parax_cap.sym} 540 -410 1 0 {name=C6  value=2f}
C {devices/lab_pin.sym} 680 -610 0 0 {name=l14 lab=SP}
C {sky130_fd_pr/pfet_01v8.sym} 660 -740 0 0 {name=M4
L=6
W=2
ad="'W * 0.29'" pd="'W + 2 * 0.29'"
as="'W * 0.29'" ps="'W + 2 * 0.29'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 800 -290 0 0 {name=M18
L=4
W=6
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 570 -290 0 1 {name=M2
L=4
W=6
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8_lvt.sym} 840 -460 0 1 {name=M20
L=1
W=4
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8_lvt.sym} 530 -460 0 0 {name=M6
L=1
W=4
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {devices/launcher.sym} 240 -90 0 0 {name=h3
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
C {devices/code.sym} 40 -190 0 0 {name=TT_MODELS
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
C {devices/lab_pin.sym} 590 -340 0 1 {name=l3 lab=G1}
C {devices/ammeter.sym} 550 -520 0 0 {name=v1}
C {devices/parax_cap.sym} 770 -580 0 0 {name=C4  value=2f}
C {devices/parax_cap.sym} 830 -410 3 1 {name=C1  value=2f}
C {devices/lab_pin.sym} 1480 -370 0 1 {name=p2 lab=VSS}
C {devices/lab_pin.sym} 1670 -520 0 1 {name=l10 lab=DIFFOUT}
C {devices/parax_cap.sym} 1520 -510 0 0 {name=C5  value=4f}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 1430 -370 0 0 {name=M11
L=3
W=6
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=4
model=nfet_01v8_lvt
spiceprefix=X
 }
C {devices/ammeter.sym} 820 -520 0 0 {name=v2}
C {devices/lab_pin.sym} 1450 -900 0 0 {name=p3 lab=VCC}
C {devices/lab_pin.sym} 1350 -720 0 0 {name=l2 lab=EN_N}
C {devices/lab_pin.sym} 370 -460 0 1 {name=p4 lab=VCC}
C {devices/lab_pin.sym} 300 -460 0 0 {name=l4 lab=DIFFOUT}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 320 -460 0 0 {name=M5
L=1
W=4
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {devices/ammeter.sym} 340 -520 0 1 {name=v3}
C {devices/ammeter.sym} 1450 -230 0 0 {name=v4}
C {devices/ammeter.sym} 1450 -840 0 0 {name=v5}
C {devices/ammeter.sym} 680 -680 0 0 {name=v6}
C {devices/lab_pin.sym} 820 -340 0 1 {name=l5 lab=G2}
C {devices/lab_pin.sym} 1630 -300 0 1 {name=p5 lab=VSS}
C {sky130_fd_pr/nfet_01v8.sym} 1580 -300 0 0 {name=M7
L=0.15
W=0.5
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=3
model=nfet_01v8
spiceprefix=X
 }
C {devices/lab_pin.sym} 1560 -300 0 0 {name=l6 lab=EN_N}
C {devices/lab_pin.sym} 980 -910 0 1 {name=p6 lab=VCC}
C {devices/lab_pin.sym} 950 -970 0 0 {name=p7 lab=VCC}
C {devices/lab_pin.sym} 910 -910 0 0 {name=l7 lab=EN_N}
C {sky130_fd_pr/pfet_01v8.sym} 930 -910 0 0 {name=M1
L=6
W=1
ad="'W * 0.29'" pd="'W + 2 * 0.29'"
as="'W * 0.29'" ps="'W + 2 * 0.29'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8
spiceprefix=X
 }
C {devices/lab_pin.sym} 980 -830 0 1 {name=p8 lab=VCC}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 930 -830 0 0 {name=M8
L=1
W=1
ad="'W * 0.29'" pd="'W + 2 * 0.29'"
as="'W * 0.29'" ps="'W + 2 * 0.29'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {devices/lab_pin.sym} 980 -730 0 1 {name=p9 lab=VSS}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 930 -730 0 0 {name=M9
L=1
W=0.5
ad="'W * 0.29'" pd="'W + 2 * 0.29'"
as="'W * 0.29'" ps="'W + 2 * 0.29'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {devices/lab_pin.sym} 980 -650 0 1 {name=p10 lab=VSS}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 930 -650 0 0 {name=M10
L=6
W=0.5
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {devices/lab_pin.sym} 910 -800 0 0 {name=l8 lab=ADJ}
C {devices/lab_pin.sym} 910 -650 0 0 {name=p11 lab=VCC}
C {devices/ipin.sym} 100 -480 0 0 { name=p12 lab=ADJ }
C {sky130_tests/not.sym} 260 -780 0 0 {name=x1 m=1 VCCPIN=VCC VSSPIN=VSS W_N=1 L_N=0.15 W_P=2 L_P=0.15}
C {devices/lab_pin.sym} 220 -780 0 0 {name=p15 lab=START}
C {devices/lab_pin.sym} 300 -780 0 1 {name=p16 lab=START_N}
C {devices/lab_pin.sym} 1130 -830 0 0 {name=p17 lab=START}
C {devices/lab_pin.sym} 1130 -710 0 0 {name=p18 lab=START_N}
C {devices/ipin.sym} 100 -500 0 0 { name=p19 lab=START }
C {devices/lab_pin.sym} 950 -610 0 0 {name=p27 lab=VSS}
C {sky130_tests/passgate_nlvt.sym} 1130 -770 0 0 {name=x3 W_N=1 L_N=0.35 W_P=1 L_P=0.35 
    
VCCBPIN=VCC VSSBPIN=VSS  m=1}
C {devices/lab_pin.sym} 1480 -720 0 1 {name=p29 lab=VCC}
C {devices/launcher.sym} 240 -150 0 0 {name=h2 
descr="Simulate" 
tclcommand="xschem netlist; xschem simulate"}
C {sky130_fd_pr/pfet_01v8.sym} 1430 -720 0 0 {name=M3
L=6
W=2
ad="'W * 0.29'" pd="'W + 2 * 0.29'"
as="'W * 0.29'" ps="'W + 2 * 0.29'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=2
model=pfet_01v8
spiceprefix=X
 }
C {sky130_fd_pr/cap_mim_m3_2.sym} 1300 -400 0 0 {name=C2 model=cap_mim_m3_2 W=5 L=5 MF=8 spiceprefix=X }
C {devices/lab_pin.sym} 1280 -490 0 0 {name=l16 sig_type=std_logic lab=VSS}
C {sky130_fd_pr/res_xhigh_po_0p69.sym} 1300 -490 0 0 {name=R5
W=0.69
L=5
model=res_xhigh_po_0p69
spiceprefix=X
mult=1 net_name=true}
