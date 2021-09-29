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
V {        // echo -e \{00..63\}": data = 32'h00000000;\\n"
        // xx : data = \{6'dx,5'dx,5'dx,5'dx,5'dx,6'dx\};
        always @(addr) begin
                case(addr)
                        00 : data = 32'h20020005;
                        01 : data = 32'h20070003;
                        02 : data = 32'h2003000c;
                        03 : data = 32'h00e22025;
                        04 : data = 32'h00642824;
                        05 : data = 32'h00a42820;
                        06 : data = 32'h10a70008;
                        07 : data = 32'h0064302a;
                        08 : data = 32'h10c00001;
                        09 : data = 32'h2005000a;
                        10 : data = 32'h00e2302a;
                        11 : data = 32'h00c53820;
                        12 : data = 32'h00e23822;
                        13 : data = 32'h0800000f;
                        14 : data = 32'h8c070000;
                        15 : data = 32'hac470047;
                        16 : data = 32'h00000000;
                        17 : data = 32'h00000000;
                        18 : data = 32'h00000000;
                        19 : data = 32'h00000000;
                        20 : data = 32'h00000000;
                        21 : data = 32'h00000000;
                        22 : data = 32'h00000000;
                        23 : data = 32'h00000000;
                        24 : data = 32'h00000000;
                        25 : data = 32'h00000000;
                        26 : data = 32'h00000000;
                        27 : data = 32'h00000000;
                        28 : data = 32'h00000000;
                        29 : data = 32'h00000000;
                        30 : data = 32'h00000000;
                        31 : data = 32'h00000000;
                        32 : data = 32'h00000000;
                        33 : data = 32'h00000000;
                        34 : data = 32'h00000000;
                        35 : data = 32'h00000000;
                        36 : data = 32'h00000000;
                        37 : data = 32'h00000000;
                        38 : data = 32'h00000000;
                        39 : data = 32'h00000000;
                        40 : data = 32'h00000000;
                        41 : data = 32'h00000000;
                        42 : data = 32'h00000000;
                        43 : data = 32'h00000000;
                        44 : data = 32'h00000000;
                        45 : data = 32'h00000000;
                        46 : data = 32'h00000000;
                        47 : data = 32'h00000000;
                        48 : data = 32'h00000000;
                        49 : data = 32'h00000000;
                        50 : data = 32'h00000000;
                        51 : data = 32'h00000000;
                        52 : data = 32'h00000000;
                        53 : data = 32'h00000000;
                        54 : data = 32'h00000000;
                        55 : data = 32'h00000000;
                        56 : data = 32'h00000000;
                        57 : data = 32'h00000000;
                        58 : data = 32'h00000000;
                        59 : data = 32'h00000000;
                        60 : data = 32'h00000000;
                        61 : data = 32'h00000000;
                        62 : data = 32'h00000000;
                        63 : data = 32'h00000000;
                endcase
        end
}
S {}
E {}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/ipin.sym} 180 -130 0 0 {name=p11 lab=addr[5:0]}
C {devices/opin.sym} 450 -150 0 0 {name=p13 lab=data[31:0] verilog_type=reg}
C {devices/architecture.sym} 0 -1500 0 0 { nothing here, use global schematic properties }
