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

module DFFRAM(
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

module DFFRAM #( parameter COLS=1)
(
`ifdef USE_POWER_PINS
    VPWR,
    VGND,
`endif
    CLK,
    WE,
    EN,
    Di,
    Do,
    A
);

    input           CLK;
    input   [3:0]   WE;
    input           EN;
    input   [31:0]  Di;
    output  [31:0]  Do;
    input   [7+$clog2(COLS):0]   A;

`ifdef USE_POWER_PINS
    input VPWR;
    input VGND;
`endif

    wire [31:0]     DOUT [COLS-1:0];
    wire [31:0]     Do_pre;
    wire [COLS-1:0] EN_lines;

    generate
        genvar i;
        for (i=0; i<COLS; i=i+1) begin : COLUMN
            DFFRAM_COL4 RAMCOLS (
                                `ifdef USE_POWER_PINS
                                    .VPWR(VPWR),
                                    .VGND(VGND),
                                `endif
                                    .CLK(CLK), 
                                    .WE(WE), 
                                    .EN(EN_lines[i]), 
                                    .Di(Di), 
                                    .Do(DOUT[i]), 
                                    .A(A[7:0]) 
                                );    
        end
        if(COLS==4) begin
            MUX4x1_32 MUX ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
            `endif
                .A0(DOUT[0]),
                .A1(DOUT[1]),
                .A2(DOUT[2]),
                .A3(DOUT[3]),
                .S(A[9:8]),
                .X(Do_pre)
            );
            DEC2x4 DEC (
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
            `endif 
                .EN(EN),
                .A(A[9:8]),
                .SEL(EN_lines)
            );
        end
        else if(COLS==2) begin
            MUX2x1_32 MUX ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
            `endif 
                .A0(DOUT[0]),
                .A1(DOUT[1]),
                .S(A[8]),
                .X(Do_pre)
            );
            //sky130_fd_sc_hd__inv_4 DEC0 ( .Y(EN_lines[0]), .A(A[8]) );
            //sky130_fd_sc_hd__clkbuf_4 DEC1 (.X(EN_lines[1]), .A(A[8]) );
            DEC1x2 DEC ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
            `endif 
                .EN(EN),
                .A(A[8]),
                .SEL(EN_lines[1:0]) 
            );
            
        end
        else begin
            PASS MUX ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
            `endif 
                .A(DOUT[0]),
                .X(Do_pre)
            );
            sky130_fd_sc_hd__clkbuf_4 ENBUF (
           `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
                .VPB(VPWR),
                .VNB(VGND),
            `endif 
                .X(EN_lines[0]),
                .A(EN)
            );
        end
    endgenerate
    
    sky130_fd_sc_hd__clkbuf_4 DOBUF[31:0] (
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif 
        .X(Do),
        .A(Do_pre)
    );

endmodule

`endif