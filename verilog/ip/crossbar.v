
`include "distributor.v"
`include "arbiter.v"

module wb_xbar #(
    parameter NM = 2,  
    parameter NS = 4,   
    parameter AW = 32,  
    parameter DW = 32      
) (

    input wb_clk_i,           
    input wb_rst_i,     

    // Masters interface
    input [NM-1:0] wbm_cyc_i,       
    input [NM-1:0] wbm_stb_i,       
    input [NM-1:0] wbm_we_i,     
    input [(NM*(DW/8))-1:0] wbm_sel_i,     
    input [(NM*AW)-1:0] wbm_adr_i,        
    input [(NM*DW)-1:0] wbm_dat_i,       
    output [NM-1:0] wbm_ack_o, 
    output [NM-1:0] wbm_err_o,       
    output [(NM*DW)-1:0] wbm_dat_o,       

    // Slaves interfaces
    input [NS-1:0] wbs_ack_i,       
    input [(NS*DW)-1:0]  wbs_dat_i,
    output [NS-1:0] wbs_cyc_o,        
    output [NS-1:0] wbs_stb_o,       
    output [NS-1:0] wbs_we_o,        
    output [(NS*(DW/8))-1:0] wbs_sel_o,       
    output [(NS*AW)-1:0] wbs_adr_o,       
    output [(NS*DW)-1:0] wbs_dat_o       
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

   localparam SEL = DW / 8;

   wire [(NM*NS)-1:0] distributor_cyc_o;   
   wire [(NM*NS)-1:0] distributor_stb_o;  
   wire [(NM*NS)-1:0] distributor_we_o;    
   wire [(NM*NS*SEL)-1:0] distributor_sel_o; 
   wire [(NM*NS*AW)-1:0] distributor_adr_o;   
   wire [(NM*NS*DW)-1:0] distributor_dat_o;   
   wire [(NM*NS)-1:0]  distributor_ack_i;   
   wire [(NM*NS)-1:0]  distributor_err_i; 
   wire [(NM*NS)-1:0] distributor_rty_i;  
   wire [(NM*NS*DW)-1:0] distributor_dat_i;   

   //Arbiter busses:
   wire [(NM*NS)-1:0] arbiter_cyc_i;       
   wire [(NM*NS)-1:0] arbiter_stb_i;       
   wire [(NM*NS)-1:0] arbiter_we_i;       
   wire [(NM*NS*SEL)-1:0] arbiter_sel_i;       
   wire [(NM*NS*AW)-1:0] arbiter_adr_i;      
   wire [(NM*NS*DW)-1:0] arbiter_dat_i;      
   wire [(NM*NS)-1:0] arbiter_ack_o;      
   wire [(NM*NS)-1:0] arbiter_err_o;      
   wire [(NM*NS*DW)-1:0] arbiter_dat_o;     

   //Instantiate distributors
   generate
      genvar i;
      for (i=0; i<NM; i=i+1)
        begin
        distributor #(
            .NS(NS), 
            .AW(AW),   
            .DW(DW),
            .SLAVE_ADR(SLAVE_ADR),
            .ADR_MASK(ADR_MASK)
        ) distributor (
            .wb_clk_i(wb_clk_i),                                                                     
            .wb_rst_i(wb_rst_i),   
                                                                         
            .wbm_cyc_i(wbm_cyc_i[i]),                                                              
            .wbm_stb_i(wbm_stb_i[i]),                                                               
            .wbm_we_i(wbm_we_i[i]),                                                                
            .wbm_sel_i(wbm_sel_i[(SEL*(i+1))-1:(SEL*i)]),                              
            .wbm_adr_i(wbm_adr_i[(AW*(i+1))-1:(AW*i)]),                               
            .wbm_dat_i(wbm_dat_i[(DW*(i+1))-1:(DW*i)]),                               
            .wbm_ack_o(wbm_ack_o[i]),                                                  
            .wbm_dat_o(wbm_dat_o[(DW*(i+1))-1:(DW*i)]),                              
            
            // Slave interfaces
            .wbs_cyc_o (distributor_cyc_o[(NS*(i+1))-1:NS*i]),                             
            .wbs_stb_o (distributor_stb_o[(NS*(i+1))-1:NS*i]),                             
            .wbs_we_o  (distributor_we_o [(NS*(i+1))-1:NS*i]),                              
            .wbs_sel_o (distributor_sel_o[(NS*SEL*(i+1))-1:NS*SEL*i]),       
            .wbs_adr_o (distributor_adr_o[(NS*AW*(i+1))-1:NS*AW*i]),         
            .wbs_dat_o (distributor_dat_o[(NS*DW*(i+1))-1:NS*DW*i]),         
            .wbs_ack_i (distributor_ack_i[(NS*(i+1))-1:NS*i]),                           
            .wbs_dat_i (distributor_dat_i[(NS*DW*(i+1))-1:NS*DW*i])
        );        
        end
   endgenerate

   //Instantiate arbiters
   generate
      genvar j;
      for (j=0; j<NS; j=j+1)
        begin
           wb_arbiter #(
                .NM(NM),    
                .AW(AW), 
                .DW(DW)   
            ) arbiter (
                .wb_clk_i(wb_clk_i),                                                             
                .wb_rst_i(wb_rst_i),                                                    
                // Masters Interface
                .wbm_cyc_i (arbiter_cyc_i[(NM*(j+1))-1:NM*j]),                        
                .wbm_stb_i (arbiter_stb_i[(NM*(j+1))-1:NM*j]),                         
                .wbm_we_i  (arbiter_we_i [(NM*(j+1))-1:NM*j]),                          
                .wbm_sel_i (arbiter_sel_i[(NM*SEL*(j+1))-1:NM*SEL*j]),     
                .wbm_adr_i (arbiter_adr_i[(NM*AW*(j+1))-1:NM*AW*j]),     
                .wbm_dat_i (arbiter_dat_i[(NM*DW*(j+1))-1:NM*DW*j]),   
                .wbm_ack_o (arbiter_ack_o[(NM*(j+1))-1:NM*j]),                        
                .wbm_dat_o (arbiter_dat_o[(NM*DW*(j+1))-1:NM*DW*j]),    

                // Slave interfaces
                .wbs_cyc_o (wbs_cyc_o[j]),                                                       
                .wbs_stb_o (wbs_stb_o[j]),                                                       
                .wbs_we_o  (wbs_we_o[j]),                                                       
                .wbs_sel_o (wbs_sel_o[(SEL*(j+1))-1:(SEL*j)]),                      
                .wbs_adr_o (wbs_adr_o[(AW*(j+1))-1:(AW*j)]),                     
                .wbs_dat_o (wbs_dat_o[(DW*(j+1))-1:(DW*j)]),                      
                .wbs_ack_i (wbs_ack_i[j]),                                                      
                .wbs_dat_i (wbs_dat_i[(DW*(j+1))-1:(DW*j)])                    
            );
        end 
   endgenerate

   //Crossbar connections
   generate
      genvar k, l, m, indx;
      for (k=0; k<NM; k=k+1)
      for (l=0; l<NS; l=l+1)
        begin
          assign arbiter_cyc_i[(NM*l)+k] = distributor_cyc_o[(NS*k)+l];               
          assign arbiter_stb_i[(NM*l)+k] = distributor_stb_o[(NS*k)+l];               
          assign arbiter_we_i [(NM*l)+k] = distributor_we_o [(NS*k)+l];               
          
          assign arbiter_sel_i[(((NM*l)+k)*SEL)+(SEL-1):((NM*l)+k)*SEL] = 
                  distributor_sel_o[(((NS*k)+l)*SEL)+(SEL-1):((NS*k)+l)*SEL];            

          assign arbiter_adr_i[(((NM*l)+k)*AW)+(AW-1) : ((NM*l)+k)*AW] = 
                  distributor_adr_o[(((NS*k)+l)*AW)+(AW-1) : ((NS*k)+l)*AW];             
          
          assign arbiter_dat_i[(((NM*l)+k)*AW)+(AW-1) : ((NM*l)+k)*AW] = 
                  distributor_dat_o[(((NS*k)+l)*AW)+(AW-1) : ((NS*k)+l)*AW]; 

           assign distributor_dat_i[(((NS*k)+l)*DW)+(DW-1) : ((NS*k)+l)*DW] = 
                  arbiter_dat_o[(((NM*l)+k)*DW)+(DW-1) : ((NM*l)+k)*DW];      
          
          assign distributor_ack_i[(NS*k)+l] = arbiter_ack_o[(NM*l)+k];                            
        end
      endgenerate

endmodule 