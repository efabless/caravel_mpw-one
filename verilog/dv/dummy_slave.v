`default_nettype none
module dummy_slave(
    input wb_clk_i,
    input wb_rst_i,
    
    input wb_stb_i,
    input wb_cyc_i,
    input wb_we_i,
    input [3:0] wb_sel_i,
    input [31:0] wb_adr_i,
    input [31:0] wb_dat_i,
    
    output reg [31:0] wb_dat_o,
    output reg wb_ack_o
);
    reg [31:0] store;

    wire valid = wb_cyc_i & wb_stb_i;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i == 1'b 1) begin
            wb_ack_o <= 1'b 0;
        end else begin
            if (wb_we_i == 1'b 1) begin
                if (wb_sel_i[0]) store[7:0]   <= wb_dat_i[7:0];
                if (wb_sel_i[1]) store[15:8]  <= wb_dat_i[15:8];
                if (wb_sel_i[2]) store[23:16] <= wb_dat_i[23:16];
                if (wb_sel_i[3]) store[31:24] <= wb_dat_i[31:24];
            end
            wb_dat_o <= store;
            wb_ack_o <= valid & !wb_ack_o;
        end
    end
endmodule