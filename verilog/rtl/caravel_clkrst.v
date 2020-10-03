module caravel_clkrst(
`ifdef LVS
    input vdd1v8,
    input vss,
`endif
    input ext_clk_sel,
    input ext_clk,
    input pll_clk,
    input resetb, 
    input ext_reset,	// NOTE: positive sense reset
    output core_clk,
    output resetb_sync
);

    // Clock assignment (to do:  make this glitch-free)
    assign core_clk = (ext_clk_sel == 1'b1) ? ext_clk : pll_clk;

    // Reset assignment.  "reset" comes from POR, while "ext_reset"
    // comes from standalone SPI (and is normally zero unless
    // activated from the SPI).

    // Staged-delay reset
    reg [2:0] reset_delay;

    always @(posedge core_clk or negedge resetb) begin
        if (resetb == 1'b0) begin
        reset_delay <= 3'b111;
        end else begin
        reset_delay <= {1'b0, reset_delay[2:1]};
        end
    end

    assign resetb_sync = ~(reset_delay[0] | ext_reset);

endmodule
