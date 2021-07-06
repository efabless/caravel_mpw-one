v {xschem version=2.9.9 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
T {Transistor ft measurement} 130 -780 0 0 0.8 0.8 {}
T {A transient simulation is done showing the
small signal current gain at 10GHz.

An AC simulation is done showing the current
gain vs frequency, to evaluate transistor ft.

Bias conditions: vds=1.5, vgs=1.0

ac/dc blockers are used to separate dc paths
from ac paths.} 690 -320 0 0 0.4 0.4 {}
T {Annotate launcher works by fetching data
from the .raw file of the top most schematic
where presumably simulation has been run.
If this is not the case open this schematic 
as the top level cell (File -> Open) and 
run simulation at *this* level} 760 -560 0 0 0.2 0.2 {layer=4}
T {This will display the raw file of the top
most schematic where presumably simulation
has been run} 760 -420 0 0 0.2 0.2 {layer=4}
T {RF transistor} 790 -720 0 0 0.4 0.4 {}
T {Standard LVT transistor} 1040 -720 0 0 0.4 0.4 {}
N 30 -590 30 -440 { lab=D}
N 30 -380 30 -190 { lab=GND}
N 400 -400 430 -400 { lab=#net1}
N 430 -290 430 -270 { lab=GND}
N 400 -270 430 -270 { lab=GND}
N 400 -270 400 -190 { lab=GND}
N 220 -190 400 -190 { lab=GND}
N 270 -590 400 -590 { lab=#net2}
N 320 -400 360 -400 { lab=#net3}
N 140 -310 140 -280 { lab=#net4}
N 140 -220 140 -190 { lab=GND}
N 140 -400 140 -370 { lab=G}
N 220 -220 220 -190 { lab=GND}
N 140 -400 220 -400 { lab=G}
N 220 -400 260 -400 { lab=G}
N 400 -370 400 -270 { lab=GND}
N 30 -190 140 -190 { lab=GND}
N 140 -190 220 -190 { lab=GND}
N 400 -590 480 -590 { lab=#net2}
N 480 -590 480 -580 { lab=#net2}
N 400 -460 480 -460 { lab=#net5}
N 220 -400 220 -370 { lab=G}
N 220 -310 220 -270 { lab=#net6}
N 400 -590 400 -580 { lab=#net2}
N 400 -460 400 -430 { lab=#net5}
N 30 -590 210 -590 { lab=D}
N 400 -520 400 -460 { lab=#net5}
N 430 -400 430 -350 { lab=#net1}
N 850 -680 850 -600 { lab=GND}
N 810 -600 850 -600 { lab=GND}
N 810 -650 810 -600 { lab=GND}
N 1140 -680 1140 -600 { lab=GND}
N 1100 -600 1140 -600 { lab=GND}
N 1100 -650 1100 -600 { lab=GND}
N 580 -680 580 -600 { lab=GND}
N 540 -600 580 -600 { lab=GND}
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
C {devices/vsource.sym} 30 -410 0 0 {name=VDS value=1.5}
C {devices/gnd.sym} 400 -190 0 0 {name=l1 lab=GND}
C {devices/code.sym} 530 -350 0 0 {name=SIMULATION
only_toplevel=false 
value="
* this experimental option enables mos model bin 
* selection based on W/NF instead of W
.option wnflag=1 
.options method=gear savecurrents
.save all

.control
  save all
* save @m.xm1.msky130_fd_pr__rf_nfet_01v8_lvt_bm02w5p00l0p18[gm]
  save @m.xm1.msky130_fd_pr__nfet_01v8_lvt[gm]

  op
  write tb_ft_test_2.raw
  tran 0.001n 2n
  set appendwrite
  write tb_ft_test_2.raw
  ac dec 10 1000 1000G
  set appendwrite
  write tb_ft_test_2.raw

  setplot tran1
  plot i(vg) i(vd)

  setplot ac1
  plot db(i(vd)/i(vg))
.endc

"}
C {devices/lab_wire.sym} 90 -590 0 0 {name=l2 sig_type=std_logic lab=D}
C {devices/title.sym} 160 -30 0 0 {name=l4 author="Rafael Marinho"}
C {devices/vsource.sym} 140 -250 0 0 {name=VGS value=1}
C {devices/lab_wire.sym} 190 -400 0 0 {name=l3 sig_type=std_logic lab=G}
C {devices/ammeter.sym} 480 -490 0 0 {name=Vd current=0.0000e+00}
C {devices/ind.sym} 140 -340 0 0 {name=L1
m=1
value=1m
footprint=1206
device=inductor}
C {devices/ammeter.sym} 290 -400 3 0 {name=Vg current=0.0000e+00}
C {devices/ind.sym} 400 -550 0 0 {name=L2
m=1
value=1m
footprint=1206
device=inductor}
C {devices/capa.sym} 480 -550 0 0 {name=C1
m=1
value=1m
footprint=1206
device="ceramic capacitor"}
C {devices/capa.sym} 220 -340 0 0 {name=C2
m=1
value=1m
footprint=1206
device="ceramic capacitor"}
C {devices/vsource.sym} 220 -250 0 0 {name=VGS1 value="ac 1 0 sin(0 0.01 10G)"}
C {devices/ngspice_get_value.sym} 390 -430 0 1 {name=r9 node=i(@m.xm1.msky130_fd_pr__nfet_01v8_lvt[id])
descr="I="}
C {devices/launcher.sym} 820 -450 0 0 {name=h1
descr=Annotate 
tclcommand="ngspice::annotate"}
C {devices/launcher.sym} 820 -350 0 0 {name=h2
descr="View Raw file" 
tclcommand="textwindow $netlist_dir/[file tail [file rootname [ xschem get schname 0 ] ] ].raw"
}
C {devices/ammeter.sym} 240 -590 3 1 {name=Vd_dc current=6.6592e-04}
C {devices/spice_probe.sym} 140 -400 0 1 {name=p1 attrs="" voltage=1}
C {devices/spice_probe.sym} 30 -490 0 0 {name=p2 attrs="" voltage=1.5}
C {devices/ngspice_get_value.sym} 380 -350 0 1 {name=r1 node=@m.xm1.msky130_fd_pr__nfet_01v8_lvt[gm]
descr="gm="}
C {devices/ammeter.sym} 430 -320 0 0 {name=Vb current=1.8163e-10}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 830 -650 0 0 {name=M2
L=0.18
W=5.05
nf=1
mult=1
ad=0
pd=0
as=0
ps=0
nrd=0 nrs=0
sa=0 sb=0 sd=0
model=rf_nfet_01v8_lvt_bM02W5p00L0p18
spiceprefix=X
}
C {devices/gnd.sym} 810 -600 0 0 {name=l5 lab=GND}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 1120 -650 0 0 {name=M3
L=0.18
W=5.05
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
C {devices/gnd.sym} 1100 -600 0 0 {name=l6 lab=GND}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 380 -400 0 0 {name=M1
L=0.18
W=5.05
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
C {devices/lab_wire.sym} 540 -650 0 0 {name=l7 sig_type=std_logic lab=D}
C {devices/gnd.sym} 540 -600 0 0 {name=l8 lab=GND}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 560 -650 0 0 {name=M4
L=0.18
W=5.05
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
