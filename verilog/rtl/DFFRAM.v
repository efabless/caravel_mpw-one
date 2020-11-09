`ifndef USE_CUSTOM_DFFRAM

module DFFRAM(
`ifdef LVS
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

module DFFRAM #( parameter COLS=1, parameter ROWS=4)
(
    CLK,
    WE,
    EN,
    Di,
    Do,
    A,
    VPWR,
    VGND
);

    input           CLK;
    input   [3:0]   WE;
    input           EN;
    input   [31:0]  Di;
    output  [31:0]  Do;
    input   [7:0]   A;

    input VPWR;
    input VGND;
    
    wire [31:0]     Di_buf;
    wire [31:0]     Do_pre;
    wire            CLK_buf;
    wire [3:0]      WE_buf;

    wire [31:0]     Do_B_0_0;
    wire [31:0]     Do_B_0_1;
    wire [31:0]     Do_B_0_2;
    wire [31:0]     Do_B_0_3;

    wire [3:0]      row_sel;

    sky130_fd_sc_hd__clkbuf_8 CLKBUF ( .VPWR(VPWR), .VGND(VGND), .VPB(VPWR), .VNB(VGND), .X(CLK_buf), .A(CLK));
    sky130_fd_sc_hd__clkbuf_8 WEBUF[3:0] ( .VPWR(VPWR), .VGND(VGND), .VPB(VPWR), .VNB(VGND), .X(WE_buf), .A(WE));
    sky130_fd_sc_hd__clkbuf_8 DIBUF[31:0] ( .VPWR(VPWR), .VGND(VGND), .VPB(VPWR), .VNB(VGND), .X(Di_buf), .A(Di));

    DEC2x4 DEC ( .VPWR(VPWR), .VGND(VGND), .EN(EN), .A(A[7:6]), .SEL(row_sel) );

    SRAM64x32 B_0_0 ( .VPWR(VPWR), .VGND(VGND), .CLK(CLK_buf), .WE(WE_buf), .EN(row_sel[0]), .Di(Di_buf), .Do(Do_B_0_0), .A(A[5:0]) );
    SRAM64x32 B_0_1 ( .VPWR(VPWR), .VGND(VGND), .CLK(CLK_buf), .WE(WE_buf), .EN(row_sel[1]), .Di(Di_buf), .Do(Do_B_0_1), .A(A[5:0]) );
    SRAM64x32 B_0_2 ( .VPWR(VPWR), .VGND(VGND), .CLK(CLK_buf), .WE(WE_buf), .EN(row_sel[2]), .Di(Di_buf), .Do(Do_B_0_2), .A(A[5:0]) );
    SRAM64x32 B_0_3 ( .VPWR(VPWR), .VGND(VGND), .CLK(CLK_buf), .WE(WE_buf), .EN(row_sel[3]), .Di(Di_buf), .Do(Do_B_0_3), .A(A[5:0]) );

    MUX4x1_32 MUX1 ( .VPWR(VPWR), .VGND(VGND), .A0(Do_B_0_0), .A1(Do_B_0_1), .A2(Do_B_0_2), .A3(Do_B_0_3), .S(A[7:6]), .X(Do_pre) );

    sky130_fd_sc_hd__clkbuf_4 DOBUF[31:0] ( .VPWR(VPWR), .VGND(VGND), .VPB(VPWR), .VNB(VGND), .X(Do), .A(Do_pre));

endmodule

`endif