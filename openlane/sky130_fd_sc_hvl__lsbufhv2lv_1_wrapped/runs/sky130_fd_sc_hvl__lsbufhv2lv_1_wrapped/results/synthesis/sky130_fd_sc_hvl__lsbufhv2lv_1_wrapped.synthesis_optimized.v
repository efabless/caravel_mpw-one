module sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped (A,
    X);
 input A;
 output X;

 sky130_fd_sc_hvl__lsbufhv2lv_1 lvlshiftdown (.A(A),
    .X(X));
endmodule
