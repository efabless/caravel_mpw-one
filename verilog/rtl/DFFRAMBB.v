/*
    Building blocks for DFF based RAM compiler for SKY130 
    WORD        :   32-bit memory word with select and byte-level WE
    DEC6x64     :   6x64 Binary decoder
    SRAM64x32   :   Tri-state based 64x32 DFF RAM 
*/

module BYTE (
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input CLK,
    input WE,
    input SEL,
    input [7:0] Di,
    output [7:0] Do
);

    wire [7:0]  q_wire;
    wire        we_wire;
    wire        SEL_B;
    wire        GCLK;

    sky130_fd_sc_hd__inv_1 INV( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .Y(SEL_B),
        .A(SEL)
    );
   
    sky130_fd_sc_hd__and2_1 CGAND( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .A(SEL),
        .B(WE),
        .X(we_wire)
    );

    sky130_fd_sc_hd__dlclkp_1 CG( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .CLK(CLK),
        .GCLK(GCLK),
        .GATE(we_wire)
    );

    generate 
        genvar i;
        for(i=0; i<8; i=i+1) begin : BIT
            sky130_fd_sc_hd__dfxtp_1 FF ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
                .VPB(VPWR),
                .VNB(VGND),
            `endif
                .D(Di[i]),
                .Q(q_wire[i]),
                .CLK(GCLK)
            );
            sky130_fd_sc_hd__ebufn_2 OBUF ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
                .VPB(VPWR),
                .VNB(VGND),
            `endif
                .A(q_wire[i]),
                .Z(Do[i]),
                .TE_B(SEL_B)
            );
        end
    endgenerate 

endmodule


module WORD32 (
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input CLK,
    input [3:0] WE,
    input SEL,
    input [31:0] Di,
    output [31:0] Do
);

    BYTE B0 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
    `endif
        .CLK(CLK),
        .WE(WE[0]),
        .SEL(SEL),
        .Di(Di[7:0]),
        .Do(Do[7:0]) 
    );
    BYTE B1 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
    `endif
        .CLK(CLK),
        .WE(WE[1]),
        .SEL(SEL),
        .Di(Di[15:8]), 
        .Do(Do[15:8])
    );
    BYTE B2 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
    `endif
        .CLK(CLK), 
        .WE(WE[2]),
        .SEL(SEL),
        .Di(Di[23:16]),
        .Do(Do[23:16]) 
    );

    BYTE B3 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
    `endif
        .CLK(CLK),
        .WE(WE[3]),
        .SEL(SEL),
        .Di(Di[31:24]),
        .Do(Do[31:24]) 
    );
    
endmodule 

module DEC2x4 (
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input           EN,
    input   [1:0]   A,
    output  [3:0]   SEL
);
    sky130_fd_sc_hd__nor3b_2 AND0 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .Y(SEL[0]),
        .A(A[0]),
        .B(A[1]),
        .C_N(EN)
    );
    sky130_fd_sc_hd__and3b_2    AND1 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[1]),
        .A_N(A[1]),
        .B(A[0]),
        .C(EN) 
    );
    
    sky130_fd_sc_hd__and3b_2 AND2 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[2]),
        .A_N(A[0]),
        .B(A[1]),
        .C(EN) 
    );

    sky130_fd_sc_hd__and3_2 AND3 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[3]),
        .A(A[1]), 
        .B(A[0]),
        .C(EN) 
    );
    
endmodule

module DEC3x8 (
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input           EN,
    input [2:0]     A,
    output [7:0]    SEL
);
    sky130_fd_sc_hd__nor4b_2   AND0  ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .Y(SEL[0]),
        .A(A[0]),
        .B(A[1]),
        .C(A[2]), 
        .D_N(EN)
    ); // 000

    sky130_fd_sc_hd__and4bb_2   AND1 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[1]),
        .A_N(A[2]),
        .B_N(A[1]),
        .C(A[0]),
        .D(EN) 
    ); // 001

    sky130_fd_sc_hd__and4bb_2   AND2 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[2]),
        .A_N(A[2]),
        .B_N(A[0]),
        .C(A[1]),
        .D(EN) 
    ); // 010

    sky130_fd_sc_hd__and4b_2    AND3 (
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif 
        .X(SEL[3]),
        .A_N(A[2]),
        .B(A[1]),
        .C(A[0]),
        .D(EN) 
    );   // 011
    
    sky130_fd_sc_hd__and4bb_2   AND4 (  
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif  
        .X(SEL[4]),
        .A_N(A[0]),
        .B_N(A[1]),
        .C(A[2]),
        .D(EN) 
    ); // 100
    
    sky130_fd_sc_hd__and4b_2  AND5 (  
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif  
        .X(SEL[5]),
        .A_N(A[1]),
        .B(A[0]),
        .C(A[2]),
        .D(EN) 
    );   // 101
    
    sky130_fd_sc_hd__and4b_2    AND6 (  
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(SEL[6]),
        .A_N(A[0]),
        .B(A[1]),
        .C(A[2]),
        .D(EN)
    );   // 110
   
    sky130_fd_sc_hd__and4_2     AND7 (  
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif 
        .X(SEL[7]),
        .A(A[0]),
        .B(A[1]),
        .C(A[2]),
        .D(EN)
    ); // 111
endmodule


module DEC6x64 (
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input           EN,
    input   [5:0]   A,
    output  [63:0] SEL
);
    wire [7:0] SEL0_w ;
    DEC3x8 DEC_L0 ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
    `endif
        .EN(EN), .A(A[5:3]), .SEL(SEL0_w) );

    generate
        genvar i;
        for(i=0; i<8; i=i+1) begin : DEC_L1
            DEC3x8 U ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
            `endif
                .EN(SEL0_w[i]), .A(A[2:0]), .SEL(SEL[7+8*i: 8*i]) );
        end
    endgenerate
endmodule

module MUX4x1_32(
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input   [31:0]      A0, A1, A2, A3,
    input   [1:0]       S,
    output  [31:0]      X
);
    sky130_fd_sc_hd__mux4_1 MUX[31:0] (  
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif  
        .A0(A0), .A1(A1), .A2(A2), .A3(A3), .S0(S[0]), .S1(S[1]), .X(X) );
endmodule

module SRAM64x32(
`ifdef USE_POWER_PINS
    input VPWR,
    input VGND,
`endif
    input CLK,
    input [3:0] WE,
    input EN,
    input [31:0] Di,
    output [31:0] Do,
    input [5:0] A
);

    wire [63:0]     SEL;
    wire [31:0]     Do_pre;
    wire [31:0]     Di_buf;
    wire            CLK_buf;
    wire [3:0]      WE_buf;

    sky130_fd_sc_hd__clkbuf_16 CLKBUF (  
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif
        .X(CLK_buf),
        .A(CLK)
    );

    sky130_fd_sc_hd__clkbuf_16 WEBUF[3:0] (  
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif  
        .X(WE_buf),
        .A(WE)
    );

    sky130_fd_sc_hd__clkbuf_16 DIBUF[31:0] (  
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif  
        .X(Di_buf),
        .A(Di)
    );

    DEC6x64 DEC  ( 
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
    `endif
        .EN(EN),
        .A(A),
        .SEL(SEL)
    );

    generate
        genvar i;
        for (i=0; i< 64; i=i+1) begin : WORD
            WORD32 W ( 
            `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
            `endif
                .CLK(CLK_buf),
                .WE(WE_buf),
                .SEL(SEL[i]),
                .Di(Di_buf),
                .Do(Do_pre)
            );
        end
    endgenerate

    // Ensure that the Do_pre lines are not floating when EN = 0
    sky130_fd_sc_hd__ebufn_4 FLOATBUF[31:0] (  
    `ifdef USE_POWER_PINS
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPWR),
        .VNB(VGND),
    `endif  
        .A({32{EN}}),
        .Z(Do_pre),
        .TE_B({32{EN}})
    );

    generate 
        //genvar i;
        for(i=0; i<32; i=i+1) begin : OUT
            sky130_fd_sc_hd__dfxtp_1 FF ( 
             `ifdef USE_POWER_PINS
                .VPWR(VPWR),
                .VGND(VGND),
                .VPB(VPWR),
                .VNB(VGND),
             `endif  
                .D(Do_pre[i]),
                .Q(Do[i]),
                .CLK(CLK)
            );
        end
    endgenerate 

endmodule

