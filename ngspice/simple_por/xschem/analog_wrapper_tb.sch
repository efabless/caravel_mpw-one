v {xschem version=2.9.9 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 300 -290 510 -290 { lab=#net1}
N 590 -290 590 -250 { lab=#net1}
N 300 -250 430 -250 { lab=GND}
N 510 -250 510 -150 { lab=GND}
N 510 -150 780 -150 { lab=GND}
N 780 -190 780 -150 { lab=GND}
N 690 -190 690 -150 { lab=GND}
N 590 -190 590 -150 { lab=GND}
N 300 -210 400 -210 { lab=#net2}
N 480 -270 480 -210 { lab=#net2}
N 480 -270 690 -270 { lab=#net2}
N 690 -270 690 -250 { lab=#net2}
N 300 10 450 10 { lab=#net3}
N 850 -270 850 0 { lab=io_analog[4]}
N 780 -270 850 -270 { lab=io_analog[4]}
N 780 -270 780 -250 { lab=io_analog[4]}
N 300 30 470 30 { lab=io_clamp_high[2:0]}
N 300 50 410 50 { lab=GND}
N 550 30 630 30 { lab=io_clamp_high[2:0]}
N 630 30 630 90 { lab=io_clamp_high[2:0]}
N 500 160 810 160 { lab=GND}
N 810 -150 810 160 { lab=GND}
N 780 -150 810 -150 { lab=GND}
N 530 10 660 10 { lab=io_analog[10:0]}
N 510 -290 590 -290 { lab=#net1}
N 430 -250 510 -250 { lab=GND}
N 400 -210 480 -210 { lab=#net2}
N 470 30 550 30 { lab=io_clamp_high[2:0]}
N 460 10 530 10 { lab=io_analog[10:0]}
N 410 50 490 50 { lab=io_clamp_low[2:0]}
N 490 50 490 160 { lab=GND}
N 490 160 500 160 { lab=GND}
N 300 -50 620 -50 { lab=io_oeb[26:0]}
N 300 -70 480 -70 { lab=io_out[26:0]}
N 520 -150 520 -60 { lab=io_oeb[16:15]}
N 610 -150 610 -60 { lab=io_oeb[12:11]}
N 850 -0 850 40 { lab=io_analog[4]}
N 640 40 810 40 { lab=io_clamp_high[2:1]}
N 670 0 850 -0 { lab=io_analog[4]}
N 640 100 850 100 { lab=io_clamp_high[0]}
N 850 40 850 100 { lab=io_analog[4]}
N 300 -270 400 -270 { lab=#net4}
N 300 -230 400 -230 { lab=#net5}
N 300 -190 400 -190 { lab=#net6}
N 300 -190 400 -190 { lab=#net6}
N 300 -170 400 -170 { lab=#net7}
N 290 -150 390 -150 { lab=#net8}
N 290 -130 390 -130 { lab=#net9}
N 290 -110 390 -110 { lab=#net10}
N 300 -90 400 -90 { lab=#net11}
N 300 -30 400 -30 { lab=#net12}
N 300 -10 400 -10 { lab=#net13}
N 300 70 400 70 { lab=#net14}
N -60 -290 -0 -290 { lab=#net15}
N -60 -270 0 -270 { lab=#net16}
N -60 -250 0 -250 { lab=#net17}
N -60 -230 0 -230 { lab=#net18}
N -60 -210 0 -210 { lab=#net19}
N -60 -210 0 -210 { lab=#net19}
N -60 -190 0 -190 { lab=#net20}
N -60 -190 0 -190 { lab=#net20}
N -60 -170 0 -170 { lab=#net21}
N -60 -150 0 -150 { lab=#net22}
N -60 -130 0 -130 { lab=#net23}
N -60 -110 0 -110 { lab=#net24}
N -60 -90 0 -90 { lab=#net25}
N -60 -70 0 -70 { lab=#net26}
N -60 -50 0 -50 { lab=#net27}
C {user_analog_project_wrapper.sym} 150 -110 0 0 {name=x1}
C {devices/vsource.sym} 590 -220 0 0 {name=V1 value="PWL(0.0 0 400u 0 5.4m 3.3)"}
C {devices/vsource.sym} 690 -220 0 0 {name=V2 value="PWL(0.0 0 300u 0 5.3 1.8)"}
C {devices/vsource.sym} 780 -220 0 0 {name=V3 value="PWL(0.0 0 100u 0 5m 3.3)"}
C {devices/bus_connect.sym} 660 10 1 1 {name=l1 lab=io_analog[4]}
C {devices/gnd.sym} 730 -150 0 0 {name=l2 lab=GND}
C {devices/bus_connect.sym} 630 30 1 0 {name=l3 lab=io_clamp_high[2:1]}
C {devices/bus_connect.sym} 630 90 1 0 {name=l8 lab=io_clamp_high[0]}
C {devices/lab_pin.sym} 570 30 0 0 {name=l11 sig_type=std_logic lab=io_clamp_high[2:0]}
C {devices/lab_pin.sym} 570 10 0 0 {name=l12 sig_type=std_logic lab=io_analog[10:0]}
C {devices/lab_pin.sym} 480 50 0 0 {name=l9 sig_type=std_logic lab=io_clamp_low[2:0]}
C {devices/lab_pin.sym} 450 -50 0 0 {name=l4 sig_type=std_logic lab=io_oeb[26:0]}
C {devices/lab_pin.sym} 450 -70 0 0 {name=l5 sig_type=std_logic lab=io_out[26:0]}
C {devices/bus_connect.sym} 510 -50 0 0 {name=l6 lab=io_oeb[16:15]}
C {devices/bus_connect.sym} 600 -50 0 0 {name=l7 lab=io_oeb[12:11]}
C {devices/code_shown.sym} 920 -130 0 0 {name=s1 only_toplevel=false value=".param mc_mm_switch=0
.lib /usr/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt
.include /usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hvl/spice/sky130_fd_sc_hvl.spice
.control
tran 10u 20m
plot V(io_out[11]) V(io_out[12]) V(io_out[15]) V(io_out[16])
+ V(gpio_analog[3]) V(gpio_analog[7])
.endc"}
