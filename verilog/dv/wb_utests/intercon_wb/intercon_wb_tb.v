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


`timescale 1 ns / 1 ps

`include "wb_intercon.v"
`include "dummy_slave.v"

`define AW 32
`define DW 32
`define NS 6

`define SLAVE_ADR { \
    {8'h28, {24{1'b0}} }, \   
    {8'h23, {24{1'b0}} }, \     
    {8'h21, {24{1'b0}} }, \    
    {8'h20, {24{1'b0}} }, \    
    {8'h10, {24{1'b0}} }, \    
    {8'h00, {24{1'b0}} }  \
}\

`define ADR_MASK { \
    {8'hFF, {24{1'b0}} }, \
    {8'hFF, {24{1'b0}} }, \
    {8'hFF, {24{1'b0}} }, \
    {8'hFF, {24{1'b0}} }, \
    {8'hFF, {24{1'b0}} }, \
    {8'hFF, {24{1'b0}} }  \
}\

module intercon_wb_tb;

    localparam SEL = `DW / 8;

    reg wb_clk_i;
	reg wb_rst_i;

    // Master Interface
    reg wbm_stb_i;
    reg wbm_cyc_i;
    reg wbm_we_i;
    reg [SEL-1:0] wbm_sel_i;
    reg [`AW-1:0] wbm_adr_i;
    reg [`DW-1:0] wbm_dat_i;

    wire [`DW-1:0] wbm_dat_o;
    wire wbm_ack_o;

    // Wishbone Slave Interface
    wire [`NS-1:0] wbs_stb_i;
    wire [`NS-1:0] wbs_ack_o;
    wire [(`NS*`DW)-1:0] wbs_adr_i;
    wire [(`NS*`AW)-1:0] wbs_dat_i;
    wire [(`NS*`DW)-1:0] wbs_dat_o;

    initial begin
        wb_clk_i = 0; 
        wb_rst_i = 0;
        wbm_adr_i = 0;  
        wbm_dat_i = 0;  
        wbm_sel_i = 0;   
        wbm_we_i  = 0;    
        wbm_cyc_i = 0;   
        wbm_stb_i = 0;  
    end

    always #1 wb_clk_i = ~wb_clk_i;

    initial begin
        $dumpfile("intercon_wb_tb.vcd");
        $dumpvars(0, intercon_wb_tb);
        repeat (50) begin
            repeat (1000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test Wishbone Interconnect Failed");
        $display("%c[0m",27);
        $finish;
    end

    integer i;

    reg [`AW*`NS-1: 0] addr = `SLAVE_ADR;
    reg [`DW:0] slave_data;
    reg [`AW:0] slave_addr;

    initial begin
        // Reset Operation
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0; 
        #2;

        // W/R from all slaves
        for (i=0; i<`NS; i=i+1) begin
            slave_addr = addr[i*`AW +: `AW];
            slave_data = $urandom_range(0, 2**32);
            write(slave_addr, slave_data);
            #2;
            read(slave_addr);
            if (wbm_dat_o !== slave_data) begin
                $display("%c[1;31m",27);
                $display ("Monitor: Reading from slave %0d failed", i);
                $display("Monitor: Test Wishbone Interconnect failed");
                $display("%c[0m",27);
                $finish;
            end
        end
        $display("Monitor: Test Wishbone Interconnect Success!");
        $finish;
    end
    
    task write;
        input [`AW-1:0] addr;
        input [`AW-1:0] data;
        begin 
            @(posedge wb_clk_i) begin
                wbm_stb_i = 1;
                wbm_cyc_i = 1;
                wbm_sel_i = {SEL{1'b1}}; 
                wbm_we_i = 1;    
                wbm_adr_i = addr;
                wbm_dat_i = data;
                $display("Write Cycle Started.");
            end
            // Wait for an ACK
            wait(wbm_ack_o == 1);
            wait(wbm_ack_o == 0);
            wbm_cyc_i = 0;
            wbm_stb_i = 0;
            $display("Write Cycle Ended.");
        end
    endtask
    
    task read;
        input [`AW-1:0] addr;
        begin 
            @(posedge wb_clk_i) begin
                wbm_stb_i = 1;
                wbm_cyc_i = 1;
                wbm_adr_i = addr;
                wbm_we_i =  0;     
                $display("Read Cycle Started.");
            end
            // Wait for an ACK
            wait(wbm_ack_o == 1);
            wait(wbm_ack_o == 0);
            wbm_cyc_i = 0;
            wbm_stb_i = 0;
            $display("Read Cycle Ended.");
        
        end
    endtask

    wb_intercon #(
        .AW(`AW),
        .DW(`DW),
        .NS(`NS),
        .ADR_MASK(`ADR_MASK),
        .SLAVE_ADR(`SLAVE_ADR)
    ) uut(
        // Master Interface
        .wbm_adr_i(wbm_adr_i),
        .wbm_stb_i(wbm_stb_i),
        .wbm_dat_o(wbm_dat_o),
        .wbm_ack_o(wbm_ack_o), 
    
        // Slave Interface
        .wbs_stb_o(wbs_stb_i),
        .wbs_dat_i(wbs_dat_o), 
        .wbs_ack_i(wbs_ack_o)
    );
    
    // Instantiate five dummy slaves for testing
    dummy_slave dummy_slaves [`NS-1:0](
        .wb_clk_i({`NS{wb_clk_i}}),
        .wb_rst_i({`NS{wb_rst_i}}),
        .wb_stb_i(wbs_stb_i),
        .wb_cyc_i(wbm_cyc_i),
        .wb_we_i(wbm_we_i),
        .wb_sel_i(wbm_sel_i),
        .wb_adr_i(wbm_adr_i),
        .wb_dat_i(wbm_dat_i),
        .wb_dat_o(wbs_dat_o),
        .wb_ack_o(wbs_ack_o)
    );

endmodule