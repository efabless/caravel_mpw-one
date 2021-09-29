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
V {
        always @(instr) begin
                casex (\{instr[31:26], instr[5:0]\})
                        12'b000100xxxxxx : alucontrol = 3'b110;
                        12'b001010xxxxxx : alucontrol = 3'b111;
                        12'b001000xxxxxx : alucontrol = 3'b010;
                        12'bxxxxxx100000 : alucontrol = 3'b010;
                        12'bxxxxxx100010 : alucontrol = 3'b110;
                        12'bxxxxxx100100 : alucontrol = 3'b000;
                        12'bxxxxxx100101 : alucontrol = 3'b001;
                        12'bxxxxxx101010 : alucontrol = 3'b111;
                        default          : alucontrol = 3'b010;
                endcase
        end
}
S {}
E {}
C {devices/ipin.sym} 140 -110 0 0 {name=p1 lab=instr[31:0]}
C {devices/opin.sym} 380 -110 0 0 {name=p4 lab=alucontrol[2:0] verilog_type=reg}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/architecture.sym} 20 -540 0 0 { nothing here, use global schematic properties }
