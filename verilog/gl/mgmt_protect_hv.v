// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0
/* Generated by Yosys 0.9+3621 (git sha1 84e9fa7, gcc 8.3.1 -fPIC -Os) */

module mgmt_protect_hv(mprj2_vdd_logic1, mprj_vdd_logic1, vccd, vssd, vdda1, vssa1, vdda2, vssa2);
  output mprj2_vdd_logic1;
  wire mprj2_vdd_logic1_h;
  output mprj_vdd_logic1;
  wire mprj_vdd_logic1_h;
  input vccd;
  input vdda1;
  input vdda2;
  input vssa2;
  input vssa1;
  input vssd;
  sky130_fd_sc_hvl__conb_1 mprj2_logic_high_hvl (
    .HI(mprj2_vdd_logic1_h),
    .VGND(vssd),
    .VNB(vssd),
    .VPB(vdda2),
    .VPWR(vdda2)
  );
  sky130_fd_sc_hvl__lsbufhv2lv_1 mprj2_logic_high_lv (
    .A(mprj2_vdd_logic1_h),
    .LVPWR(vccd),
    .VGND(vssd),
    .VNB(vssd),
    .VPB(vdda2),
    .VPWR(vdda2),
    .X(mprj2_vdd_logic1)
  );
  sky130_fd_sc_hvl__conb_1 mprj_logic_high_hvl (
    .HI(mprj_vdd_logic1_h),
    .VGND(vssd),
    .VNB(vssd),
    .VPB(vdda1),
    .VPWR(vdda1)
  );
  sky130_fd_sc_hvl__lsbufhv2lv_1 mprj_logic_high_lv (
    .A(mprj_vdd_logic1_h),
    .LVPWR(vccd),
    .VGND(vssd),
    .VNB(vssd),
    .VPB(vdda1),
    .VPWR(vdda1),
    .X(mprj_vdd_logic1)
  );
  // assign vssd = vssa2;
  // assign vssa1 = vssa2;
endmodule
