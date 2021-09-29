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
V {        wire [31:0] pc_plus_4;
        assign pc_plus_4 = pc + 4;

        wire [31:0] pc_jump;
        assign pc_jump = \{pc_plus_4[31:28], instr[25:0], 2'b00\};

        wire pc_src;
        assign pc_src = branch & zero;

        wire [31:0] pc_branch;
        assign pc_branch = pc_plus_4 + \{imm_ext[29:0], 2'b00\};

        wire [31:0] pc_next;
        assign pc_next = jump ? pc_jump : (pc_src ? pc_branch : pc_plus_4);

        always @(posedge clk) begin : proc_pc
                if(~rst) begin
                        pc = pc_next;
                end else begin
                        pc = 32'h00000000;
                end
        end

        wire [5:0] rt;
        assign rt = instr[20:16];

        wire [5:0] rd;
        assign rd = instr[15:11];

        assign write_reg = reg_dst ? rd : rt;

        assign result = mem_to_reg ? read_data : alu_result ;

        assign src_b = alu_src ? imm_ext : reg_data2;
        assign src_a = reg_data1;
        assign src_b = alu_src ? imm_ext : reg_data2;
        assign alu_result = alu_out;
        assign write_data = reg_data2;

}
S {}
E {}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/ipin.sym} 170 -350 0 0 {name=p2 lab=clk}
C {devices/ipin.sym} 170 -330 0 0 {name=p3 lab=rst}
C {devices/ipin.sym} 170 -310 0 0 {name=p5 lab=alucontrol[2:0]}
C {devices/ipin.sym} 170 -290 0 0 {name=p6 lab=alu_src}
C {devices/ipin.sym} 170 -270 0 0 {name=p7 lab=branch}
C {devices/ipin.sym} 170 -250 0 0 {name=p8 lab=jump}
C {devices/ipin.sym} 170 -230 0 0 {name=p9 lab=mem_to_reg}
C {devices/ipin.sym} 170 -190 0 0 {name=p11 lab=reg_dst}
C {devices/ipin.sym} 170 -170 0 0 {name=p12 lab=reg_write}
C {devices/ipin.sym} 170 -130 0 0 {name=p14 lab=instr[31:0]}
C {devices/opin.sym} 400 -200 0 0 {name=p15 lab=pc[31:0] verilog_type=reg}
C {devices/ipin.sym} 170 -110 0 0 {name=p1 lab=read_data[31:0]}
C {devices/opin.sym} 400 -180 0 0 {name=p16 lab=alu_result[31:0]}
C {devices/opin.sym} 400 -160 0 0 {name=p17 lab=write_data[31:0]}
C {mips_cpu/regfile.sym} 460 -560 0 0 {name=xregfile_inst}
C {devices/lab_pin.sym} 310 -610 0 0 {name=p4 lab=clk}
C {devices/lab_pin.sym} 310 -590 0 0 {name=p13 lab=instr[25:21]}
C {devices/lab_pin.sym} 310 -570 0 0 {name=p18 lab=instr[20:16]}
C {devices/lab_pin.sym} 610 -610 0 1 {name=p19 lab=reg_data1[31:0]}
C {devices/lab_pin.sym} 310 -550 0 0 {name=p20 lab=reg_write}
C {devices/lab_pin.sym} 610 -590 0 1 {name=p21 lab=reg_data2[31:0]}
C {devices/lab_pin.sym} 310 -530 0 0 {name=p22 lab=write_reg[4:0]}
C {devices/lab_pin.sym} 310 -510 0 0 {name=p23 lab=result[31:0]}
C {mips_cpu/alu.sym} 460 -420 0 0 {name=xalu_inst}
C {devices/lab_pin.sym} 310 -440 0 0 {name=p24 lab=src_a[31:0]}
C {devices/lab_pin.sym} 610 -440 0 1 {name=p25 lab=zero}
C {devices/lab_pin.sym} 310 -420 0 0 {name=p26 lab=src_b[31:0]}
C {devices/lab_pin.sym} 610 -420 0 1 {name=p27 lab=c_out}
C {devices/lab_pin.sym} 610 -400 0 1 {name=p28 lab=alu_out[31:0]}
C {devices/lab_pin.sym} 310 -400 0 0 {name=p29 lab=alucontrol[2:0]}
C {mips_cpu/sign_extend.sym} 460 -680 0 0 {name=xsign_extend_inst}
C {devices/lab_pin.sym} 310 -680 0 0 {name=p30 lab=instr[15:0]}
C {devices/lab_pin.sym} 610 -680 0 1 {name=p31 lab=imm_ext[31:0]}
C {devices/architecture.sym} 830 -880 0 0 { nothing here, use global schematic properties }
