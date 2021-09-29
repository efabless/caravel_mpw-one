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
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/ipin.sym} 190 -180 0 0 {name=p11 lab=clk}
C {devices/ipin.sym} 190 -160 0 0 {name=p2 lab=reset}
C {mips_cpu/mips.sym} 670 -340 0 0 {name=xmips_inst}
C {mips_cpu/dmem.sym} 670 -220 0 0 {name=xdmem_inst}
C {mips_cpu/imem.sym} 670 -140 0 0 {name=ximem_inst}
C {devices/lab_pin.sym} 820 -370 0 1 {name=p8 lab=imem_addr[31:0]}
C {devices/lab_pin.sym} 520 -370 0 0 {name=p9 lab=clk}
C {devices/lab_pin.sym} 820 -350 0 1 {name=p10 lab=dmem_we}
C {devices/lab_pin.sym} 520 -350 0 0 {name=p12 lab=reset}
C {devices/lab_pin.sym} 520 -330 0 0 {name=p13 lab=imem_data[31:0]}
C {devices/lab_pin.sym} 820 -330 0 1 {name=p14 lab=dmem_addr[31:0]}
C {devices/lab_pin.sym} 520 -310 0 0 {name=p15 lab=dmem_rdata[31:0]}
C {devices/lab_pin.sym} 820 -310 0 1 {name=p16 lab=dmem_wdata[31:0]}
C {devices/lab_pin.sym} 520 -250 0 0 {name=p17 lab=clk}
C {devices/lab_pin.sym} 520 -230 0 0 {name=p18 lab=dmem_we}
C {devices/lab_pin.sym} 820 -250 0 1 {name=p19 lab=dmem_rdata[31:0]}
C {devices/lab_pin.sym} 520 -210 0 0 {name=p20 lab=dmem_addr[31:0]}
C {devices/lab_pin.sym} 520 -190 0 0 {name=p21 lab=dmem_wdata[31:0]}
C {devices/lab_pin.sym} 820 -140 0 1 {name=p22 lab=imem_data[31:0]}
C {devices/lab_pin.sym} 520 -140 0 0 {name=p23 lab=imem_addr[7:2]}
