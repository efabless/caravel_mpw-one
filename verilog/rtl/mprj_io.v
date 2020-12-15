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

// `default_nettype none
module mprj_io #(
    parameter AREA1PADS = 18	// Highest numbered pad in area 1
) (
    inout vddio,
    inout vssio,
    inout vdda,
    inout vssa,
    inout vccd,
    inout vssd,

    inout vdda1,
    inout vdda2,
    inout vssa1,
    inout vssa2,
    inout vccd1,
    inout vccd2,
    inout vssd1,
    inout vssd2,

    input vddio_q,
    input vssio_q,
    input analog_a,
    input analog_b,
    input porb_h,
    inout [`MPRJ_IO_PADS-1:0] io,
    input [`MPRJ_IO_PADS-1:0] io_out,
    input [`MPRJ_IO_PADS-1:0] oeb,
    input [`MPRJ_IO_PADS-1:0] hldh_n,
    input [`MPRJ_IO_PADS-1:0] enh,
    input [`MPRJ_IO_PADS-1:0] inp_dis,
    input [`MPRJ_IO_PADS-1:0] ib_mode_sel,
    input [`MPRJ_IO_PADS-1:0] vtrip_sel,
    input [`MPRJ_IO_PADS-1:0] slow_sel,
    input [`MPRJ_IO_PADS-1:0] holdover,
    input [`MPRJ_IO_PADS-1:0] analog_en,
    input [`MPRJ_IO_PADS-1:0] analog_sel,
    input [`MPRJ_IO_PADS-1:0] analog_pol,
    input [`MPRJ_IO_PADS*3-1:0] dm,
    output [`MPRJ_IO_PADS-1:0] io_in,
    inout [`MPRJ_IO_PADS-8:0] analog_io
);

    wire [`MPRJ_IO_PADS-1:0] loop1_io;
    wire [6:0] no_connect;

    sky130_ef_io__gpiov2_pad_wrapped  area1_io_pad [AREA1PADS - 1:0] (
	`USER1_ABUTMENT_PINS
	`ifndef	TOP_ROUTING
	    .PAD(io[AREA1PADS - 1:0]),
	`endif
	    .OUT(io_out[AREA1PADS - 1:0]),
	    .OE_N(oeb[AREA1PADS - 1:0]),
	    .HLD_H_N(hldh_n[AREA1PADS - 1:0]),
	    .ENABLE_H(enh[AREA1PADS - 1:0]),
	    .ENABLE_INP_H(loop1_io[AREA1PADS - 1:0]),
	    .ENABLE_VDDA_H(porb_h),
	    .ENABLE_VSWITCH_H(vssio),
	    .ENABLE_VDDIO(vccd),
	    .INP_DIS(inp_dis[AREA1PADS - 1:0]),
	    .IB_MODE_SEL(ib_mode_sel[AREA1PADS - 1:0]),
	    .VTRIP_SEL(vtrip_sel[AREA1PADS - 1:0]),
	    .SLOW(slow_sel[AREA1PADS - 1:0]),
	    .HLD_OVR(holdover[AREA1PADS - 1:0]),
	    .ANALOG_EN(analog_en[AREA1PADS - 1:0]),
	    .ANALOG_SEL(analog_sel[AREA1PADS - 1:0]),
	    .ANALOG_POL(analog_pol[AREA1PADS - 1:0]),
	    .DM(dm[AREA1PADS*3 - 1:0]),
	    .PAD_A_NOESD_H(),
	    .PAD_A_ESD_0_H({analog_io[AREA1PADS - 8:0], no_connect}),
	    .PAD_A_ESD_1_H(),
	    .IN(io_in[AREA1PADS - 1:0]),
	    .IN_H(),
	    .TIE_HI_ESD(),
	    .TIE_LO_ESD(loop1_io[AREA1PADS - 1:0])
    );

    sky130_ef_io__gpiov2_pad_wrapped area2_io_pad [`MPRJ_IO_PADS - AREA1PADS - 1:0] (
	`USER2_ABUTMENT_PINS
	`ifndef	TOP_ROUTING
	    .PAD(io[`MPRJ_IO_PADS - 1:AREA1PADS]),
	`endif
	    .OUT(io_out[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .OE_N(oeb[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .HLD_H_N(hldh_n[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .ENABLE_H(enh[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .ENABLE_INP_H(loop1_io[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .ENABLE_VDDA_H(porb_h),
	    .ENABLE_VSWITCH_H(vssio),
	    .ENABLE_VDDIO(vccd),
	    .INP_DIS(inp_dis[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .IB_MODE_SEL(ib_mode_sel[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .VTRIP_SEL(vtrip_sel[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .SLOW(slow_sel[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .HLD_OVR(holdover[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .ANALOG_EN(analog_en[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .ANALOG_SEL(analog_sel[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .ANALOG_POL(analog_pol[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .DM(dm[`MPRJ_IO_PADS*3 - 1:AREA1PADS*3]),
	    .PAD_A_NOESD_H(),
	    .PAD_A_ESD_0_H(analog_io[`MPRJ_IO_PADS - 8:AREA1PADS - 7]),
	    .PAD_A_ESD_1_H(),
	    .IN(io_in[`MPRJ_IO_PADS - 1:AREA1PADS]),
	    .IN_H(),
	    .TIE_HI_ESD(),
	    .TIE_LO_ESD(loop1_io[`MPRJ_IO_PADS - 1:AREA1PADS])
    );

endmodule
// `default_nettype wire
