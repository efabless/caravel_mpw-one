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
V {        wire [5:0] opcode;
        assign opcode = instr[31:26];

        wire [5:0] func;
        assign func = instr[5:0];

        wire is_add = ((opcode == 6'h00) & (func == 6'h20));
        wire is_sub = ((opcode == 6'h00) & (func == 6'h22));
        wire is_and = ((opcode == 6'h00) & (func == 6'h24));
        wire is_or  = ((opcode == 6'h00) & (func == 6'h25));
        wire is_slt = ((opcode == 6'h00) & (func == 6'h2A));

        wire is_lw = (opcode == 6'h23);
        wire is_sw = (opcode == 6'h2B);

        wire is_beq  = (opcode == 6'h04);
        wire is_addi = (opcode == 6'h08);
        wire is_j    = (opcode == 6'h02);

        assign branch     = is_beq;
        assign jump       = is_j;
        assign mem_to_reg = is_lw;
        assign mem_write  = is_sw;
        assign reg_dst    = is_add | is_sub | is_and | is_or | is_slt;
        assign reg_write  = is_add | is_sub | is_and | is_or | is_slt | is_addi | is_lw;
        assign alu_src    = is_addi | is_lw | is_sw;
}
S {}
E {}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/ipin.sym} 160 -180 0 0 {name=p11 lab=instr[31:0]}
C {devices/opin.sym} 340 -230 0 0 {name=p1 lab=branch}
C {devices/opin.sym} 340 -210 0 0 {name=p2 lab=jump}
C {devices/opin.sym} 340 -190 0 0 {name=p3 lab=mem_to_reg}
C {devices/opin.sym} 340 -170 0 0 {name=p4 lab=mem_write}
C {devices/opin.sym} 340 -150 0 0 {name=p5 lab=reg_dst}
C {devices/opin.sym} 340 -130 0 0 {name=p6 lab=reg_write}
C {devices/opin.sym} 340 -110 0 0 {name=p7 lab=alu_src}
C {devices/architecture.sym} 100 -770 0 0 { nothing here, use global schematic properties }
