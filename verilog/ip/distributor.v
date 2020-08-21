module distributor #(
    parameter AW = 32,
    parameter DW = 32,
    parameter NS = 4
) (
    input wb_clk_i,            
    input wb_rst_i,

    // Master Interface
    input  wbm_cyc_i,       
    input  wbm_stb_i,        
    input  wbm_we_i,         
    input [(DW/8)-1:0] wbm_sel_i,       
    input [AW-1:0] wbm_adr_i,        
    input [DW-1:0] wbm_dat_i,       
    output wbm_ack_o,       
    output reg [DW-1:0] wbm_dat_o,        

    // Slave interfaces
    input [NS-1:0] wbs_ack_i,       
    input [(NS*DW)-1:0] wbs_dat_i,      

    output [NS-1:0] wbs_cyc_o,       
    output [NS-1:0] wbs_stb_o,        
    output [NS-1:0] wbs_we_o,         
    output [(NS*(DW/8))-1:0]  wbs_sel_o,        
    output [(NS*AW)-1:0]  wbs_adr_o,      
    output [(NS*DW)-1:0]  wbs_dat_o

);

parameter ADR_MASK = {
    {8'hFF, {24{1'b0}}},
    {8'hFF, {24{1'b0}}},
    {8'hFF, {24{1'b0}}},
    {8'hFF, {24{1'b0}}}
};
    
parameter SLAVE_ADR = {
    {8'hB0, {24{1'b0}}},
    {8'hA0, {24{1'b0}}},
    {8'h90, {24{1'b0}}},
    {8'h80, {24{1'b0}}}
};

wire [NS-1:0] slave_sel;

// Decode Addresseses, then accordingly assign the slave signals
genvar iS;
generate
    for (iS = 0; iS < NS; iS = iS + 1) begin
        assign slave_sel[iS] = ((wbm_adr_i & ADR_MASK[(iS+1)*AW-1:iS*AW]) == SLAVE_ADR[(iS+1)*AW-1:iS*AW]);
    end
endgenerate

// Plain signal propagation to all target busses
assign wbs_we_o  = {NS{wbm_we_i}};                   //write enables
assign wbs_sel_o = {NS{wbm_sel_i}};                  //write data selects
assign wbs_adr_o = {NS{wbm_adr_i}};                  //address busses
assign wbs_dat_o = {NS{wbm_dat_i}};                  //write data busses

// Masked signal propagation to all target busses
assign wbs_cyc_o  =  slave_sel & {NS{wbm_cyc_i}};               // bus cycle indicators
assign wbs_stb_o  =  slave_sel & {NS{wbm_cyc_i}};               // access requests

// Multiplexed signal propagation to the initiator bus
assign wbm_ack_o = |{slave_sel & wbs_ack_i};         

integer i;
always @*                                                 
    begin
    wbm_dat_o = {DW{1'b0}};
    for (i=0; i<(DW*NS); i=i+1)
        wbm_dat_o[i%DW] = wbm_dat_o[i%DW] | (slave_sel[i/DW] & wbs_dat_i[i]);
    end

endmodule