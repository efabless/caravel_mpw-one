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
V {    wire [31:0] not_b_in;
    assign not_b_in = ~ b_in;

    wire [31:0] b_mux_not_b;
    assign b_mux_not_b = (1'b0 == f_in[2]) ? b_in : not_b_in;

    wire [31:0] fx00;
    assign fx00 = a_in & b_mux_not_b;

    wire [31:0] fx01;
    assign fx01 = a_in | b_mux_not_b;

    wire [31:0] fx10;
    assign \{c_out, fx10\} = a_in + b_mux_not_b + f_in[2];

    wire [31:0] fx11;
    assign fx11 = \{\{31\{1'b0\}\}, ((a_in[31] == not_b_in[31]) && (fx10[31] != a_in[31])) ? ~(fx10[31]) : fx10[31]\};

    assign zero = ~| y_out;

    assign y_out = 2'b00 == f_in[1:0] ? fx00 : (2'b01 == f_in[1:0] ? fx01 : (2'b10 == f_in[1:0] ? fx10 : fx11 ));
}
S {}
E {}
C {devices/ipin.sym} 140 -150 0 0 {name=p1 lab=a_in[31:0]}
C {devices/opin.sym} 410 -140 0 0 {name=p4 lab=zero}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/architecture.sym} 10 -620 0 0 { nothing here, use global schematic properties }
C {devices/ipin.sym} 140 -120 0 0 {name=p2 lab=b_in[31:0]}
C {devices/ipin.sym} 140 -90 0 0 {name=p3 lab=f_in[2:0]}
C {devices/opin.sym} 410 -120 0 0 {name=p5 lab=c_out}
C {devices/opin.sym} 410 -100 0 0 {name=p6 lab=y_out[31:0]}
