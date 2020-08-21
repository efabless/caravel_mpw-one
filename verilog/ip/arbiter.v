module wb_arbiter #(
    parameter AW = 32,
    parameter DW = 32,
    parameter NM = 2
)(

    input wb_clk_i,
    input wb_rst_i,

    // Masters Interface
    input [NM-1:0] wbm_stb_i,
    input [NM-1:0] wbm_cyc_i,
    input [NM-1:0] wbm_we_i,
    input [NM*(DW/8)-1:0] wbm_sel_i,
    input [NM*DW-1:0] wbm_dat_i,
    input [NM*AW-1:0] wbm_adr_i,

    output [NM-1:0] wbm_ack_o,
    output [NM-1:0] wbm_err_o,
    output [NM*DW-1:0] wbm_dat_o,

    // Slave Interface
    input  wbs_ack_i, 
    input  wbs_err_i,               
    input  [DW-1:0] wbs_dat_i,      
    output reg wbs_stb_o,   
    output reg wbs_cyc_o,           
    output wbs_we_o,     
    output reg [(DW/8)-1:0] wbs_sel_o,       
    output reg [AW-1:0]  wbs_adr_o,   
    output reg [DW-1:0]  wbs_dat_o  
);

localparam SEL = DW / 8;

//  Current elected master (one hot)
reg [NM-1:0] cur_master;
reg capture_req;         

wire [NM-1:0] master_sel;  
wire [NM-1:0] requests;
wire any_req;
wire any_acks;

assign requests = wbm_cyc_i & wbm_stb_i;   
assign any_req = |requests;
assign any_ack = |{wbs_ack_i, wbs_err_i};

genvar iM;
generate 
    assign master_sel[0] = requests[0];
    for (iM=1; iM<NM; iM=iM+1) begin
      assign master_sel[iM] = requests[iM] & (~master_sel[iM-1]);
    end
endgenerate

// Current-elected master
always @(posedge wb_clk_i)
    if(wb_rst_i) begin
        cur_master <= {NM{1'b0}};
    end else if (capture_req) begin
        cur_master <= master_sel;
    end

// Finite State Machine
localparam IDLE = 1'b0;
localparam BUSY = 1'b1;

reg state = IDLE; 
reg next_state;       

always @(*)
begin: FSM_COMB
case (state)
    IDLE: if (any_req) begin
        wbs_stb_o = 1'b1;
        wbs_cyc_o = 1'b1;
        capture_req = 1'b1;
        next_state = BUSY;
    end else begin
        wbs_stb_o = 1'b0;
        wbs_cyc_o = 1'b0;
        capture_req = 1'b0;
        next_state = IDLE;
    end
    BUSY: begin
        if (any_ack & !any_req) begin
          next_state = IDLE;
        end if (any_ack & any_req) begin
           capture_req = 1'b1;
        end 
    end
    default: next_state = IDLE;
endcase
end

always @(posedge wb_clk_i)
    if (wb_rst_i)                                                
        state <= IDLE;
    else                                            
        state <= next_state;

// Masters Output Assignment   
assign wbm_dat_o = {NM{wbs_dat_i}};               
assign wbm_ack_o = {NM{wbs_ack_i}} & cur_master; 
assign wbm_err_o = {NM{wbs_err_i}} & cur_master; 

// Multiplexed signal to the slave

assign wbs_we_o = |(cur_master & wbm_we_i);    

integer k;
always @(*) begin
    wbs_sel_o = {SEL{1'b0}};
    for (k=0; k<(NM*SEL); k=k+1)
        wbs_sel_o[k%SEL] = wbs_sel_o[k%SEL] | (cur_master[k/SEL] & wbm_sel_i[k]);
end

integer l;
always @(*) begin
    wbs_adr_o = {AW{1'b0}};
    for (l=0; l<(NM*AW); l=l+1)
        wbs_adr_o[l%AW] = wbs_adr_o[l%AW] | (cur_master[l/AW] & wbm_adr_i[l]);
end

integer o;
always @(*) begin
    wbs_dat_o = {DW{1'b0}};
    for (o=0; o<(NM*DW); o=o+1)
        wbs_dat_o[o%DW] = wbs_dat_o[o%DW] | (cur_master[o/DW] & wbm_dat_i[o]);
end


endmodule

