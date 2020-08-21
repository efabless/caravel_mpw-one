
`timescale 1 ns / 1 ps

`include "arbiter.v"
`include "dummy_slave.v"

`ifndef AW
`define AW 32
`endif
`ifndef DW
`define DW 32
`endif
`ifndef NM
`define NM 2
`endif

module arbiter_wb_tb;
    
    localparam SEL = `DW / 8;

    reg wb_clk_i;
    reg wb_rst_i;

    // Masters Interface
    reg [`NM-1:0] wbm_stb_i;
    reg [`NM-1:0] wbm_cyc_i;
    reg [`NM-1:0] wbm_we_i;
    reg [`NM*SEL-1:0] wbm_sel_i;
    reg [`NM*`DW-1:0] wbm_dat_i;
    reg [`NM*`AW-1:0] wbm_adr_i;

    wire [`NM-1:0] wbm_ack_o;
    wire [`NM-1:0] wbm_err_o;
    wire [`NM*`DW-1:0] wbm_dat_o;

    // Slave Interface
    reg  wbs_ack_i;
    reg  wbs_err_i;               
    wire [`DW-1:0] wbs_dat_i;      
    wire wbs_stb_i;
    wire wbs_cyc_i;           
    wire wbs_we_i;    
    wire [SEL-1:0] wbs_sel_i;      
    wire [`AW-1:0] wbs_adr_i;   
    wire [`DW-1:0] wbs_dat_o; 

    wb_arbiter  #(
        .AW(`AW),
        .DW(`DW),
        .NM(`NM)
    ) uut (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        // Masters Interface
        .wbm_stb_i(wbm_stb_i),
        .wbm_cyc_i(wbm_cyc_i),
        .wbm_we_i(wbm_we_i),
        .wbm_sel_i(wbm_sel_i),
        .wbm_dat_i(wbm_dat_i),
        .wbm_adr_i(wbm_adr_i),

        .wbm_ack_o(wbm_ack_o),
        .wbm_err_o(wbm_err_o),
        .wbm_dat_o(wbm_dat_o),

        // Slave Interface
        .wbs_ack_i(wbs_ack_o), 
        .wbs_err_i(wbs_err_o),               
        .wbs_dat_i(wbs_dat_o),      
        .wbs_stb_o(wbs_stb_i),   
        .wbs_cyc_o(wbs_cyc_i),           
        .wbs_we_o(wbs_we_i),     
        .wbs_sel_o(wbs_sel_i),       
        .wbs_adr_o(wbs_adr_i),   
        .wbs_dat_o(wbs_dat_i)  
    );
    
    // Instantiate one dummy slave for testing
    dummy_slave dummy_slave (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wb_stb_i(wbs_stb_i),
        .wb_cyc_i(wbs_cyc_i),
        .wb_we_i(wbs_we_i),
        .wb_sel_i(wbs_sel_i),
        .wb_adr_i(wbs_adr_i),
        .wb_dat_i(wbs_dat_i),
        .wb_dat_o(wbs_dat_o),
        .wb_ack_o(wbs_ack_o)
    );
    
    always #1 wb_clk_i = ~wb_clk_i;

    initial begin
        wb_clk_i  = 0;
        wb_rst_i  = 0;
        wbm_stb_i = 0;
        wbm_cyc_i = 0;
        wbm_we_i  = 0;
        wbm_sel_i = 0;
        wbm_dat_i = 0;
        wbm_adr_i = 0;
        wbs_ack_i = 0; 
        wbs_err_i = 0;               
    end

    initial begin
        $dumpfile("arbiter_wb_tb.vcd");
        $dumpvars(0, arbiter_wb_tb);
        repeat (50) begin
            repeat (1000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test Arbiter Failed");
        $display("%c[0m",27);
        $finish;
    end


    reg [`DW-1:0] data;
    reg [`AW-1:0] address;

    integer i;

    initial begin
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0;
        #2;

        // Case 1: Initiate W/R requests from M0 -- MN
        for (i=0; i<`NM; i=i+1) begin
            data = $urandom_range(0, 255);
            address = $urandom_range(0, 255);
            write(address,data,i);
            #2;
            read(i);
            if (wbm_dat_i[i*`DW +: `DW] !== data) begin
                $display("Request Error from master %0b", i);
                $finish;
            end
        end 

        #10;

        // Case 2: Initiate W/R requests from MN -- M0
        for (i=`NM-1; i>=0; i=i-1) begin
            data = $urandom_range(0, 255);
            address = $urandom_range(0, 255);
            write(address,data,i);
            #2;
            read(i);
            if (wbm_dat_i[i*`DW +: `DW] !== data) begin
                $display("Request Error from master %0b", i);
                $finish;
            end
        end 

        // Case 3: Initiate concurrent W/R requests from all masters
        address = $urandom_range(0, 255);
        wbm_stb_i = {`NM{1'b1}};
        wbm_cyc_i = {`NM{1'b1}};
        wbm_we_i  = {`NM{1'b1}};
        wbm_sel_i = {`NM{4'hF}};
        wbm_adr_i = {`NM{address}};
        for (i=`NM-1; i>=0; i=i-1) begin
            wbm_dat_i[i*`DW+: `DW] = $urandom_range(0, 2**32);
        end

        // Make sure that served request is master 0 (highest priority)      
        wait(wbm_ack_o[0]);
        if (wbm_ack_o[`NM-1:1] !== 0) begin
          $display("Arbitration failed");
          $finish;
        end

        // Read
        wbm_we_i  = {`NM{1'b0}};
        wait(wbm_ack_o[0]);
       
        // Make sure that the second master doesn't receive an ack
        if (wbm_ack_o[`NM-1:1] !== 0) begin
          $display("Arbitration failed");
          $finish;
        end        
        #10;
        $finish;
    end

    task read;
        input mindex;
        begin 
            @(posedge wb_clk_i) begin
                wbm_stb_i[mindex] = 1;
                wbm_cyc_i[mindex] = 1;
                wbm_we_i[mindex]  = 0;
                $display("Read Cycle from master %0b started", mindex);
            end
            wait(wbm_ack_o[mindex]);
            wait(!wbm_ack_o[mindex]);
            wbm_stb_i[mindex] = 0;
            wbm_cyc_i[mindex] = 0;
            $display("Read Cycle from master %0b ended.", mindex);
        end
    endtask

    task write;
        input [`AW-1:0] adr;
        input [`DW-1:0] data;
        input integer mindex;

        begin 
            @(posedge wb_clk_i) begin
                wbm_stb_i[mindex] = 1;
                wbm_cyc_i[mindex] = 1;
                wbm_we_i[mindex]  = 1;
                wbm_sel_i[mindex*SEL+: SEL] = {SEL{1'b1}};
                wbm_adr_i[mindex*`AW+: `AW] = adr;
                wbm_dat_i[mindex*`DW+: `DW] = data;
                $display("Write Cycle from master %0b started", mindex);
            end
           
            wait(wbm_ack_o[mindex]);
            wait(!wbm_ack_o[mindex]);
            wbm_stb_i[mindex] = 0;
            wbm_cyc_i[mindex] = 0;
            $display("Write Cycle from master %0b ended.", mindex);
        end
    endtask

endmodule