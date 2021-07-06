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
V {        reg [31:0] regmem[31:0];

        always @(addr1 or regmem[addr1]) begin
                if (0 == addr1) begin
                        data1 = 0;
                end else begin
                        data1 = regmem[addr1];
                end
        end

        always @(addr2 or regmem[addr2]) begin
                if (0 == addr2) begin
                        data2 = 0;
                end else begin
                        data2 = regmem[addr2];
                end
        end

        always@ (posedge clk) begin
                if(1'b1 == rw) begin
                        regmem[addr3] = wdata;
                end
        end
}
S {}
E {}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/ipin.sym} 160 -220 0 0 {name=p2 lab=clk}
C {devices/ipin.sym} 160 -200 0 0 {name=p3 lab=addr1[4:0]}
C {devices/ipin.sym} 160 -180 0 0 {name=p5 lab=addr2[4:0]}
C {devices/opin.sym} 390 -170 0 0 {name=p6 lab=data1[31:0] verilog_type=reg}
C {devices/opin.sym} 390 -150 0 0 {name=p7 lab=data2[31:0] verilog_type=reg}
C {devices/ipin.sym} 160 -160 0 0 {name=p8 lab=rw}
C {devices/ipin.sym} 160 -140 0 0 {name=p4 lab=addr3[4:0]}
C {devices/ipin.sym} 160 -120 0 0 {name=p1 lab=wdata[31:0]}
C {devices/architecture.sym} 140 -740 0 0 { nothing here, use global schematic properties }
