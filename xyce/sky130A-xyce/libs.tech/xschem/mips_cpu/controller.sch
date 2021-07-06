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
C {devices/ipin.sym} 140 -260 0 0 {name=p1 lab=instr[31:0]}
C {devices/opin.sym} 410 -140 0 0 {name=p4 lab=alucontrol[2:0]}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/opin.sym} 410 -260 0 0 {name=p2 lab=branch}
C {devices/opin.sym} 410 -240 0 0 {name=p3 lab=jump}
C {devices/opin.sym} 410 -220 0 0 {name=p5 lab=mem_to_reg}
C {devices/opin.sym} 410 -200 0 0 {name=p6 lab=mem_write}
C {devices/opin.sym} 410 -180 0 0 {name=p7 lab=reg_dst}
C {devices/opin.sym} 410 -160 0 0 {name=p8 lab=reg_write}
C {devices/opin.sym} 410 -120 0 0 {name=p9 lab=alu_src}
C {mips_cpu/maindec.sym} 480 -560 0 0 {name=xmaindec_inst}
C {devices/lab_pin.sym} 330 -620 0 0 {name=p10 lab=instr[31:0]}
C {devices/lab_pin.sym} 630 -620 0 1 {name=p11 lab=branch}
C {devices/lab_pin.sym} 630 -600 0 1 {name=p12 lab=jump}
C {devices/lab_pin.sym} 630 -580 0 1 {name=p13 lab=mem_to_reg}
C {devices/lab_pin.sym} 630 -560 0 1 {name=p14 lab=mem_write}
C {devices/lab_pin.sym} 630 -540 0 1 {name=p15 lab=reg_dst}
C {devices/lab_pin.sym} 630 -520 0 1 {name=p16 lab=reg_write}
C {devices/lab_pin.sym} 630 -500 0 1 {name=p17 lab=alu_src}
C {mips_cpu/aludec.sym} 480 -440 0 0 {name=xaludec_inst}
C {devices/lab_pin.sym} 330 -440 0 0 {name=p18 lab=instr[31:0]}
C {devices/lab_pin.sym} 630 -440 0 1 {name=p19 lab=alucontrol[2:0]}
