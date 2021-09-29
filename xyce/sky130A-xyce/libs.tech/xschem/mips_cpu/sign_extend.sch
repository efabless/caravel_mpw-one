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
V {        always @(idata) begin : proc_sign_extend
                odata = \{\{16\{idata[15]\}\}, idata\};
        end
}
S {}
E {}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/opin.sym} 390 -120 0 0 {name=p7 lab=odata[31:0] verilog_type=reg}
C {devices/ipin.sym} 160 -120 0 0 {name=p1 lab=idata[15:0]}
C {devices/architecture.sym} 60 -310 0 0 { nothing here, use global schematic properties }
