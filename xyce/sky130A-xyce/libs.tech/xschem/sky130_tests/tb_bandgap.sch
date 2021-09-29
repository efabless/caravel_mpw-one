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
N 240 -340 240 -320 { lab=EN_N}
N 740 -340 740 -320 { lab=VCC}
N 480 -340 480 -320 { lab=VSS}
N 240 -220 240 -200 {lab=TEMPERAT}
N 480 -220 480 -200 { lab=START}
N 740 -220 740 -200 { lab=CLK}
C {devices/code.sym} 10 -450 0 0 {name=NGSPICE
only_toplevel=true
value=".option seed=13

* this experimental option enables mos model bin 
* selection based on W/NF instead of W
.options wnflag=1 XMU=0.49 METHOD=GEAR ITL4=100 CHGTOL=1e-15 TRTOL=1 RELTOL=0.0001 VNTOL=0.1u
.param ABSVAR=0.03
.param VCCGAUSS=agauss(1.8, 'ABSVAR', 1)
.param VCC=VCCGAUSS
* .param VCC=1.8
** variation marameters:
.param sky130_fd_pr__nfet_01v8_lvt__vth0_slope_spectre='agauss(0, ABSVAR, 3)/sky130_fd_pr__nfet_01v8_lvt__vth0_slope'
.param sky130_fd_pr__pfet_01v8_lvt__vth0_slope_spectre='agauss(0, ABSVAR, 3)/sky130_fd_pr__pfet_01v8_lvt__vth0_slope'
.param sky130_fd_pr__nfet_01v8__vth0_slope_spectre='agauss(0, ABSVAR, 3)/sky130_fd_pr__nfet_01v8__vth0_slope'
.param sky130_fd_pr__pfet_01v8__vth0_slope_spectre='agauss(0, ABSVAR, 3)/sky130_fd_pr__pfet_01v8__vth0_slope'

.param sky130_fd_pr__pfet_01v8__toxe_slope_spectre='agauss(0, ABSVAR*2, 3)/sky130_fd_pr__pfet_01v8__toxe_slope'
.param sky130_fd_pr__nfet_01v8__toxe_slope_spectre='agauss(0, ABSVAR*2, 3)/sky130_fd_pr__nfet_01v8__toxe_slope'
.param sky130_fd_pr__pfet_01v8_lvt__toxe_slope_spectre='agauss(0, ABSVAR*2, 3)/sky130_fd_pr__pfet_01v8_lvt__toxe_slope'
.param sky130_fd_pr__nfet_01v8_lvt__toxe_slope_spectre='agauss(0, ABSVAR*2, 3)/sky130_fd_pr__nfet_01v8_lvt__toxe_slope'

.param sky130_fd_pr__res_high_po__var_mult=agauss(0, 'ABSVAR*8', 1)

* .options savecurrents
.control
  let run=1
  dowhile run <= 40
    if run > 1
      reset
      set appendwrite
    end
    * save vbg x1.plus x1.minus i(v2) vcc
    save all
    if run % 3 = 0
      set temp=-40
    end
    if run % 3 = 1
      set temp=27
    end
    if run % 3 = 2
      set temp=125
    end
    tran 0.05u 150u
    write tb_bandgap.raw
    let run = run + 1
  end
  set nolegend
  plot all.vbg
.endc
" }
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {sky130_tests/bandgap.sym} 410 -490 0 0 {name=x1}
C {devices/lab_pin.sym} 560 -530 0 1 {name=p1 lab=VBG}
C {devices/lab_pin.sym} 260 -490 0 0 {name=p2 lab=EN_N}
C {devices/vsource.sym} 240 -290 0 0 {name=V1 value=0}
C {devices/lab_pin.sym} 240 -340 0 1 {name=p3 lab=EN_N}
C {devices/code.sym} 10 -250 0 0 {name=TT_MODELS
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
C {devices/vsource.sym} 740 -290 0 0 {name=V2 value="pwl 0 0 1u 0 4u VCC"}
C {devices/lab_pin.sym} 740 -340 0 1 {name=l29 sig_type=std_logic lab=VCC}
C {devices/lab_pin.sym} 260 -470 0 0 {name=p4 lab=VCC}
C {devices/lab_pin.sym} 260 -450 0 0 {name=p5 lab=VSS}
C {devices/vsource.sym} 480 -290 0 0 {name=V3 value=0}
C {devices/lab_pin.sym} 480 -340 0 1 {name=l3 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 240 -260 0 0 {name=l2 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 740 -260 0 0 {name=l4 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 480 -260 0 0 {name=l5 sig_type=std_logic lab=0}
C {devices/launcher.sym} 200 -90 0 0 {name=h2 
descr="Simulate" 
tclcommand="xschem netlist; xschem simulate"}
C {devices/vsource_arith.sym} 240 -170 0 0 {name=E5 VOL=temper MAX=200 MIN=-200}
C {devices/lab_pin.sym} 240 -220 0 1 {name=p113 lab=TEMPERAT}
C {devices/lab_pin.sym} 240 -140 0 0 {name=p114 lab=VSS}
C {devices/vsource.sym} 480 -170 0 0 {name=V4 value="pwl 0 VCC 25u VCC 25.001u 0"}
C {devices/lab_pin.sym} 480 -220 0 1 {name=p7 lab=START}
C {devices/lab_pin.sym} 480 -140 0 0 {name=l21 sig_type=std_logic lab=VSS}
C {devices/vsource.sym} 740 -170 0 0 {name=V5
value1="dc 0 "
value="dc 0 pulse VCC 0 25u 1n 1n 27000n 30000n"}
C {devices/lab_pin.sym} 740 -140 0 0 {name=l6 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 740 -220 0 1 {name=p6 lab=CLK}
C {devices/lab_pin.sym} 260 -530 0 0 {name=p8 lab=START}
C {devices/lab_pin.sym} 260 -510 0 0 {name=p9 lab=CLK}
