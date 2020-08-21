module wb_intercon #(
    parameter DW = 32,          // Data Width
    parameter AW = 32,          // Address Width
    parameter NS = 6           // Number of Slaves
) (
    // Master Interface
    input [AW-1:0] wbm_adr_i,
    input wbm_stb_i,

    output reg [DW-1:0] wbm_dat_o,
    output wbm_ack_o,

    // Slave Interface
    input [NS*DW-1:0] wbs_dat_i,
    input [NS-1:0] wbs_ack_i,
    output [NS-1:0] wbs_stb_o
);
    parameter [NS*AW-1:0] ADR_MASK = {      // Page & Sub-page bits
        {8'hFF, {24{1'b0}} },
        {8'hFF, {24{1'b0}} },
        {8'hFF, {24{1'b0}} },
        {8'hFF, {24{1'b0}} },
        {8'hFF, {24{1'b0}} },
        {8'hFF, {24{1'b0}} }
    };
    parameter [NS*AW-1:0] SLAVE_ADR = {
        {8'h28, {24{1'b0}} },    // Flash Configuration Register
        {8'h23, {24{1'b0}} },    // System Control
        {8'h21, {24{1'b0}} },    // GPIOs
        {8'h20, {24{1'b0}} },    // UART 
        {8'h10, {24{1'b0}} },    // Flash 
        {8'h00, {24{1'b0}} }     // RAM
    };
    
    wire [NS-1: 0] slave_sel;

    // Address decoder
    genvar iS;
    generate
        for (iS = 0; iS < NS; iS = iS + 1) begin
            assign slave_sel[iS] = 
                ((wbm_adr_i & ADR_MASK[(iS+1)*AW-1:iS*AW]) == SLAVE_ADR[(iS+1)*AW-1:iS*AW]);
        end
    endgenerate

    // Data-out Assignment
    assign wbm_ack_o = |(wbs_ack_i & slave_sel);
    assign wbs_stb_o =  {NS{wbm_stb_i}} & slave_sel;

    integer i;
    always @(*) begin
        wbm_dat_o = {DW{1'b0}};
        for (i=0; i<(NS*DW); i=i+1)
            wbm_dat_o[i%DW] = wbm_dat_o[i%DW] | (slave_sel[i/DW] & wbs_dat_i[i]);
    end
 
endmodule