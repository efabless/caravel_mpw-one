v { version=2.9.8 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 1290 -35 1290 40 { lab=vss}
N 1570 -35 1570 40 { lab=vss}
N 1290 40 1357.5 40 { lab=vss}
N 1357.5 40 1570 40 { lab=vss}
N 1370 -135 1370 -65 { lab=vbn}
N 1210 -65 1290 -65 { lab=vss}
N 1210 -65 1210 40 { lab=vss}
N 1210 40 1290 40 { lab=vss}
N 1570 -65 1637.5 -65 { lab=vss}
N 1637.5 -65 1637.5 40 { lab=vss}
N 1570 -240 1570 -95 { lab=voe1}
N 1290 -360 1290 -300 { lab=vp}
N 1290 -360 1570 -360 { lab=vp}
N 1570 -360 1570 -300 { lab=vp}
N 1287.5 -270 1350 -270 { lab=vp}
N 1350 -360 1350 -270 { lab=vp}
N 1507.5 -360 1507.5 -270 { lab=vp}
N 1430 -410 1430 -360 { lab=vp}
N 1890 -472.5 1890 -470 { lab=vdd}
N 1890 -500 1890 -472.5 { lab=vdd}
N 1430 -500 1890 -500 { lab=vdd}
N 1430 -500 1430 -470 { lab=vdd}
N 1887.5 -440 1967.5 -440 { lab=vdd}
N 1967.5 -500 1967.5 -440 { lab=vdd}
N 1890 -500 1967.5 -500 { lab=vdd}
N 1050 -500 1050 -470 { lab=vdd}
N 1050 -500 1430 -500 { lab=vdd}
N 1050 -360 1152.5 -360 { lab=iref}
N 1152.5 -440 1152.5 -360 { lab=iref}
N 1767.5 -440 1850 -440 { lab=iref}
N 970 -440 1052.5 -440 { lab=vdd}
N 970 -500 970 -440 { lab=vdd}
N 970 -500 1050 -500 { lab=vdd}
N 1430 -440 1510 -440 { lab=vdd}
N 1510 -500 1510 -440 { lab=vdd}
N 1370 -137.5 1370 -135 { lab=vbn}
N 1507.5 -270 1572.5 -270 { lab=vp}
N 1290 -240 1290 -95 { lab=vbn}
N 1290 -137.5 1370 -137.5 { lab=vbn}
N 1090 -440 1152.5 -440 { lab=iref}
N 1275 -440 1390 -440 { lab=iref}
N 1152.5 -440 1275 -440 { lab=iref}
N 1330 -65 1530 -65 { lab=vbn}
N 1050 -410 1050 -360 { lab=iref}
N 1180 -270 1250 -270 { lab=vin_n}
N 1750 -190 1800 -190 { lab=#net1}
N 1720 -250 1720 -230 { lab=vdd}
N 1720 -190 1720 -110 { lab=vss}
N 1570 -190 1690 -190 { lab=voe1}
N 1860 -190 1890 -190 { lab=vout}
N 950 -500 970 -500 { lab=vdd}
N 950 40 1210 40 { lab=vss}
N 1610 -270 1670 -270 { lab=vin_p}
N 950 -360 1050 -360 { lab=iref}
N 1570 40 1890 40 { lab=vss}
N 1890 40 1980 40 { lab=vss}
N 1980 -60 1980 40 { lab=vss}
N 1890 -60 1980 -60 { lab=vss}
N 1670 -60 1850 -60 { lab=voe1}
N 1670 -190 1670 -60 { lab=voe1}
N 1890 -190 1890 -90 { lab=vout}
N 1890 -410 1890 -190 { lab=vout}
N 1890 -240 2030 -240 { lab=vout}
N 1890 -30 1890 40 { lab=vss}
C {sky130_fd_pr/pfet_01v8.sym} 1270 -270 0 0 {name=M1
L=0.3
W=3
ad="'W * 0.29'" pd="'2 * (W + 0.29)'"
as="'W * 0.29'" ps="'2 * (W + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
nf=1 mult=200
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 1590 -270 0 1 {name=M2
L=0.3
W=3
ad="'W * 0.29'" pd="'2 * (W + 0.29)'"
as="'W * 0.29'" ps="'2 * (W + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
nf=1 mult=200
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 1310 -65 0 1 {name=M3
L=0.3
W=3
ad="'W * 0.29'" pd="'2 * (W + 0.29)'"
as="'W * 0.29'" ps="'2 * (W + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
nf=1 mult=30
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 1550 -65 0 0 {name=M4
L=0.3
W=3
ad="'W * 0.29'" pd="'2 * (W + 0.29)'"
as="'W * 0.29'" ps="'2 * (W + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
nf=1 mult=30
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 1410 -440 0 0 {name=M5
L=0.3
W=3
ad="'W * 0.29'" pd="'2 * (W + 0.29)'"
as="'W * 0.29'" ps="'2 * (W + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
nf=1 mult=30
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 1870 -440 0 0 {name=M7
L=0.3
W=3
ad="'W * 0.29'" pd="'2 * (W + 0.29)'"
as="'W * 0.29'" ps="'2 * (W + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
nf=1 mult=150
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 1070 -440 0 1 {name=M8
L=0.3
W=3
ad="'W * 0.29'" pd="'2 * (W + 0.29)'"
as="'W * 0.29'" ps="'2 * (W + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
nf=1 mult=15
model=pfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 1272.5 -500 0 0 {name=l1 sig_type=std_logic lab=vdd
}
C {lab_wire.sym} 1275 -440 0 0 {name=l2 sig_type=std_logic lab=iref

}
C {lab_wire.sym} 1405 -360 0 0 {name=l4 sig_type=std_logic lab=vp}
C {lab_pin.sym} 1767.5 -440 0 0 {name=l5 sig_type=std_logic lab=iref}
C {lab_wire.sym} 1442.5 40 0 0 {name=l7 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 1977.5 -240 0 0 {name=l8 sig_type=std_logic lab=vout
}
C {lab_wire.sym} 1450 -65 0 0 {name=l6 sig_type=std_logic lab=vbn}
C {sky130_fd_pr/nfet_01v8.sym} 1720 -210 1 0 {name=M9
L=0.15
W=0.75
ad="'W * 0.29'" pd="'2 * (W + 0.29)'"
as="'W * 0.29'" ps="'2 * (W + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
nf=1 mult=6
model=nfet_01v8
spiceprefix=X
}
C {lab_pin.sym} 1720 -250 2 0 {name=l9 sig_type=std_logic lab=vdd
}
C {lab_pin.sym} 1720 -110 2 0 {name=l10 sig_type=std_logic lab=vss
}
C {sky130_fd_pr/cap_mim_m3_1.sym} 1830 -190 3 0 {name=C1 model=cap_mim_m3_1 W=15 L=17.55 MF=6 spiceprefix=X}
C {iopin.sym} 950 -500 2 0 {name=p1 lab=vdd}
C {iopin.sym} 950 40 2 0 {name=p2 lab=vss}
C {ipin.sym} 1180 -270 0 0 {name=p3 lab=vin_n}
C {ipin.sym} 1670 -270 2 0 {name=p4 lab=vin_p}
C {ipin.sym} 950 -360 0 0 {name=p5 lab=iref}
C {sky130_fd_pr/nfet_01v8.sym} 1870 -60 0 0 {name=M6
L=0.45
W=4.5
ad="'W * 0.29'" pd="'2 * (W + 0.29)'"
as="'W * 0.29'" ps="'2 * (W + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
nf=1 mult=150
model=nfet_01v8
spiceprefix=X
}
C {lab_wire.sym} 1630 -190 0 0 {name=l3 sig_type=std_logic lab=voe1}
C {opin.sym} 2030 -240 0 0 {name=p6 lab=vout}
