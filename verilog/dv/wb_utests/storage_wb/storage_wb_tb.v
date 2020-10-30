
`define MGMT_BLOCKS 2
`define USER_BLOCKS 4

`define BASE_ADR { \
    {8'h07, {24{1'b0}} }, \   
    {8'h06, {24{1'b0}} }, \     
    {8'h05, {24{1'b0}} }, \    
    {8'h04, {24{1'b0}} }, \    
    {8'h03, {24{1'b0}} }, \    
    {8'h02, {24{1'b0}} }, \
    {8'h01, {24{1'b0}} }  \
}\


// `define DBG
`include "sram_1rw1r_32_256_8_sky130.v"
`include "storage.v"
`include "storage_bridge_wb.v"

module storage_tb;

    reg wb_clk_i;
    reg wb_rst_i;

    reg [31:0] wb_adr_i;
    reg [31:0] wb_dat_i;
    reg [3:0]  wb_sel_i;
    reg wb_we_i;
    reg wb_cyc_i;
    reg  [1:0] wb_stb_i;
    wire [1:0] wb_ack_o;
    wire [31:0] wb_mgmt_dat_o;

    // MGMT_AREA RO WB Interface (USER_BLOCKS)  
    wire [31:0] wb_user_dat_o;

    wire [`MGMT_BLOCKS-1:0] mgmt_ena;
    wire [(`MGMT_BLOCKS*4)-1:0] mgmt_wen_mask;
    wire [`MGMT_BLOCKS-1:0] mgmt_wen;
    wire [31:0] mgmt_wdata;
    wire [7:0] mgmt_addr;
    wire [(`MGMT_BLOCKS*32)-1:0] mgmt_rdata;
    wire [`USER_BLOCKS-1:0] mgmt_user_ena;
    wire [7:0] mgmt_user_addr;
    wire [(`USER_BLOCKS*32)-1:0] mgmt_user_rdata;

    // USER_AREA R/W Interface (USER_BLOCKS)
    reg user_clk;
    reg [`USER_BLOCKS-1:0] user_ena;
    reg [`USER_BLOCKS-1:0] user_wen;
    reg [(`USER_BLOCKS*4)-1:0] user_wen_mask;
    reg [7:0] user_addr;
    reg [31:0] user_wdata;
    wire [(`USER_BLOCKS*32)-1:0] user_rdata;

    // USER_AREA RO Interface (MGMT_BLOCS)
    reg [`MGMT_BLOCKS-1:0] user_mgmt_ena;
    reg [7:0] user_mgmt_addr;
    wire [(`MGMT_BLOCKS*32)-1:0] user_mgmt_rdata;

    initial begin
        // MGMT Ports
        wb_clk_i = 0;
        wb_rst_i = 0;
        wb_stb_i = 0; 
        wb_cyc_i = 0;  
        wb_sel_i = 0;  
        wb_we_i  = 0;  
        wb_dat_i = 0; 
        wb_adr_i = 0; 
        // User Ports
        user_clk = 0;
        user_ena = {`USER_BLOCKS{1'b1}};
        user_wen = {`USER_BLOCKS{1'b1}};
        user_addr = 0;
        user_wdata = 0;
        user_mgmt_ena = {`MGMT_BLOCKS{1'b1}};
        user_mgmt_addr = 0;
    end

    always #1 wb_clk_i = ~wb_clk_i;
    always #1 user_clk = ~user_clk;

    initial begin
        $dumpfile("storage_tb.vcd");
        $dumpvars(0, storage_tb);
        repeat (100) begin
            repeat (1000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test Storage Area Failed");
        $display("%c[0m",27);
        $finish;
    end

    reg [31:0] ref_data [255: 0];
    reg [32*(`MGMT_BLOCKS+`USER_BLOCKS)-1:0] base_adr = `BASE_ADR;
    reg [31:0] block_adr;
    integer i,j;

    initial begin
        // Reset Operation
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0;
        #2;

        // Test MGMT R/W port and user RO port
        for (i = 0; i< `MGMT_BLOCKS; i = i +1) begin
            for ( j = 0; j < 100; j = j + 1) begin 
                if (i == 0) begin
                    ref_data[j] = $urandom_range(0, 2**30);
                end
                block_adr = base_adr[32*i+:32] + j;
                mgmt_write(block_adr, ref_data[j]);
                #2;
            end
        end
        
        for (i = 0; i< `MGMT_BLOCKS; i = i +1) begin
            for ( j = 0; j < 100; j = j + 1) begin 
                block_adr = base_adr[32*i+:32] + j;
                mgmt_read(block_adr, 0);
                if (wb_mgmt_dat_o !== ref_data[j]) begin
                    $display("Monitor: MGMT R/W Operation Failed");
                    $finish;
                end
                
                user_mgmt_read(j,i);
                if (user_mgmt_rdata[32*i+:32] !== ref_data[j]) begin
                    $display("Monitor: User RO Operation Failed");
                    $finish;
                end
                #2;
            end
        end

        // Test user R/W port & MGMT RO port
        for (i = 0; i<`USER_BLOCKS; i = i +1) begin
            for ( j = 0; j < 100; j = j + 1) begin 
                if (i == 0) begin
                    ref_data[j] = $urandom_range(0, 2**30);
                end
                user_write(j, ref_data[j], i);
                #2;
            end
        end

        for (i = 0; i< `USER_BLOCKS; i = i +1) begin
            for ( j = 0; j < 100; j = j + 1) begin 
                user_read(j,i);
                if (user_rdata[32*i+:32] !== ref_data[j]) begin
                    $display("Monitor: User R/W Operation Failed");
                    $finish;
                end

                block_adr = base_adr[32*(i+`MGMT_BLOCKS)+:32] + j;
                mgmt_read(block_adr,1);
                if(wb_user_dat_o !== ref_data[j])begin
                    $display("Monitor: MGMT RO Operation Failed");
                    $finish;
                end
                #2;
            end
        end

        $display("Success");
        $finish;
    end
    
    task user_write;
        input [32:0] addr;
        input [32:0] data;
        input integer block;
        begin
            @(posedge user_clk) begin
                user_ena[block] = 0;
                user_wen[block] = 0;
                user_wen_mask[(block*4)+:4] = 4'b1111;
                user_wdata = data;
                user_addr = addr[7:0];
                $display("Write Cycle Started.");
            end
            #4;
            user_ena[block] = 1;
            user_wen_mask[(block*4)+:4] = 4'b0000;
            user_wen[block] = 1;
            $display("Write Cycle Ended.");
        end
    endtask

    task user_read;
        input [32:0] addr;
        input integer block;
        begin
            @(posedge user_clk) begin
                user_ena[block] = 0;
                user_addr = addr[7:0];
                $display("Read Cycle Started.");
            end
            #8;
            user_ena[block] = 1;
            $display("Read Cycle Ended.");
        end
    endtask

    task user_mgmt_read;
        input [32:0] addr;
        input integer block;
        begin
            @(posedge user_clk) begin
                user_mgmt_ena[block] = 0;
                user_mgmt_addr = addr[7:0];
                $display("Read Cycle Started.");
            end
            #8;
            $display("Read Cycle Ended.");
        end
    endtask

    task mgmt_write;
        input [32:0] addr;
        input [32:0] data;
        begin 
            @(posedge wb_clk_i) begin
                wb_stb_i[0] = 1;
                wb_cyc_i = 1;
                wb_sel_i = 4'hF; 
                wb_we_i = 1;     
                wb_adr_i = addr;
                wb_dat_i = data;
                $display("Write Cycle Started.");
            end
            // Wait for an ACK
            wait(wb_ack_o[0] == 1);
            wait(wb_ack_o[0] == 0);
            wb_cyc_i = 0;
            wb_stb_i[0] = 0;
            $display("Write Cycle Ended.");
        end
    endtask
    
    task mgmt_read;
        input [32:0] addr;
        input integer block;
        begin 
            @(posedge wb_clk_i) begin
                wb_stb_i[block] = 1;
                wb_cyc_i = 1;
                wb_we_i = 0;
                wb_adr_i = addr;
                $display("Read Cycle Started.");
            end
            // Wait for an ACK
            wait(wb_ack_o[block] == 1);
            wait(wb_ack_o[block] == 0);
            wb_cyc_i = 0;
            wb_stb_i[block] = 0;
            $display("Read Cycle Ended.");
        end
    endtask

    storage_bridge_wb #(
        .USER_BLOCKS(`USER_BLOCKS),
        .MGMT_BLOCKS(`MGMT_BLOCKS),
        .BASE_ADDR(`BASE_ADR)
    ) wb_bridge (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        .wb_adr_i(wb_adr_i),
        .wb_dat_i(wb_dat_i),
        .wb_sel_i(wb_sel_i),
        .wb_we_i(wb_we_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_stb_i(wb_stb_i),
        .wb_ack_o(wb_ack_o),
        .wb_mgmt_dat_o(wb_mgmt_dat_o),

    // MGMT_AREA RO WB Interface (USER_BLOCKS)  
        .wb_user_dat_o(wb_user_dat_o),

    // MGMT Area native memory interface
        .mgmt_ena(mgmt_ena), 
        .mgmt_wen_mask(mgmt_wen_mask),
        .mgmt_wen(mgmt_wen),
        .mgmt_addr(mgmt_addr),
        .mgmt_wdata(mgmt_wdata),
        .mgmt_rdata(mgmt_rdata),

    // MGMT_AREA RO Interface (USER_BLOCKS)
        .mgmt_user_ena(mgmt_user_ena),
        .mgmt_user_addr(mgmt_user_addr),
        .mgmt_user_rdata(mgmt_user_rdata)
    );


    storage  #(
        .MGMT_BLOCKS(`MGMT_BLOCKS),
        .USER_BLOCKS(`USER_BLOCKS)  
    ) uut (
        // Management R/W WB interface
        .mgmt_clk(wb_clk_i),
        .mgmt_ena(mgmt_ena),
        .mgmt_wen(mgmt_wen),
        .mgmt_wen_mask(mgmt_wen_mask),
        .mgmt_addr(mgmt_addr),
        .mgmt_wdata(mgmt_wdata),
        .mgmt_rdata(mgmt_rdata),
        // Management RO interface  
        .mgmt_user_ena(mgmt_user_ena),
        .mgmt_user_addr(mgmt_user_addr),
        .mgmt_user_rdata(mgmt_user_rdata),
        // User R/W interface
        .user_clk(user_clk),
        .user_ena(user_ena),
        .user_wen(user_wen),
        .user_wen_mask(user_wen_mask),
        .user_addr(user_addr), 
        .user_wdata(user_wdata),
        .user_rdata(user_rdata),
        // User RO interface
        .user_mgmt_ena(user_mgmt_ena),
        .user_mgmt_addr(user_mgmt_addr),
        .user_mgmt_rdata(user_mgmt_rdata)
    );


endmodule