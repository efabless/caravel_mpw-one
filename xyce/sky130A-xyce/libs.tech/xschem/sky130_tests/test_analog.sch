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
L 4 50 -510 50 -210 {}
P 4 6 690 -460 650 -460 650 -450 630 -460 650 -470 650 -460 {}
P 4 6 50 -490 90 -490 90 -480 110 -490 90 -500 90 -490 {}
P 4 6 50 -210 90 -210 90 -200 110 -210 90 -220 90 -210 {}
T {Annotate launcher works by fetching data
from the .raw file of the top most schematic
where presumably simulation has been run.
If this is not the case open this schematic 
as the top level cell (File -> Open) and 
run simulation at *this* level} 740 -320 0 0 0.2 0.2 {layer=4}
T {This will display the raw file of the top
most schematic where presumably simulation
has been run} 740 -170 0 0 0.2 0.2 {layer=4}
T {Test schematic showing how to annotate operating point data} 40 -810 0 0 0.7 0.7 {}
T {x1 and x2 instances are the same subcircuit,
however the backannotated data is different 
in each instance since bias points are 
different. Descend into them and verify
the annotations in x1 are different from those
in x2.

You can also simulate n_diffamp alone as a top cell
and verify annotators work without any change 
with n_diffamp.raw} 700 -520 0 0 0.2 0.2 {layer=4}
T {Once this schematic is
annotated the subcircuits
will be automatically
annotated, each instance
with its pertaining data} 20 -580 0 0 0.2 0.2 {layer=4}
N 310 -120 310 -90 { lab=BIAS}
N 280 -90 310 -90 { lab=BIAS}
N 310 -400 310 -370 { lab=BIAS2}
N 280 -370 310 -370 { lab=BIAS2}
N 220 -240 250 -240 { lab=OUT}
N 120 -160 250 -160 { lab=IN}
N 460 -200 480 -200 { lab=OUT}
N 460 -480 480 -480 { lab=OUT2}
N 220 -300 430 -300 { lab=OUT}
N 430 -300 430 -200 { lab=OUT}
N 410 -200 430 -200 { lab=OUT}
N 220 -300 220 -240 { lab=OUT}
N 220 -520 250 -520 { lab=OUT2}
N 220 -580 430 -580 { lab=OUT2}
N 430 -580 430 -480 { lab=OUT2}
N 220 -580 220 -520 { lab=OUT2}
N 410 -480 430 -480 { lab=OUT2}
N 120 -440 250 -440 { lab=IN2}
N 90 -750 90 -720 { lab=IN}
N 90 -750 160 -750 { lab=IN}
N 550 -750 550 -720 { lab=BIAS}
N 550 -750 620 -750 { lab=BIAS}
N 340 -750 340 -720 { lab=IN2}
N 340 -750 410 -750 { lab=IN2}
N 740 -750 740 -720 { lab=BIAS2}
N 740 -750 810 -750 { lab=BIAS2}
N 460 -480 460 -450 { lab=OUT2}
N 460 -200 460 -170 { lab=OUT}
N 430 -480 460 -480 { lab=OUT2}
N 430 -200 460 -200 { lab=OUT}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/code.sym} 1050 -190 0 0 {name=STIMULI 
only_toplevel=true
place=end
value="

.options savecurrents
.control
save all
save @m.x1.xm5.msky130_fd_pr__nfet_01v8[gm]
save @m.x2.xm5.msky130_fd_pr__nfet_01v8[gm]
op
write test_analog.raw
.endc
"}
C {devices/code.sym} 1050 -360 0 0 {name=TT_MODELS
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
C {sky130_tests/n_diffamp.sym} 330 -200 0 0 {name=x1}
C {sky130_tests/n_diffamp.sym} 330 -480 0 0 {name=x2}
C {devices/lab_pin.sym} 280 -90 0 0 {name=l2 sig_type=std_logic lab=BIAS}
C {devices/lab_pin.sym} 280 -370 0 0 {name=l3 sig_type=std_logic lab=BIAS2}
C {devices/lab_pin.sym} 120 -160 0 0 {name=l5 sig_type=std_logic lab=IN}
C {devices/lab_pin.sym} 480 -200 0 1 {name=l6 sig_type=std_logic lab=OUT}
C {devices/lab_pin.sym} 120 -440 0 0 {name=l7 sig_type=std_logic lab=IN2}
C {devices/vsource.sym} 90 -690 0 0 {name=V1 value=1.2 net_name=true}
C {devices/gnd.sym} 90 -660 0 0 {name=l9 lab=GND}
C {devices/lab_pin.sym} 160 -750 0 1 {name=l10 sig_type=std_logic lab=IN}
C {devices/vsource.sym} 550 -690 0 0 {name=V2 value=1.1 net_name=true}
C {devices/gnd.sym} 550 -660 0 0 {name=l11 lab=GND}
C {devices/lab_pin.sym} 620 -750 0 1 {name=l12 sig_type=std_logic lab=BIAS}
C {devices/vsource.sym} 980 -690 0 0 {name=V3 value=1.8 net_name=true}
C {devices/gnd.sym} 980 -660 0 0 {name=l13 lab=GND}
C {devices/vdd.sym} 980 -720 0 0 {name=l14 lab=VDD}
C {devices/lab_pin.sym} 480 -480 0 1 {name=l4 sig_type=std_logic lab=OUT2}
C {devices/launcher.sym} 800 -210 0 0 {name=h1
descr=Annotate 
tclcommand="ngspice::annotate"}
C {devices/ngspice_probe.sym} 410 -580 0 0 {name=r1}
C {devices/ngspice_probe.sym} 410 -300 0 0 {name=r2}
C {devices/ngspice_probe.sym} 310 -90 0 0 {name=r3}
C {devices/ngspice_probe.sym} 150 -160 0 0 {name=r4}
C {devices/vsource.sym} 340 -690 0 0 {name=V4 value=1.0 net_name=true}
C {devices/gnd.sym} 340 -660 0 0 {name=l8 lab=GND}
C {devices/lab_pin.sym} 410 -750 0 1 {name=l15 sig_type=std_logic lab=IN2}
C {devices/ngspice_probe.sym} 160 -440 0 0 {name=r5}
C {devices/vsource.sym} 740 -690 0 0 {name=V5 value=1.0 net_name=true}
C {devices/gnd.sym} 740 -660 0 0 {name=l16 lab=GND}
C {devices/lab_pin.sym} 810 -750 0 1 {name=l17 sig_type=std_logic lab=BIAS2}
C {devices/ngspice_probe.sym} 310 -370 0 0 {name=r6}
C {devices/launcher.sym} 800 -100 0 0 {name=h2
descr="View Raw file" 
tclcommand="textwindow $netlist_dir/[file tail [file rootname [ xschem get schname 0 ] ] ].raw"
}
C {sky130_fd_pr/res_xhigh_po_0p35.sym} 460 -420 0 0 {name=R1
W=0.35
L=50
model=res_xhigh_po_0p35
spiceprefix=X
mult=1}
C {devices/gnd.sym} 460 -390 0 0 {name=l18 lab=GND}
C {devices/gnd.sym} 440 -420 0 1 {name=l19 lab=GND}
C {devices/ngspice_get_value.sym} 500 -370 0 0 {name=r7 node=i(@b.$\{path\}xr1.xsky130_fd_pr__res_xhigh_po_0p35.brbody[i])
descr="I="}
C {sky130_fd_pr/res_xhigh_po_0p35.sym} 460 -140 0 0 {name=R2
W=0.35
L=50
model=res_xhigh_po_0p35
spiceprefix=X
mult=1}
C {devices/gnd.sym} 460 -110 0 0 {name=l20 lab=GND}
C {devices/gnd.sym} 440 -140 0 1 {name=l21 lab=GND}
C {devices/ngspice_get_value.sym} 500 -90 0 0 {name=r9 node=i(@b.$\{path\}xr2.xsky130_fd_pr__res_xhigh_po_0p35.brbody[i])
descr="I="}
C {devices/ngspice_get_expr.sym} 950 -690 0 1 {name=r8 node="[ngspice::get_current v3]"}
