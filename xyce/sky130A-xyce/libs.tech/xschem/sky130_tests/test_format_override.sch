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
V {}
S {}
E {}
T {Example of netlisting rule overrride for this AND2 primitive in instance:

* descend into symbol.

* copy the ' format="..." ' string.

* go back in parent schematic.

* select AND2 gate, press 'q' for edit attributes.

* on a new line paste the ' format="..." ' string, then make 
  your changes, for example change pin order and subckt reference
  Remember that instead of @pinlist (which prints pin net
  names in the order they are defined in the symbol) you can
  reference individual pins by using @@A, @@B, @@Y and so on.

* after specifying 'format' in instance you can also specify 
  'symname' to change the symbol (subcircuit) used for this gate

Generate netlist and see the result vs original gate.} 90 -750 0 0 0.4 0.4 {layer=13}
T {Override} 200 -230 0 0 0.6 0.6 {}
T {Original} 590 -230 0 0 0.6 0.6 {}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {stdcells/AND2.sym} 270 -120 0 0 {name=x1 VCCPIN=VCC VSSPIN=VSS VCCBPIN=VCC VSSBPIN=VSS
format="@name @@A @@B @VCCPIN @VSSPIN @VCCBPIN @VSSBPIN @@Y @symname"
symname=MYAND2}
C {devices/lab_pin.sym} 330 -120 0 1 {name=p1 lab=x1_Y}
C {devices/lab_pin.sym} 210 -140 0 0 {name=p2 lab=x1_A}
C {devices/lab_pin.sym} 210 -100 0 0 {name=p3 lab=x1_B}
C {stdcells/AND2.sym} 650 -120 0 0 {name=x2 VCCPIN=VCC VSSPIN=VSS VCCBPIN=VCC VSSBPIN=VSS}
C {devices/lab_pin.sym} 710 -120 0 1 {name=p4 lab=x2_Y}
C {devices/lab_pin.sym} 590 -140 0 0 {name=p5 lab=x2_A}
C {devices/lab_pin.sym} 590 -100 0 0 {name=p6 lab=x2_B}
