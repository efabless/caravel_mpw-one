
`timescale 1 ns / 1 ps

`include "distributor.v"
`include "dummy_slave.v"

`ifndef AW
    `define AW 32
`endif
`ifndef DW
    `define DW 32
`endif

`ifndef NS
    `define NS 4
`endif

`ifndef SLAVE_ADR
    `define SLAVE_ADR { \
        {8'hB0, {24{1'b0}}},\
        {8'hA0, {24{1'b0}}},\
        {8'h90, {24{1'b0}}},\
        {8'h80, {24{1'b0}}}\
    }\
`endif

`ifndef ADR_MASK
    `define ADR_MASK { \
        {8'hFF, {24{1'b0}}}, \
        {8'hFF, {24{1'b0}}}, \
        {8'hFF, {24{1'b0}}}, \
        {8'hFF, {24{1'b0}}}  \
    }\
`endif

module distributor_tb;

    localparam SEL = `DW / 8;

    reg wb_clk_i;           
    reg wb_rst_i;     

    // Masters interface
    reg wbm_cyc_i;       
    reg wbm_stb_i;       
    reg wbm_we_i;     
    reg [(`DW/8)-1:0] wbm_sel_i;     
    reg [`AW-1:0] wbm_adr_i;        
    reg [`DW-1:0] wbm_dat_i;       
    wire wbm_ack_o; 
    wire [`DW-1:0] wbm_dat_o;       

    // Slaves interfaces
    wire [`NS-1:0] wbs_ack_o;       
    wire [(`NS*`DW)-1:0] wbs_dat_i;
    wire [`NS-1:0] wbs_cyc_o;        
    wire [`NS-1:0] wbs_stb_o;       
    wire [`NS-1:0] wbs_we_o;        
    wire [(`NS*(`DW/8))-1:0] wbs_sel_o;       
    wire [(`NS*`AW)-1:0] wbs_adr_o;       
    wire [(`NS*`DW)-1:0] wbs_dat_o;  
    
    distributor #(
        .NS(`NS),
        .AW(`AW),
        .DW(`DW),
        .ADR_MASK(`ADR_MASK),
        .SLAVE_ADR(`SLAVE_ADR)
    )
    uut (
        .wb_clk_i(wb_clk_i),           
        .wb_rst_i(wb_rst_i),     
        // Masters interface
        .wbm_cyc_i(wbm_cyc_i),       
        .wbm_stb_i(wbm_stb_i),       
        .wbm_we_i (wbm_we_i),     
        .wbm_sel_i(wbm_sel_i),     
        .wbm_adr_i(wbm_adr_i),        
        .wbm_dat_i(wbm_dat_i),       
        .wbm_ack_o(wbm_ack_o), 
        .wbm_dat_o(wbm_dat_o),

        // Slaves interfaces
        .wbs_ack_i(wbs_ack_o),       
        .wbs_dat_i(wbs_dat_o),
        .wbs_cyc_o(wbs_cyc_o),        
        .wbs_stb_o(wbs_stb_o),       
        .wbs_we_o(wbs_we_o),        
        .wbs_sel_o(wbs_sel_o),       
        .wbs_adr_o(wbs_adr_o),       
        .wbs_dat_o(wbs_dat_i)     
    );

    // Instantiate four dummy slaves for testing
    dummy_slave dummy_slaves [`NS-1:0](
        .wb_clk_i({`NS{wb_clk_i}}),
        .wb_rst_i({`NS{wb_rst_i}}),
        .wb_stb_i(wbs_stb_o),
        .wb_cyc_i(wbs_cyc_o),
        .wb_we_i(wbs_we_o),
        .wb_sel_i(wbs_sel_o),
        .wb_adr_i(wbs_adr_o),
        .wb_dat_i(wbs_dat_i),
        .wb_dat_o(wbs_dat_o),
        .wb_ack_o(wbs_ack_o)
    );

    initial begin
        wb_clk_i  = 0;           
        wb_rst_i  = 0;     
        wbm_cyc_i = 0;       
        wbm_stb_i = 0;       
        wbm_we_i  = 0;     
        wbm_sel_i = 0;     
        wbm_adr_i = 0;        
        wbm_dat_i = 0;  
    end
   
    always #1 wb_clk_i = ~wb_clk_i;

    initial begin
        $dumpfile("distributor_tb.vcd");
        $dumpvars(0, distributor_tb);
        repeat (50) begin
            repeat (1000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test Distributor Failed");
        $display("%c[0m",27);
        $finish;
    end

    integer i;

    reg [`DW-1:0] slave_data;
    reg [`AW-1:0] slave_adr;

    initial begin
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0;
        #2;
        
        slave_adr = 32'h 8000_0000;
        slave_data = $urandom_range(0, 2**(`DW-2));
        write(slave_adr, slave_data);
        #2;
        read(slave_adr);
        if (wbm_dat_i !== slave_data) begin
          $display("Failed R/W from slave");
        end
        
        #2;
        slave_adr = 32'h 9000_0000;
        slave_data = $urandom_range(0, 2**(`DW-2));
        write(slave_adr, slave_data);
        #2;
        read(slave_adr);
        if (wbm_dat_i !== slave_data) begin
          $display("Failed R/W from slave");
        end
        #2;

        slave_adr = 32'h A000_0000;
        slave_data = $urandom_range(0, 2**(`DW-2));
        write(slave_adr, slave_data);
        #2;
        read(slave_adr);
        if (wbm_dat_i !== slave_data) begin
          $display("Failed R/W from slave");
        end
        
        #2;
        slave_adr = 32'h B000_0000;
        slave_data = $urandom_range(0, 2**(`DW-2));
        write(slave_adr, slave_data);
        #2;
        read(slave_adr);
        if (wbm_dat_i !== slave_data) begin
          $display("Failed R/W from slave");
        end


        $finish;
    end

    task read;
        input [`AW-1:0] addr;
        begin 
            @(posedge wb_clk_i) begin
                wbm_stb_i = 1;
                wbm_cyc_i = 1;
                wbm_we_i  = 0;
                wbm_adr_i = addr;
                $display("Read Cycle Started");
            end
            wait(wbm_ack_o);
            wait(!wbm_ack_o);
            wbm_stb_i = 0;
            wbm_cyc_i = 0;
            $display("Read cycle Ended");
        end
    endtask

    task write;
        input [`AW-1:0] adr;
        input [`DW-1:0] data;
        begin 
            @(posedge wb_clk_i) begin
                wbm_stb_i = 1;
                wbm_cyc_i = 1;
                wbm_we_i  = 1;
                wbm_sel_i = {SEL{1'b1}};
                wbm_adr_i = adr;
                wbm_dat_i = data;
                $display("Write cycle started");
            end
            wait(wbm_ack_o);
            wait(!wbm_ack_o);
            wbm_stb_i = 0;
            wbm_cyc_i = 0;
            $display("Write cycle ended.");
        end
    endtask

endmodule