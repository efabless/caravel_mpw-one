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

`default_nettype none
`ifndef USE_CUSTOM_DFFRAM

module DFFRAM_1K (
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input CLK,
    input [3:0] WE,
    input EN,
    input [31:0] Di,
    output reg [31:0] Do,
    input [7:0] A
);
  

reg [31:0] mem [0:`MEM_WORDS-1];

always @(posedge CLK) begin
    if (EN == 1'b1) begin
        Do <= mem[A];
        if (WE[0]) mem[A][ 7: 0] <= Di[ 7: 0];
        if (WE[1]) mem[A][15: 8] <= Di[15: 8];
        if (WE[2]) mem[A][23:16] <= Di[23:16];
        if (WE[3]) mem[A][31:24] <= Di[31:24];
    end
end
endmodule

`else

module DFFRAM #(parameter   USE_LATCH=`DFFRAM_USE_LATCH,
                            WSIZE=`DFFRAM_WSIZE ) 
(
`ifdef USE_POWER_PINS
    input wire VPWR,
    input wire VGND,
`endif
    input   wire                CLK,    // FO: 2
    input   wire [WSIZE-1:0]     WE,     // FO: 2
    input                       EN,     // FO: 2
    input   wire [7:0]          A,      // FO: 5
    input   wire [(WSIZE*8-1):0] Di,     // FO: 2
    output  wire [(WSIZE*8-1):0] Do

);

    wire [1:0]             SEL;
    wire [(WSIZE*8-1):0]    Do_pre[1:0]; 

    // 1x2 DEC
    DEC1x2 DEC (
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
    `endif
        .EN(EN),
        .A(A[7]),
        .SEL(SEL)
    );

    // sky130_fd_sc_hd__inv_2 DEC (
    //  `ifdef USE_POWER_PINS
    //     .VPWR(VPWR),
    //     .VGND(VGND),
    //     .VPB(VPWR),
    //     .VNB(VGND),
    // `endif
    //     .Y(SEL[0]), .A(A[7]));
    // assign SEL[1] = A[7];

    generate
        genvar i;
        for (i=0; i< 2; i=i+1) begin : BLOCK
            RAM128 #(.USE_LATCH(USE_LATCH), .WSIZE(WSIZE)) RAM128 (
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
            `endif
                .CLK(CLK), .EN(SEL[i]), .WE(WE), .Di(Di), .Do(Do_pre[i]), .A(A[6:0]) );        
        end
     endgenerate

    // Output MUX    
    MUX2x1 #(.WIDTH(WSIZE*8)) DoMUX ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
    `endif
        .A0(Do_pre[0]), .A1(Do_pre[1]), .S(A[7]), .X(Do) );

endmodule

`endif