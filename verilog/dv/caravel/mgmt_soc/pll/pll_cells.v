`timescale 1 ns / 1 ps

module __sky130_fd_sc_hd__a211o_4 (
    X   ,
    A1  ,
    A2  ,
    B1  ,
    C1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  C1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__a211o base (
        .X(X),
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .C1(C1),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
        (A1 +=> X) = (0:0:0,0:0:0);
        (A2 +=> X) = (0:0:0,0:0:0);
        if ((!A1&!A2&!C1)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((!A1&A2&!C1)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((A1&!A2&!C1)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((!A1&!A2&!B1)) (C1 +=> X) = (0:0:0,0:0:0);
        if ((!A1&A2&!B1)) (C1 +=> X) = (0:0:0,0:0:0);
        if ((A1&!A2&!B1)) (C1 +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__a21bo_4 (
    X   ,
    A1  ,
    A2  ,
    B1_N,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A1  ;
    input  A2  ;
    input  B1_N;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__a21bo base (
        .X(X),
        .A1(A1),
        .A2(A2),
        .B1_N(B1_N),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );


    specify
        (A1 +=> X) = (0:0:0,0:0:0);
        (A2 +=> X) = (0:0:0,0:0:0);
        if ((!A1&!A2)) (B1_N -=> X) = (0:0:0,0:0:0);
        if ((!A1&A2)) (B1_N -=> X) = (0:0:0,0:0:0);
        if ((A1&!A2)) (B1_N -=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__a21o_4 (
    X   ,
    A1  ,
    A2  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__a21o base (
        .X(X),
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A1 +=> X) = (0:0:0,0:0:0);
    (A2 +=> X) = (0:0:0,0:0:0);
    if ((!A1&!A2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((!A1&A2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((A1&!A2)) (B1 +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__a22oi_4 (
    Y   ,
    A1  ,
    A2  ,
    B1  ,
    B2  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  B2  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__a22oi base (
        .Y(Y),
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
        if ((A2&!B1&!B2)) (A1 -=> Y) = (0:0:0,0:0:0);
        if ((A2&!B1&B2)) (A1 -=> Y) = (0:0:0,0:0:0);
        if ((A2&B1&!B2)) (A1 -=> Y) = (0:0:0,0:0:0);
        if ((A1&!B1&!B2)) (A2 -=> Y) = (0:0:0,0:0:0);
        if ((A1&!B1&B2)) (A2 -=> Y) = (0:0:0,0:0:0);
        if ((A1&B1&!B2)) (A2 -=> Y) = (0:0:0,0:0:0);
        if ((!A1&!A2&B2)) (B1 -=> Y) = (0:0:0,0:0:0);
        if ((!A1&A2&B2)) (B1 -=> Y) = (0:0:0,0:0:0);
        if ((A1&!A2&B2)) (B1 -=> Y) = (0:0:0,0:0:0);
        if ((!A1&!A2&B1)) (B2 -=> Y) = (0:0:0,0:0:0);
        if ((!A1&A2&B1)) (B2 -=> Y) = (0:0:0,0:0:0);
        if ((A1&!A2&B1)) (B2 -=> Y) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__a2bb2o_4 (
    X   ,
    A1_N,
    A2_N,
    B1  ,
    B2  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A1_N;
    input  A2_N;
    input  B1  ;
    input  B2  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__a2bb2o base (
        .X(X),
        .A1_N(A1_N),
        .A2_N(A2_N),
        .B1(B1),
        .B2(B2),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
        if ((!A2_N&!B1&!B2)) (A1_N -=> X) = (0:0:0,0:0:0);
        if ((!A2_N&!B1&B2)) (A1_N -=> X) = (0:0:0,0:0:0);
        if ((!A2_N&B1&!B2)) (A1_N -=> X) = (0:0:0,0:0:0);
        if ((!A1_N&!B1&!B2)) (A2_N -=> X) = (0:0:0,0:0:0);
        if ((!A1_N&!B1&B2)) (A2_N -=> X) = (0:0:0,0:0:0);
        if ((!A1_N&B1&!B2)) (A2_N -=> X) = (0:0:0,0:0:0);
        if ((!A1_N&A2_N&B2)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((A1_N&!A2_N&B2)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((A1_N&A2_N&B2)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((!A1_N&A2_N&B1)) (B2 +=> X) = (0:0:0,0:0:0);
        if ((A1_N&!A2_N&B1)) (B2 +=> X) = (0:0:0,0:0:0);
        if ((A1_N&A2_N&B1)) (B2 +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__a32o_4 (
    X   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    B2  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  B2  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__a32o base (
        .X(X),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .B2(B2),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );


    specify
        if ((A2&A3&!B1&!B2)) (A1 +=> X) = (0:0:0,0:0:0);
        if ((A2&A3&!B1&B2)) (A1 +=> X) = (0:0:0,0:0:0);
        if ((A2&A3&B1&!B2)) (A1 +=> X) = (0:0:0,0:0:0);
        if ((A1&A3&!B1&!B2)) (A2 +=> X) = (0:0:0,0:0:0);
        if ((A1&A3&!B1&B2)) (A2 +=> X) = (0:0:0,0:0:0);
        if ((A1&A3&B1&!B2)) (A2 +=> X) = (0:0:0,0:0:0);
        if ((A1&A2&!B1&!B2)) (A3 +=> X) = (0:0:0,0:0:0);
        if ((A1&A2&!B1&B2)) (A3 +=> X) = (0:0:0,0:0:0);
        if ((A1&A2&B1&!B2)) (A3 +=> X) = (0:0:0,0:0:0);
        if ((!A1&!A2&!A3&B2)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((!A1&!A2&A3&B2)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((!A1&A2&!A3&B2)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((!A1&A2&A3&B2)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((A1&!A2&!A3&B2)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((A1&!A2&A3&B2)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((A1&A2&!A3&B2)) (B1 +=> X) = (0:0:0,0:0:0);
        if ((!A1&!A2&!A3&B1)) (B2 +=> X) = (0:0:0,0:0:0);
        if ((!A1&!A2&A3&B1)) (B2 +=> X) = (0:0:0,0:0:0);
        if ((!A1&A2&!A3&B1)) (B2 +=> X) = (0:0:0,0:0:0);
        if ((!A1&A2&A3&B1)) (B2 +=> X) = (0:0:0,0:0:0);
        if ((A1&!A2&!A3&B1)) (B2 +=> X) = (0:0:0,0:0:0);
        if ((A1&!A2&A3&B1)) (B2 +=> X) = (0:0:0,0:0:0);
        if ((A1&A2&!A3&B1)) (B2 +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__and2_4 (
    X   ,
    A   ,
    B   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A   ;
    input  B   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__and2 base (
        .X(X),
        .A(A),
        .B(B),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A +=> X) = (0:0:0,0:0:0);
    (B +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__and3_4 (
    X   ,
    A   ,
    B   ,
    C   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__and3 base (
        .X(X),
        .A(A),
        .B(B),
        .C(C),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A +=> X) = (0:0:0,0:0:0);
    (B +=> X) = (0:0:0,0:0:0);
    (C +=> X) = (0:0:0,0:0:0);
    endspecify


endmodule

module __sky130_fd_sc_hd__and4_4 (
    X   ,
    A   ,
    B   ,
    C   ,
    D   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__and4 base (
        .X(X),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A +=> X) = (0:0:0,0:0:0);
    (B +=> X) = (0:0:0,0:0:0);
    (C +=> X) = (0:0:0,0:0:0);
    (D +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__buf_2 (
    X   ,
    A   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__buf base (
        .X(X),
        .A(A),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
        (A +=> X ) = (0:0:0,0:0:0);  // delays are tris,tfall
    endspecify

endmodule

module __sky130_fd_sc_hd__clkbuf_1 (
    X   ,
    A   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__clkbuf base (
        .X(X),
        .A(A),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A +=> X ) = (0.0264154000,0.0334803000);  // delays are tris,tfall
    endspecify

endmodule

module __sky130_fd_sc_hd__clkbuf_2 (
    X   ,
    A   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__clkbuf base (
        .X(X),
        .A(A),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A +=> X ) = (0.0264154000,0.0334803000);  // delays are tris,tfall
    endspecify
endmodule

module __sky130_fd_sc_hd__clkinv_1 (
    Y   ,
    A   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Y   ;
    input  A   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__clkinv base (
        .Y(Y),
        .A(A),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A -=> Y ) = (0.0264154000,0.0334803000);  // delays are tris,tfall
    endspecify

endmodule

module __sky130_fd_sc_hd__clkinv_2 (
    Y   ,
    A   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Y   ;
    input  A   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__clkinv base (
        .Y(Y),
        .A(A),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A -=> Y ) = (0.0251409000,0.0267152000);  // delays are tris,tfall
    endspecify

endmodule

module __sky130_fd_sc_hd__clkinv_8 (
    Y   ,
    A   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Y   ;
    input  A   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__clkinv base (
        .Y(Y),
        .A(A),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A -=> Y ) = (0.0246892000,0.0242390000);  // delays are tris,tfall
    endspecify

endmodule

module __sky130_fd_sc_hd__conb_1 (
    HI  ,
    LO  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output HI  ;
    output LO  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__conb base (
        .HI(HI),
        .LO(LO),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

endmodule

module __sky130_fd_sc_hd__dfrtp_4 (
    Q      ,
    CLK    ,
    D      ,
    RESET_B,
    VPWR   ,
    VGND   ,
    VPB    ,
    VNB
);

    output Q      ;
    input  CLK    ;
    input  D      ;
    input  RESET_B;
    input  VPWR   ;
    input  VGND   ;
    input  VPB    ;
    input  VNB    ;
    sky130_fd_sc_hd__dfrtp base (
        .Q(Q),
        .CLK(CLK),
        .D(D),
        .RESET_B(RESET_B),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    // specify
    //     ( negedge RESET_B => ( Q +: RESET_B ) ) = 0:0:0 ;  // delay is tris
    //     ( posedge CLK => ( Q : CLK ) ) = ( 0:0:0 , 0:0:0 ) ; // delays are tris , tfall
    //     $recrem ( posedge RESET_B , posedge CLK , 0:0:0 , 0:0:0 , notifier , AWAKE , AWAKE , RESETB_delayed , CLK_delayed ) ;
    //     $setuphold ( posedge CLK , posedge D , 0:0:0 , 0:0:0 , notifier , COND0 , COND0 , CLK_delayed , D_delayed ) ;
    //     $setuphold ( posedge CLK , negedge D , 0:0:0 , 0:0:0 , notifier , COND0 , COND0 , CLK_delayed , D_delayed ) ;
    //     $width ( posedge CLK &&& COND1 , 1.0:1.0:1.0 , 0 , notifier ) ;
    //     $width ( negedge CLK &&& COND1 , 1.0:1.0:1.0 , 0 , notifier ) ;
    //     $width ( negedge RESET_B &&& AWAKE , 1.0:1.0:1.0 , 0 , notifier ) ;
    // endspecify

endmodule

module __sky130_fd_sc_hd__einvn_4 (
    Z   ,
    A   ,
    TE_B,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Z   ;
    input  A   ;
    input  TE_B;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__einvn base (
        .Z(Z),
        .A(A),
        .TE_B(TE_B),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    if (~TE_B ) (A -=> Z ) = (0.0533949000,0.0404211000);  // delays are tris,tfall
    (TE_B => Z ) = (0:0:0,0:0:0,0:0:0,0:0:0,0:0:0,0:0:0);  // delays are t01,t10,t0Z,tZ1,t1Z,tZ0
    endspecify
endmodule

module __sky130_fd_sc_hd__einvn_8 (
    Z   ,
    A   ,
    TE_B,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Z   ;
    input  A   ;
    input  TE_B;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__einvn base (
        .Z(Z),
        .A(A),
        .TE_B(TE_B),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    if (~TE_B ) (A -=> Z ) = (0.0443209000,0.0250073000);  // delays are tris,tfall
    (TE_B => Z ) = (0:0:0,0:0:0,0:0:0,0:0:0,0:0:0,0:0:0);  // delays are t01,t10,t0Z,tZ1,t1Z,tZ0
    endspecify

endmodule

module __sky130_fd_sc_hd__einvp_1 (
    Z   ,
    A   ,
    TE  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Z   ;
    input  A   ;
    input  TE  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__einvp base (
        .Z(Z),
        .A(A),
        .TE(TE),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    if (TE ) (A -=> Z ) = (0.0592396000,0.0300544000);  // delays are tris,tfall
    (TE => Z ) = (0:0:0,0:0:0,0:0:0,0:0:0,0:0:0,0:0:0);  // delays are t01,t10,t0Z,tZ1,t1Z,tZ0
    endspecify

endmodule

module __sky130_fd_sc_hd__einvp_2 (
    Z   ,
    A   ,
    TE  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Z   ;
    input  A   ;
    input  TE  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__einvp base (
        .Z(Z),
        .A(A),
        .TE(TE),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    if (TE ) (A -=> Z ) = (0.0431028000, 0.0248845000);  // delays are tris,tfall
    (TE => Z ) = (0:0:0,0:0:0,0:0:0,0:0:0,0:0:0,0:0:0);  // delays are t01,t10,t0Z,tZ1,t1Z,tZ0
    endspecify

endmodule

module __sky130_fd_sc_hd__inv_2 (
    Y   ,
    A   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Y   ;
    input  A   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__inv base (
        .Y(Y),
        .A(A),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A -=> Y ) = (0:0:0,0:0:0);  // delays are tris,tfall
    endspecify

endmodule

module __sky130_fd_sc_hd__nand2_4 (
    Y   ,
    A   ,
    B   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Y   ;
    input  A   ;
    input  B   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__nand2 base (
        .Y(Y),
        .A(A),
        .B(B),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A -=> Y) = (0:0:0,0:0:0);
    (B -=> Y) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__nor2_4 (
    Y   ,
    A   ,
    B   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Y   ;
    input  A   ;
    input  B   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__nor2 base (
        .Y(Y),
        .A(A),
        .B(B),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A -=> Y) = (0:0:0,0:0:0);
    (B -=> Y) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__o21a_4 (
    X   ,
    A1  ,
    A2  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__o21a base (
        .X(X),
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A1 +=> X) = (0:0:0,0:0:0);
    (A2 +=> X) = (0:0:0,0:0:0);
    if ((!A1&A2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((A1&!A2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((A1&A2)) (B1 +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__o21ai_4 (
    Y   ,
    A1  ,
    A2  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__o21ai base (
        .Y(Y),
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );


    specify
    (A1 -=> Y) = (0:0:0,0:0:0);
    (A2 -=> Y) = (0:0:0,0:0:0);
    if ((!A1&A2)) (B1 -=> Y) = (0:0:0,0:0:0);
    if ((A1&!A2)) (B1 -=> Y) = (0:0:0,0:0:0);
    if ((A1&A2)) (B1 -=> Y) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__o22a_4 (
    X   ,
    A1  ,
    A2  ,
    B1  ,
    B2  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  B2  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__o22a base (
        .X(X),
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    if ((!A2&!B1&B2)) (A1 +=> X) = (0:0:0,0:0:0);
    if ((!A2&B1&!B2)) (A1 +=> X) = (0:0:0,0:0:0);
    if ((!A2&B1&B2)) (A1 +=> X) = (0:0:0,0:0:0);
    if ((!A1&!B1&B2)) (A2 +=> X) = (0:0:0,0:0:0);
    if ((!A1&B1&!B2)) (A2 +=> X) = (0:0:0,0:0:0);
    if ((!A1&B1&B2)) (A2 +=> X) = (0:0:0,0:0:0);
    if ((!A1&A2&!B2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((A1&!A2&!B2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((A1&A2&!B2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((!A1&A2&!B1)) (B2 +=> X) = (0:0:0,0:0:0);
    if ((A1&!A2&!B1)) (B2 +=> X) = (0:0:0,0:0:0);
    if ((A1&A2&!B1)) (B2 +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__o32a_4 (
    X   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    B2  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  B2  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__o32a base (
        .X(X),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .B2(B2),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );  

    specify
    if ((!A2&!A3&!B1&B2)) (A1 +=> X) = (0:0:0,0:0:0);
    if ((!A2&!A3&B1&!B2)) (A1 +=> X) = (0:0:0,0:0:0);
    if ((!A2&!A3&B1&B2)) (A1 +=> X) = (0:0:0,0:0:0);
    if ((!A1&!A3&!B1&B2)) (A2 +=> X) = (0:0:0,0:0:0);
    if ((!A1&!A3&B1&!B2)) (A2 +=> X) = (0:0:0,0:0:0);
    if ((!A1&!A3&B1&B2)) (A2 +=> X) = (0:0:0,0:0:0);
    if ((!A1&!A2&!B1&B2)) (A3 +=> X) = (0:0:0,0:0:0);
    if ((!A1&!A2&B1&!B2)) (A3 +=> X) = (0:0:0,0:0:0);
    if ((!A1&!A2&B1&B2)) (A3 +=> X) = (0:0:0,0:0:0);
    if ((!A1&!A2&A3&!B2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((!A1&A2&!A3&!B2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((!A1&A2&A3&!B2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((A1&!A2&!A3&!B2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((A1&!A2&A3&!B2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((A1&A2&!A3&!B2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((A1&A2&A3&!B2)) (B1 +=> X) = (0:0:0,0:0:0);
    if ((!A1&!A2&A3&!B1)) (B2 +=> X) = (0:0:0,0:0:0);
    if ((!A1&A2&!A3&!B1)) (B2 +=> X) = (0:0:0,0:0:0);
    if ((!A1&A2&A3&!B1)) (B2 +=> X) = (0:0:0,0:0:0);
    if ((A1&!A2&!A3&!B1)) (B2 +=> X) = (0:0:0,0:0:0);
    if ((A1&!A2&A3&!B1)) (B2 +=> X) = (0:0:0,0:0:0);
    if ((A1&A2&!A3&!B1)) (B2 +=> X) = (0:0:0,0:0:0);
    if ((A1&A2&A3&!B1)) (B2 +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__or2_2 (
    X   ,
    A   ,
    B   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A   ;
    input  B   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__or2 base (
        .X(X),
        .A(A),
        .B(B),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );


    specify
    (A +=> X) = (0:0:0,0:0:0);
    (B +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__or2_4 (
    X   ,
    A   ,
    B   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A   ;
    input  B   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__or2 base (
        .X(X),
        .A(A),
        .B(B),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A +=> X) = (0:0:0,0:0:0);
    (B +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__or3_4 (
    X   ,
    A   ,
    B   ,
    C   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__or3 base (
        .X(X),
        .A(A),
        .B(B),
        .C(C),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A +=> X) = (0:0:0,0:0:0);
    (B +=> X) = (0:0:0,0:0:0);
    (C +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule

module __sky130_fd_sc_hd__or4_4 (
    X   ,
    A   ,
    B   ,
    C   ,
    D   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    sky130_fd_sc_hd__or4 base (
        .X(X),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    );

    specify
    (A +=> X) = (0:0:0,0:0:0);
    (B +=> X) = (0:0:0,0:0:0);
    (C +=> X) = (0:0:0,0:0:0);
    (D +=> X) = (0:0:0,0:0:0);
    endspecify

endmodule