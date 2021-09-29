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
N 580 -450 610 -450 {lab=VCC}
N 340 -450 370 -450 {lab=VCC}
N 310 -280 340 -280 {lab=VSS}
N 610 -280 640 -280 {lab=VSS}
N 380 -330 380 -280 {lab=G1}
N 340 -330 380 -330 {lab=G1}
N 610 -250 610 -190 {lab=VSS}
N 340 -250 340 -190 {lab=VSS}
N 470 -730 500 -730 {lab=VCC}
N 470 -790 470 -760 {lab=VCC}
N 610 -330 610 -310 {lab=G2}
N 340 -190 610 -190 {lab=VSS}
N 340 -330 340 -310 { lab=G1}
N 470 -580 610 -580 {lab=SP}
N 1240 -360 1270 -360 {lab=VSS}
N 1390 -510 1460 -510 {lab=DIFFOUT}
N 610 -580 610 -540 { lab=SP}
N 340 -580 340 -540 { lab=SP}
N 610 -420 610 -360 {lab=G2}
N 1240 -510 1240 -390 { lab=DIFFOUT}
N 1240 -330 1240 -250 { lab=#net1}
N 470 -640 470 -580 { lab=SP}
N 340 -580 470 -580 {lab=SP}
N 1390 -290 1420 -290 {lab=VSS}
N 1390 -510 1390 -320 { lab=DIFFOUT}
N 1240 -510 1390 -510 {lab=DIFFOUT}
N 1390 -260 1390 -190 { lab=VSS}
N 340 -420 340 -330 {lab=G1}
N 610 -190 1390 -190 { lab=VSS}
N 610 -360 1200 -360 { lab=G2}
N 610 -360 610 -330 {lab=G2}
N 1240 -620 1240 -510 { lab=DIFFOUT}
N 1240 -830 1270 -830 {lab=VCC}
N 1240 -890 1240 -860 {lab=VCC}
N 1100 -550 1130 -550 {lab=VSS}
N 1070 -650 1100 -650 {lab=VCC}
N 1140 -650 1140 -620 { lab=#net2}
N 1100 -620 1140 -620 { lab=#net2}
N 1100 -620 1100 -580 { lab=#net2}
N 1140 -650 1200 -650 { lab=#net2}
N 1100 -740 1100 -680 { lab=#net3}
N 1100 -740 1240 -740 { lab=#net3}
N 1100 -520 1100 -500 { lab=VSS}
N 1240 -650 1270 -650 {lab=VCC}
N 1240 -740 1240 -680 { lab=#net3}
N 570 -330 570 -280 { lab=G2}
N 570 -330 610 -330 { lab=G2}
N 810 -720 840 -720 {lab=VCC}
N 810 -780 810 -750 {lab=VCC}
N 810 -640 840 -640 {lab=VCC}
N 810 -690 810 -670 { lab=#net4}
N 810 -540 840 -540 {lab=VSS}
N 810 -580 810 -570 { lab=G1}
N 810 -610 810 -580 { lab=G1}
N 770 -640 770 -540 { lab=ADJ}
N 810 -460 840 -460 {lab=VSS}
N 810 -430 810 -420 { lab=VSS}
N 810 -510 810 -490 { lab=#net5}
N 810 -580 950 -580 { lab=G1}
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

.param VCC=1.8
* .param VCCGAUSS=agauss(1.8, 0.05, 1)
* .param VCC=VCCGAUSS
.param VDL=0.7
.param ABSVAR=0.02
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
    plot saout
    plot plus minus
    write bandgap_opamp.raw
    let run = run + 1
  end
.endc
"}
C {devices/lab_pin.sym} 580 -450 0 0 {name=p20 lab=VCC}
C {devices/lab_pin.sym} 370 -450 0 1 {name=p21 lab=VCC}
C {devices/lab_pin.sym} 310 -280 0 0 {name=p22 lab=VSS}
C {devices/lab_pin.sym} 640 -280 0 1 {name=p23 lab=VSS}
C {devices/lab_pin.sym} 340 -190 0 0 {name=p24 lab=VSS}
C {devices/lab_pin.sym} 500 -730 0 1 {name=p25 lab=VCC}
C {devices/lab_pin.sym} 470 -790 0 0 {name=p26 lab=VCC}
C {devices/lab_pin.sym} 430 -730 0 0 {name=l9 lab=EN_N}
C {devices/lab_pin.sym} 300 -450 0 0 {name=l11 lab=MINUS}
C {devices/lab_pin.sym} 650 -450 0 1 {name=l12 lab=PLUS}
C {devices/parax_cap.sym} 330 -400 1 0 {name=C6  value=2f}
C {devices/lab_pin.sym} 470 -600 0 0 {name=l14 lab=SP}
C {sky130_fd_pr/pfet_01v8.sym} 450 -730 0 0 {name=M4
L=8
W=2
ad="'W * 0.29'" pd="'W + 2 * 0.29'"
as="'W * 0.29'" ps="'W + 2 * 0.29'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 590 -280 0 0 {name=M18
L=4
W=2
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 360 -280 0 1 {name=M2
L=4
W=2
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {sky130_fd_pr/pfet_01v8_lvt.sym} 630 -450 0 1 {name=M20
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
C {sky130_fd_pr/pfet_01v8_lvt.sym} 320 -450 0 0 {name=M6
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
C {devices/lab_pin.sym} 380 -330 0 1 {name=l3 lab=G1}
C {devices/ammeter.sym} 340 -510 0 0 {name=v1}
C {devices/parax_cap.sym} 560 -570 0 0 {name=C4  value=2f}
C {devices/parax_cap.sym} 620 -400 3 1 {name=C1  value=2f}
C {devices/lab_pin.sym} 1270 -360 0 1 {name=p2 lab=VSS}
C {devices/lab_pin.sym} 1460 -510 0 1 {name=l10 lab=DIFFOUT}
C {devices/parax_cap.sym} 1310 -500 0 0 {name=C5  value=4f}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 1220 -360 0 0 {name=M11
L=4
W=2
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {devices/ammeter.sym} 610 -510 0 0 {name=v2}
C {devices/ammeter.sym} 1240 -220 0 0 {name=v4}
C {devices/ammeter.sym} 470 -670 0 0 {name=v6}
C {devices/lab_pin.sym} 610 -330 0 1 {name=l5 lab=G2}
C {devices/lab_pin.sym} 1420 -290 0 1 {name=p5 lab=VSS}
C {sky130_fd_pr/nfet_01v8.sym} 1370 -290 0 0 {name=M7
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
C {devices/lab_pin.sym} 1350 -290 0 0 {name=l6 lab=EN_N}
C {devices/ipin.sym} 100 -480 0 0 { name=p12 lab=ADJ }
C {devices/lab_pin.sym} 950 -580 0 1 {name=l4 lab=G1}
C {devices/lab_pin.sym} 1270 -830 0 1 {name=p123 lab=VCC}
C {devices/lab_pin.sym} 1240 -890 0 0 {name=p124 lab=VCC}
C {devices/lab_pin.sym} 1200 -830 0 0 {name=l65 lab=EN_N}
C {sky130_fd_pr/pfet_01v8.sym} 1220 -830 0 0 {name=M46
L=0.15
W=5
ad="'W * 0.29'" pd="'W + 2 * 0.29'"
as="'W * 0.29'" ps="'W + 2 * 0.29'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8
spiceprefix=X
 }
C {devices/ammeter.sym} 1240 -770 0 0 {name=v17}
C {devices/lab_pin.sym} 1130 -550 0 1 {name=p141 lab=VSS}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 1080 -550 0 0 {name=M53
L=4
W=2
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {devices/lab_pin.sym} 1060 -550 0 0 {name=l71 lab=G1}
C {devices/lab_pin.sym} 1070 -650 0 0 {name=p142 lab=VCC}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 1120 -650 0 1 {name=M54
L=4
W=4
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {devices/lab_pin.sym} 1100 -500 0 0 {name=p143 lab=VSS}
C {devices/lab_pin.sym} 1270 -650 0 1 {name=p144 lab=VCC}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 1220 -650 0 0 {name=M55
L=4
W=4
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8_lvt
spiceprefix=X
 }
C {devices/lab_pin.sym} 840 -720 0 1 {name=p6 lab=VCC}
C {devices/lab_pin.sym} 810 -780 0 0 {name=p7 lab=VCC}
C {devices/lab_pin.sym} 770 -720 0 0 {name=l7 lab=EN_N}
C {devices/lab_pin.sym} 840 -640 0 1 {name=p8 lab=VCC}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 790 -640 0 0 {name=M8
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
C {devices/lab_pin.sym} 840 -540 0 1 {name=p9 lab=VSS}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 790 -540 0 0 {name=M9
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
C {devices/lab_pin.sym} 840 -460 0 1 {name=p10 lab=VSS}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 790 -460 0 0 {name=M10
L=8
W=0.5
ad="'W * 0.29'" pd="'2*(W + 0.29)'"
as="'W * 0.29'" ps="'2*(W + 0.29)'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
 }
C {devices/lab_pin.sym} 770 -610 0 0 {name=l8 lab=ADJ}
C {devices/lab_pin.sym} 770 -460 0 0 {name=p11 lab=VCC}
C {devices/lab_pin.sym} 810 -420 0 0 {name=p27 lab=VSS}
C {sky130_fd_pr/pfet_01v8.sym} 790 -720 0 0 {name=M1
L=8
W=1
ad="'W * 0.29'" pd="'W + 2 * 0.29'"
as="'W * 0.29'" ps="'W + 2 * 0.29'"
nrd=0 nrs=0
sa=0 sb=0 sd=0
nf=1 mult=1
model=pfet_01v8
spiceprefix=X
 }
