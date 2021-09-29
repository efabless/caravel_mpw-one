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
V {        reg [31:0] memdata[63:0];

        // always @(memdata[addr]) begin
        //        rdata = memdata[addr];
        // end

        always @(posedge clk) begin
                if(1'b1 == we) begin
                        $display("dmem written at time %t, data=%08x", $time, wdata);
                        memdata[addr] = wdata;
                end
        end


       assign rdata = memdata[addr];}
S {}
E {}
C {devices/ipin.sym} 180 -170 0 0 {name=p1 lab=clk}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/ipin.sym} 180 -150 0 0 {name=p10 lab=we}
C {devices/ipin.sym} 180 -130 0 0 {name=p11 lab=addr[31:0]}
C {devices/ipin.sym} 180 -110 0 0 {name=p12 lab=wdata[31:0]}
C {devices/opin.sym} 450 -150 0 0 {name=p13 lab=rdata[31:0] }
C {devices/architecture.sym} 170 -520 0 0 { nothing here, use global schematic properties }
