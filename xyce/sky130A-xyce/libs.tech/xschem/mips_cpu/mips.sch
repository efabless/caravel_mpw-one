v {xschem version=2.9.8 file_version=1.2

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
L 5 640 -700 760 -700 {}
L 5 760 -700 760 -280 {}
L 5 270 -280 760 -280 {}
L 5 270 -280 270 -160 {}
P 5 7 270 -160 290 -160 290 -170 310 -160 290 -150 290 -160 270 -160 { fill=true}
T {FIX} 550 -350 0 0 1 1 { layer=5}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/ipin.sym} 190 -180 0 0 {name=p11 lab=clk}
C {devices/opin.sym} 320 -190 0 0 {name=p1 lab=imem_addr[31:0]}
C {devices/ipin.sym} 190 -160 0 0 {name=p2 lab=rst}
C {devices/ipin.sym} 190 -140 0 0 {name=p3 lab=imem_data[31:0]}
C {devices/ipin.sym} 190 -120 0 0 {name=p4 lab=dmem_rdata[31:0]}
C {devices/opin.sym} 320 -160 0 0 {name=p5 lab=dmem_we}
C {devices/opin.sym} 320 -130 0 0 {name=p6 lab=dmem_addr[31:0]}
C {devices/opin.sym} 320 -100 0 0 {name=p7 lab=dmem_wdata[31:0]}
C {mips_cpu/controller.sym} 380 -690 0 0 {name=xcontroller_inst}
C {devices/lab_pin.sym} 230 -760 0 0 {name=p8 lab=imem_data[31:0]}
C {devices/lab_pin.sym} 530 -760 0 1 {name=p9 lab=branch}
C {devices/lab_pin.sym} 530 -740 0 1 {name=p10 lab=jump}
C {devices/lab_pin.sym} 530 -720 0 1 {name=p12 lab=mem_to_reg}
C {devices/lab_pin.sym} 530 -700 0 1 {name=p13 lab=dmem_we}
C {devices/lab_pin.sym} 530 -680 0 1 {name=p14 lab=reg_dst}
C {devices/lab_pin.sym} 530 -660 0 1 {name=p15 lab=reg_write}
C {devices/lab_pin.sym} 530 -640 0 1 {name=p16 lab=alucontrol[2:0]}
C {devices/lab_pin.sym} 530 -620 0 1 {name=p17 lab=alu_src}
C {mips_cpu/datapath.sym} 380 -460 0 0 {name=xdatapath_inst}
C {devices/lab_pin.sym} 230 -560 0 0 {name=p18 lab=clk}
C {devices/lab_pin.sym} 230 -540 0 0 {name=p19 lab=rst}
C {devices/lab_pin.sym} 230 -520 0 0 {name=p20 lab=alucontrol[2:0]}
C {devices/lab_pin.sym} 230 -500 0 0 {name=p21 lab=alu_src}
C {devices/lab_pin.sym} 230 -480 0 0 {name=p22 lab=branch}
C {devices/lab_pin.sym} 230 -460 0 0 {name=p23 lab=jump}
C {devices/lab_pin.sym} 230 -440 0 0 {name=p24 lab=mem_to_reg}
C {devices/lab_pin.sym} 530 -560 0 1 {name=p26 lab=imem_addr[31:0]}
C {devices/lab_pin.sym} 230 -420 0 0 {name=p27 lab=reg_dst}
C {devices/lab_pin.sym} 530 -540 0 1 {name=p28 lab=dmem_addr[31:0]}
C {devices/lab_pin.sym} 230 -400 0 0 {name=p29 lab=reg_write}
C {devices/lab_pin.sym} 530 -520 0 1 {name=p30 lab=dmem_wdata[31:0]}
C {devices/lab_pin.sym} 230 -380 0 0 {name=p31 lab=imem_data[31:0]}
C {devices/lab_pin.sym} 230 -360 0 0 {name=p32 lab=dmem_rdata[31:0]}
