/* Level shifter (simplified model, as buffer only) */

module lvlshiftdown (
`ifdef LVS
        vpwr, vpb, vnb, vgnd,
`endif
        A,
        X
    );


`ifdef LVS
    input vpwr;
    input vpb;
    input vnb;
    input vgnd;
`endif

input A;
output X;

`ifdef LVS
    wire vpwr, vpb, vnb, vgnd;
`endif

wire A, X;

assign X = A;

endmodule   // lvlshiftdown
