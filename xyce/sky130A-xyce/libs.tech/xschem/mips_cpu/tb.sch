v {xschem version=2.9.8 file_version=1.2

* Copyright 2020 Stefan Frederik Schippers
* 
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
V {    //clk, reset, pc, instr, aluout, writedata, memwrite, and readdata

    // generate clock
    always begin
        #`CLKPDIV2 clock = ~clock;
    end

    initial begin
        $dumpfile("dumpfile.vcd");
        $dumpvars(0, xuut);
    end

    initial begin
        // initialize all variables
        clock = 0; reset = 1;
        // wait for first negative edge before de-asserting reset
        @(negedge clock) reset = 0;
        #1000
        $finish;
    end}
S {}
E {}
T {main:            addi $2, $0, 5        # 20020005
                 addi $7, $0, 3        # 20070003
                 addi $3, $0, 0xc      # 2003000c
                 or $4, $7, $2         # 00e22025
                 and $5, $3, $4        # 00642824
                 add $5, $5, $4        # 00a42820
                 beq $5, $7, end       # 10a70008
                 slt $6, $3, $4        # 0064302a
                 beq $6, $0, around    # 10c00001
                 addi $5, $0, 10       # 2005000a
around:          slt $6, $7, $2        # 00e2302a
                 add $7, $6, $5        # 00c53820
                 sub $7, $7, $2        # 00e23822
                 j end                 # 0800000f
                 lw $7, 0($0)          # 8c070000
end:             sw $7, 71($2)         # ac470047
} 850 -670 0 0 0.5 0.5 {font=monospace}
T {TEST PROGRAM} 1110 -780 0 0 1 1 {layer=8}
T {MIPS CPU
An implementation of a 32-bit single cycle MIPS processor in Verilog. 
This version of the MIPS single-cycle processor can execute the 
following instructions: add, sub, and, or, slt, lw, sw, beq, addi, and j.} 20 -1130 0 0 1 1 {}
T {Original work by Diadatp} 40 -820 0 0 0.6 0.6 { layer=5}
T {Ctrl-Click
to open link} 450 -860 0 0 0.3 0.3 {layer=11}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {mips_cpu/top.sym} 480 -100 0 0 {name=xuut}
C {devices/lab_pin.sym} 330 -110 0 0 {name=p1 lab=clock verilog_type=reg}
C {devices/lab_pin.sym} 330 -90 0 0 {name=p3 lab=reset verilog_type=reg}
C {devices/architecture.sym} 0 -530 0 0 { nothing here, use global schematic properties }
C {devices/verilog_preprocessor.sym} 30 -670 0 0 {name=s1  
string="`define CLKP 10 // clock period
`define CLKPDIV2 5 // clock period divided by 2
"}
C {devices/launcher.sym} 530 -800 0 0 {name=h1
descr=Github 
url=https://github.com/diadatp/mips_cpu}
