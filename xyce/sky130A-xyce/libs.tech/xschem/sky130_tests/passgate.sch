v {xschem version=2.9.9 file_version=1.2 

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
N 320 -230 320 -200 {lab=VSSBPIN}
N 320 -470 320 -440 {lab=VCCBPIN}
N 270 -470 290 -470 { lab=A}
N 270 -340 270 -200 { lab=A}
N 270 -200 290 -200 { lab=A}
N 350 -200 370 -200 { lab=Z}
N 370 -340 370 -200 { lab=Z}
N 350 -470 370 -470 { lab=Z}
N 210 -340 270 -340 { lab=A}
N 370 -340 430 -340 { lab=Z}
N 320 -550 320 -510 { lab=GP}
N 280 -550 320 -550 { lab=GP}
N 320 -160 320 -120 { lab=GN}
N 280 -120 320 -120 { lab=GN}
N 270 -470 270 -340 { lab=A}
N 370 -470 370 -340 { lab=Z}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Stefan Schippers"}
C {devices/iopin.sym} 210 -340 0 1 {name=p1 lab=A}
C {devices/iopin.sym} 430 -340 0 0 {name=p2 lab=Z}
C {devices/ipin.sym} 280 -550 0 0 {name=p3 lab=GP}
C {devices/ipin.sym} 280 -120 0 0 {name=p4 lab=GN}
C {sky130_fd_pr/nfet_01v8.sym} 320 -180 1 1 {name=M1
L=L_N
W=W_N
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 320 -490 3 1 {name=M2
L=L_P
W=W_P
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {devices/lab_pin.sym} 320 -230 3 1 {name=p179 lab=VSSBPIN}
C {devices/lab_pin.sym} 320 -440 3 0 {name=p180 lab=VCCBPIN}
