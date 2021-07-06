v {xschem version=2.9.9 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
T {Transistor ft measurement} 130 -590 0 0 0.8 0.8 {}
N 220 -480 400 -480 { lab=D}
N 30 -480 30 -360 { lab=D}
N 30 -300 30 -110 { lab=GND}
N 400 -320 430 -320 { lab=GND}
N 430 -320 430 -270 { lab=GND}
N 400 -270 430 -270 { lab=GND}
N 220 -150 220 -110 { lab=GND}
N 400 -290 400 -110 { lab=GND}
N 190 -320 220 -320 { lab=GND}
N 190 -320 190 -270 { lab=GND}
N 190 -270 220 -270 { lab=GND}
N 220 -290 220 -210 { lab=GND}
N 220 -400 220 -350 { lab=G}
N 400 -480 400 -350 { lab=D}
N 260 -320 360 -320 { lab=G}
N 220 -370 290 -370 { lab=G}
N 290 -370 290 -320 { lab=G}
N 30 -110 400 -110 { lab=GND}
N 220 -480 220 -460 { lab=D}
N 220 -210 220 -150 { lab=GND}
N 30 -480 220 -480 { lab=D}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 380 -320 0 0 {name=M1
L=0.15
W=10
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {devices/vsource.sym} 30 -330 0 0 {name=VDS value=1.5}
C {devices/isource.sym} 220 -430 0 0 {name=Idref value=1}
C {devices/gnd.sym} 400 -110 0 0 {name=l1 lab=GND}
C {devices/code.sym} 530 -350 0 0 {name=SIMULATION
only_toplevel=false 
value="

.options filetype=ascii
.save all

.op
.control
*dc Idref 0.1e-3 10e-3 0.1e-3

let n_idx = 101

let start_iref = 0.1e-3
let stop_iref = 10e-3
let delta_iref = (stop_iref - start_iref) / n_idx
let iref_act = start_iref

let vgs = unitvec(n_idx)
let gms = unitvec(n_idx)
let ids = unitvec(n_idx)

let cgss = unitvec(n_idx)
let cgds = unitvec(n_idx)

let idxs = 0
let idx = idxs

*loop
while iref_act le stop_iref
  alter idref iref_act
  run
  *print @m.xm2.msky130_fd_pr__nfet_01v8_lvt[gm]

  let gms[idx] = @m.xm2.msky130_fd_pr__nfet_01v8_lvt[gm]
  let ids[idx] = @m.xm2.msky130_fd_pr__nfet_01v8_lvt[id]

  let cgss[idx] = @m.xm2.msky130_fd_pr__nfet_01v8_lvt[cgs]
  let cgds[idx] = @m.xm2.msky130_fd_pr__nfet_01v8_lvt[cgd]
  let vgs[idx] = v(G)

  let iref_act = iref_act + delta_iref
  let idxs = idx + 1
  let idx = idxs
end

let ft = -gms/(2*pi*(cgss+cgds))
settype voltage vgs
settype current ids
setscale ids
plot gms vs ids
plot xlog ft vs ids
plot xlog vgs vs ids

.endc
.end
"}
C {devices/lab_wire.sym} 90 -480 0 0 {name=l2 sig_type=std_logic lab=D}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 240 -320 0 1 {name=M2
L=0.15
W=10
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {devices/code.sym} 530 -180 0 0 {name=TT_MODELS
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
C {devices/lab_wire.sym} 320 -320 0 0 {name=l3 sig_type=std_logic lab=G}
C {devices/title.sym} 160 -30 0 0 {name=l4 author="Rafael Marinho"}
