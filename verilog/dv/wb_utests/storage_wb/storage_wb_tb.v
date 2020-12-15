// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
// `define DBG

`define STORAGE_BASE_ADR  32'h0100_0000

`include "defines.v"
`include "sram_1rw1r_32_256_8_sky130.v"
`include "storage.v"
`include "storage_bridge_wb.v"

module storage_tb;

    localparam [(`RAM_BLOCKS*24)-1:0] STORAGE_RW_ADR = {
        {24'h 10_0000},
        {24'h 00_0000}
    };

    localparam [23:0] STORAGE_RO_ADR = {
        {24'h 20_0000}
    };

    reg wb_clk_i;
    reg wb_rst_i;

    reg [31:0] wb_adr_i;
    reg [31:0] wb_dat_i;
    reg [3:0]  wb_sel_i;
    reg wb_we_i;
    reg wb_cyc_i;
    reg  [1:0] wb_stb_i;
    wire [1:0] wb_ack_o;
    wire [31:0] wb_rw_dat_o;

    // MGMT_AREA RO WB Interface  
    wire [31:0] wb_ro_dat_o;

    wire [`RAM_BLOCKS-1:0] mgmt_ena;
    wire [(`RAM_BLOCKS*4)-1:0] mgmt_wen_mask;
    wire [`RAM_BLOCKS-1:0] mgmt_wen;
    wire [31:0] mgmt_wdata;
    wire [7:0] mgmt_addr;
    wire [(`RAM_BLOCKS*32)-1:0] mgmt_rdata;
    wire ro_ena;
    wire [7:0] ro_addr;
    wire [31:0] ro_rdata;

    initial begin
        wb_clk_i = 0;
        wb_rst_i = 0;
        wb_stb_i = 0; 
        wb_cyc_i = 0;  
        wb_sel_i = 0;  
        wb_we_i  = 0;  
        wb_dat_i = 0; 
        wb_adr_i = 0; 
    end

    always #1 wb_clk_i = ~wb_clk_i;

    initial begin
        $dumpfile("storage.vcd");
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
    reg [(24*`RAM_BLOCKS)-1:0] storage_rw_adr = STORAGE_RW_ADR;
    reg [23:0] storage_ro_adr = STORAGE_RO_ADR;
    reg [31:0] block_adr;

    integer i,j;

    initial begin
        // Reset Operation
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0;
        #2;

        // Test MGMT R/W port and user RO port
        for (i = 0; i<`RAM_BLOCKS; i = i +1) begin
            for ( j = 0; j < 100; j = j + 1) begin 
                if (i == 0) begin
                    ref_data[j] = $urandom_range(0, 2**30);
                end
                block_adr = (storage_rw_adr[24*i+:24] + (j << 2))  | `STORAGE_BASE_ADR;
                write(block_adr, ref_data[j]);
                #2;
            end
        end
        
        for (i = 0; i<`RAM_BLOCKS; i = i +1) begin
            for ( j = 0; j < 100; j = j + 1) begin 
                block_adr = (storage_rw_adr[24*i+:24] + (j << 2))  | `STORAGE_BASE_ADR;
                read(block_adr, 0);
                if (wb_rw_dat_o !== ref_data[j]) begin
                    $display("Got %0h, Expected %0h from addr %0h: ",wb_rw_dat_o,ref_data[j], block_adr);
                    $display("Monitor: MGMT R/W Operation Failed");
                    $finish;
                end
                
                if (i == 0) begin
                    block_adr = (storage_ro_adr + (j << 2))  | `STORAGE_BASE_ADR;
                    read(block_adr, 1);
                    if (wb_ro_dat_o !== ref_data[j]) begin
                        $display("Monitor: MGMT RO Operation Failed");
                        $finish;
                    end
                end
                #2;
            end
        end

        $display("Success");
        $finish;
    end
    
    task write;
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
    
    task read;
        input [32:0] addr;
        input integer interface;
        begin 
            @(posedge wb_clk_i) begin
                wb_stb_i[interface] = 1;
                wb_cyc_i = 1;
                wb_we_i = 0;
                wb_adr_i = addr;
                $display("Read Cycle Started.");
            end
            // Wait for an ACK
            wait(wb_ack_o[interface] == 1);
            wait(wb_ack_o[interface] == 0);
            wb_cyc_i = 0;
            wb_stb_i[interface] = 0;
            $display("Read Cycle Ended.");
        end
    endtask

    storage_bridge_wb #(
        .RW_BLOCKS_ADR(STORAGE_RW_ADR),
        .RO_BLOCKS_ADR(STORAGE_RO_ADR)
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
        .wb_rw_dat_o(wb_rw_dat_o),

    // MGMT_AREA RO WB Interface  
        .wb_ro_dat_o(wb_ro_dat_o),

    // MGMT Area native memory interface
        .mgmt_ena(mgmt_ena), 
        .mgmt_wen_mask(mgmt_wen_mask),
        .mgmt_wen(mgmt_wen),
        .mgmt_addr(mgmt_addr),
        .mgmt_wdata(mgmt_wdata),
        .mgmt_rdata(mgmt_rdata),
    // MGMT_AREA RO Interface
        .mgmt_ena_ro(ro_ena),
        .mgmt_addr_ro(ro_addr),
        .mgmt_rdata_ro(ro_rdata)
    );

    storage uut (
        // Management R/W WB interface
        .mgmt_clk(wb_clk_i),
        .mgmt_ena(mgmt_ena),
        .mgmt_wen(mgmt_wen),
        .mgmt_wen_mask(mgmt_wen_mask),
        .mgmt_addr(mgmt_addr),
        .mgmt_wdata(mgmt_wdata),
        .mgmt_rdata(mgmt_rdata),
        // Management RO interface  
        .mgmt_ena_ro(ro_ena),
        .mgmt_addr_ro(ro_addr),
        .mgmt_rdata_ro(ro_rdata)
    );

endmodule