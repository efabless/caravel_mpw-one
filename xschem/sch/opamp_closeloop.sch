v { version=2.9.8 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 600 -170 600 -130 { lab=GND}
N 600 -270 600 -230 { lab=vss}
N 700 -270 700 -230 { lab=vdd}
N 700 -170 700 -130 { lab=vss}
N 800 -360 800 -330 { lab=vin_signal}
N 1210 -190 1210 -150 { lab=vss}
N 1210 -280 1210 -250 { lab=#net1}
N 800 -270 800 -230 { lab=vsen}
N 800 -170 800 -130 { lab=vcm}
N 990 -550 1050 -550 { lab=vin}
N 980 -550 980 -360 { lab=vin}
N 980 -550 990 -550 { lab=vin}
N 800 -360 860 -360 { lab=vin_signal}
N 1030 -360 1090 -360 { lab=vin}
N 1260 -550 1310 -550 { lab=vout}
N 1030 -250 1030 -210 { lab=vss}
N 1030 -360 1030 -310 { lab=vin}
N 1250 -280 1250 -260 { lab=vss}
N 1390 -340 1390 -310 { lab=vout}
N 1310 -340 1390 -340 { lab=vout}
N 1390 -250 1390 -200 { lab=vss}
N 1110 -290 1110 -250 { lab=vcm}
N 1110 -190 1110 -150 { lab=vss}
N 1110 -320 1110 -290 { lab=vcm}
N 1110 -320 1170 -320 { lab=vcm}
N 1090 -360 1170 -360 { lab=vin}
N 920 -360 1030 -360 { lab=vin}
N 1310 -550 1390 -550 { lab=vout}
N 1390 -550 1390 -340 { lab=vout}
N 1050 -550 1200 -550 { lab=vin}
N 1230 -420 1230 -390 { lab=vdd}
C {vsource.sym} 600 -200 0 0 {name=V1 value=DC\{vss\}}
C {vsource.sym} 700 -200 0 0 {name=V2 value=DC\{vdd\}}
C {gnd.sym} 600 -130 0 0 {name=l14 lab=GND}
C {vsource.sym} 800 -200 0 0 {name=V4 value="sin(0 \{vac\} 1Meg) dc 0 ac 1"}
C {capa.sym} 800 -300 2 0 {name=C4
m=1
value=1
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 700 -270 1 0 {name=l15 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 600 -270 1 0 {name=l16 sig_type=std_logic lab=vss}
C {lab_pin.sym} 700 -130 3 0 {name=l18 sig_type=std_logic lab=vss}
C {lab_pin.sym} 800 -130 3 0 {name=l20 sig_type=std_logic lab=vcm}
C {isource.sym} 1210 -220 0 0 {name=I0 value=DC\{iref\}}
C {lab_pin.sym} 1210 -150 3 0 {name=l22 sig_type=std_logic lab=vss}
C {lab_wire.sym} 800 -250 3 0 {name=l24 sig_type=std_logic lab=vsen}
C {res.sym} 890 -360 1 0 {name=R1
value=500
footprint=1206
device=resistor
m=1}
C {res.sym} 1230 -550 1 0 {name=R3
value=5k
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 1030 -210 3 0 {name=l28 sig_type=std_logic lab=vss
}
C {capa.sym} 1030 -280 0 0 {name=C5
m=1
value=5p
footprint=1206
device="ceramic capacitor"}
C {netlist_not_shown.sym} 650 -530 0 0 {name=SIMULATION only_toplevel=false 

value="


* Circuit Parameters
.param iref = 100u
.param vdd  = 1.8
.param vss  = 0.0
.param vcm  = 0.8
.param vac  = 10m
.options TEMP = 65.0

* Include Models
.lib ~/skywater_pdk/skywater-pdk/libraries/sky130_fd_pr/latest/models/corners/sky130.lib TT

* OP Parameters & Singals to save
.save all
+ @M.X1.XM1.msky130_fd_pr__pfet_01v8[id] @M.X1.XM1.msky130_fd_pr__pfet_01v8[vth] @M.X1.XM1.msky130_fd_pr__pfet_01v8[vgs] @M.X1.XM1.msky130_fd_pr__pfet_01v8[vds] @M.X1.XM1.msky130_fd_pr__pfet_01v8[vdsat] @M.X1.XM1.msky130_fd_pr__pfet_01v8[gm] @M.X1.XM1.msky130_fd_pr__pfet_01v8[gds]
+ @M.X1.XM2.msky130_fd_pr__pfet_01v8[id] @M.X1.XM2.msky130_fd_pr__pfet_01v8[vth] @M.X1.XM2.msky130_fd_pr__pfet_01v8[vgs] @M.X1.XM2.msky130_fd_pr__pfet_01v8[vds] @M.X1.XM2.msky130_fd_pr__pfet_01v8[vdsat] @M.X1.XM2.msky130_fd_pr__pfet_01v8[gm] @M.X1.XM2.msky130_fd_pr__pfet_01v8[gds]
+ @M.X1.XM3.msky130_fd_pr__nfet_01v8[id] @M.X1.XM3.msky130_fd_pr__nfet_01v8[vth] @M.X1.XM3.msky130_fd_pr__nfet_01v8[vgs] @M.X1.XM3.msky130_fd_pr__nfet_01v8[vds] @M.X1.XM3.msky130_fd_pr__nfet_01v8[vdsat] @M.X1.XM3.msky130_fd_pr__nfet_01v8[gm] @M.X1.XM3.msky130_fd_pr__nfet_01v8[gds]
+ @M.X1.XM4.msky130_fd_pr__nfet_01v8[id] @M.X1.XM4.msky130_fd_pr__nfet_01v8[vth] @M.X1.XM4.msky130_fd_pr__nfet_01v8[vgs] @M.X1.XM4.msky130_fd_pr__nfet_01v8[vds] @M.X1.XM4.msky130_fd_pr__nfet_01v8[vdsat] @M.X1.XM4.msky130_fd_pr__nfet_01v8[gm] @M.X1.XM4.msky130_fd_pr__nfet_01v8[gds]
+ @M.X1.XM5.msky130_fd_pr__pfet_01v8[id] @M.X1.XM5.msky130_fd_pr__pfet_01v8[vth] @M.X1.XM5.msky130_fd_pr__pfet_01v8[vgs] @M.X1.XM5.msky130_fd_pr__pfet_01v8[vds] @M.X1.XM5.msky130_fd_pr__pfet_01v8[vdsat] @M.X1.XM5.msky130_fd_pr__pfet_01v8[gm] @M.X1.XM5.msky130_fd_pr__pfet_01v8[gds]
+ @M.X1.XM6.msky130_fd_pr__nfet_01v8[id] @M.X1.XM6.msky130_fd_pr__nfet_01v8[vth] @M.X1.XM6.msky130_fd_pr__nfet_01v8[vgs] @M.X1.XM6.msky130_fd_pr__nfet_01v8[vds] @M.X1.XM6.msky130_fd_pr__nfet_01v8[vdsat] @M.X1.XM6.msky130_fd_pr__nfet_01v8[gm] @M.X1.XM6.msky130_fd_pr__nfet_01v8[gds]
+ @M.X1.XM7.msky130_fd_pr__pfet_01v8[id] @M.X1.XM7.msky130_fd_pr__pfet_01v8[vth] @M.X1.XM7.msky130_fd_pr__pfet_01v8[vgs] @M.X1.XM7.msky130_fd_pr__pfet_01v8[vds] @M.X1.XM7.msky130_fd_pr__pfet_01v8[vdsat] @M.X1.XM7.msky130_fd_pr__pfet_01v8[gm] @M.X1.XM7.msky130_fd_pr__pfet_01v8[gds]
+ @M.X1.XM8.msky130_fd_pr__pfet_01v8[id] @M.X1.XM8.msky130_fd_pr__pfet_01v8[vth] @M.X1.XM8.msky130_fd_pr__pfet_01v8[vgs] @M.X1.XM8.msky130_fd_pr__pfet_01v8[vds] @M.X1.XM8.msky130_fd_pr__pfet_01v8[vdsat] @M.X1.XM8.msky130_fd_pr__pfet_01v8[gm] @M.X1.XM8.msky130_fd_pr__pfet_01v8[gds]
+ @M.X1.XM9.msky130_fd_pr__nfet_01v8[id] @M.X1.XM9.msky130_fd_pr__nfet_01v8[vth] @M.X1.XM9.msky130_fd_pr__nfet_01v8[vgs] @M.X1.XM9.msky130_fd_pr__nfet_01v8[vds] @M.X1.XM9.msky130_fd_pr__nfet_01v8[vdsat] @M.X1.XM9.msky130_fd_pr__nfet_01v8[gm] @M.X1.XM9.msky130_fd_pr__nfet_01v8[gds]

*Simulations
.control
  ac dec 100 1k 10G
  setplot ac1
  meas ac GBW when vdb(vout)=0
  meas ac DCG find vdb(vout) at=1k
  *meas ac PM find vp(vout) when vdb(vout)=0
  *print PM*180/PI
  *meas ac GM find vdb(vout) when vp(vout)=0
  plot vdb(vout) \{vp(vout)*180/PI\}
  write ~/fulgor-opamp-sky130/xschem/sim_results/opamp_closeloop_ac1.raw
  
  reset
  tran 0.01u 11u
  setplot tran1
  plot v(vsen) v(vout)
  write ~/fulgor-opamp-sky130/xschem/sim_results/opamp_closeloop_tran1.raw

  reset    
  noise v(vout) V4 dec 100 1k 10G 1
  setplot noise1
  plot inoise_spectrum onoise_spectrum
  *print inoise_spectrum
  *print onoise_spectrum
  setplot noise2
  *plot inoise_total onoise_total
  print inoise_total
  print onoise_total
  write ~/fulgor-opamp-sky130/xschem/sim_results/opamp_closeloop_noise.raw
  
  reset
  op
  setplot op1
  print vout  
  write ~/fulgor-opamp-sky130/xschem/sim_results/opamp_closeloop_op1.raw
  
.endc

.end
"}
C {opamp.sym} 1240 -340 0 0 {name=x1}
C {lab_pin.sym} 1250 -260 3 0 {name=l1 sig_type=std_logic lab=vss}
C {capa.sym} 1390 -280 0 0 {name=C1
m=1
value=20p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1390 -200 3 0 {name=l2 sig_type=std_logic lab=vss}
C {lab_wire.sym} 1360 -340 0 0 {name=l3 sig_type=std_logic lab=vout}
C {lab_pin.sym} 1110 -150 3 0 {name=l5 sig_type=std_logic lab=vss}
C {lab_wire.sym} 1150 -320 0 0 {name=l4 sig_type=std_logic lab=vcm}
C {vsource.sym} 1110 -220 0 0 {name=V5 value=DC\{vcm\}}
C {lab_wire.sym} 1110 -360 0 0 {name=l6 sig_type=std_logic lab=vin}
C {lab_wire.sym} 840 -360 0 0 {name=l7 sig_type=std_logic lab=vin_signal}
C {lab_pin.sym} 1230 -420 1 0 {name=l8 sig_type=std_logic lab=vdd}
