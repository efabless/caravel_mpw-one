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

`include "la_wb.v"

module la_wb_tb;

    reg wb_clk_i;
	reg wb_rst_i;

    reg wb_stb_i;
    reg wb_cyc_i;
	reg wb_we_i;
	reg [3:0] wb_sel_i;

	reg [31:0] wb_dat_i;
	reg [31:0] wb_adr_i;

	wire wb_ack_o;
	wire [31:0] wb_dat_o;
    wire [127:0] la_data; 

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
        $dumpfile("la_wb_tb.vcd");
        $dumpvars(0, la_wb_tb);
        repeat (50) begin
            repeat (1000) @(posedge wb_clk_i);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Test Wishbone LA Failed");
        $display("%c[0m",27);
        $finish;
    end

    integer i;
    
    // LA Wishbone Internal Register Addresses
    wire [31:0] la_data_adr_0   = uut.BASE_ADR | uut.LA_DATA_0;
    wire [31:0] la_data_adr_1   = uut.BASE_ADR | uut.LA_DATA_1;
    wire [31:0] la_data_adr_2   = uut.BASE_ADR | uut.LA_DATA_2;
    wire [31:0] la_data_adr_3   = uut.BASE_ADR | uut.LA_DATA_3;
    
    wire [31:0] la_iena_adr_0 = uut.BASE_ADR | uut.LA_IENA_0;
    wire [31:0] la_iena_adr_1 = uut.BASE_ADR | uut.LA_IENA_1;
    wire [31:0] la_iena_adr_2 = uut.BASE_ADR | uut.LA_IENA_2;
    wire [31:0] la_iena_adr_3 = uut.BASE_ADR | uut.LA_IENA_3;

    wire [31:0] la_oenb_adr_0 = uut.BASE_ADR | uut.LA_OENB_0;
    wire [31:0] la_oenb_adr_1 = uut.BASE_ADR | uut.LA_OENB_1;
    wire [31:0] la_oenb_adr_2 = uut.BASE_ADR | uut.LA_OENB_2;
    wire [31:0] la_oenb_adr_3 = uut.BASE_ADR | uut.LA_OENB_3;

    reg [31:0] la_data_0;
    reg [31:0] la_data_1; 
    reg [31:0] la_data_2;
    reg [31:0] la_data_3; 

    reg [31:0] la_iena_0;
    reg [31:0] la_iena_1; 
    reg [31:0] la_iena_2;
    reg [31:0] la_iena_3; 

    reg [31:0] la_oenb_0;
    reg [31:0] la_oenb_1; 
    reg [31:0] la_oenb_2;
    reg [31:0] la_oenb_3; 

    initial begin
        // Reset Operation
        wb_rst_i = 1;
        #2;
        wb_rst_i = 0; 
        #2;

        // Write to la input enable registers
        la_iena_0 = 32'hF0F0_F0F0;
        la_iena_1 = 32'hA0A0_A0A0;
        la_iena_2 = 32'hB0B0_B0B0;
        la_iena_3 = 32'hC0C0_C0C0;

        write(la_iena_adr_0, la_iena_0);
        write(la_iena_adr_1, la_iena_1);
        write(la_iena_adr_2, la_iena_2);
        write(la_iena_adr_3, la_iena_3);

        #2;
        // Read from la input enable registers
        read(la_iena_adr_0);
        if (wb_dat_o !== la_iena_0) begin
            $display("Monitor: Error reading from la_iena_0 reg");
            $finish;
        end
        
        read(la_iena_adr_1);
        if (wb_dat_o !== la_iena_1) begin
            $display("Monitor: Error reading from la_iena_1 reg");
            $finish;
        end
        
        read(la_iena_adr_2);
        if (wb_dat_o !== la_iena_2) begin
            $display("Monitor: Error reading from la_iena_2 reg");
            $finish;
        end

        read(la_iena_adr_3);
        if (wb_dat_o !== la_iena_3) begin
            $display("Monitor: Error reading from la_iena_3 reg");
            $finish;
        end

        // Write to la output enable registers
        la_oenb_0 = 32'hC00C_0CC0;
        la_oenb_1 = 32'hD00D_0DD0;
        la_oenb_2 = 32'h0FF0_0FF0;
        la_oenb_3 = 32'hA00A_A00A;

        write(la_oenb_adr_0, la_oenb_0);
        write(la_oenb_adr_1, la_oenb_1);
        write(la_oenb_adr_2, la_oenb_2);
        write(la_oenb_adr_3, la_oenb_3);

        #2;
        // Read from la output enable registers
        read(la_oenb_adr_0);
        if (wb_dat_o !== la_oenb_0) begin
            $display("Monitor: Error reading from la_oenb_0 reg");
            $finish;
        end
        
        read(la_oenb_adr_1);
        if (wb_dat_o !== la_oenb_1) begin
            $display("Monitor: Error reading from la_oenb_1 reg");
            $finish;
        end
        
        read(la_oenb_adr_2);
        if (wb_dat_o !== la_oenb_2) begin
            $display("Monitor: Error reading from la_oenb_2 reg");
            $finish;
        end

        read(la_oenb_adr_3);
        if (wb_dat_o !== la_oenb_3) begin
            $display("Monitor: Error reading from la_oenb_3 reg");
            $finish;
        end

        // Write to la data registers
        la_data_0 = $urandom_range(0, 2**30);
        la_data_1 = $urandom_range(0, 2**30);
        la_data_2 = $urandom_range(0, 2**30);
        la_data_3 = $urandom_range(0, 2**30);

        write(la_data_adr_0, la_data_0);
        write(la_data_adr_1, la_data_1);
        write(la_data_adr_2, la_data_2);
        write(la_data_adr_3, la_data_3);

        // #2;
        // Read from la data registers
        #25;  
        if (la_data[31:0] !== la_data_0) begin
            $display("Monitor: Error reading from la data_0 reg");
            $finish;
        end
        
        if (la_data[63:32] !== la_data_1) begin
            $display("Monitor: Error reading from la data_1 reg");
            $finish;
        end
        
        if (la_data[95:64] !== la_data_2) begin
            $display("Monitor: Error reading from la data_2 reg");
            $finish;
        end

        if (la_data[127:96] !== la_data_3) begin
            $display("Monitor: Error reading from la data_3 reg");
            $finish;
        end
        #6;
        $display("Monitor: Test LA Wishbone Success!");
        $display("Monitor: Test LA Wishbone Passed!");
        $finish;
    end
    
    task write;
        input [32:0] addr;
        input [32:0] data;
        begin 
            @(posedge wb_clk_i) begin
                wb_stb_i = 1;
                wb_cyc_i = 1;
                wb_sel_i = 4'hF; 
                wb_we_i = 1;     
                wb_adr_i = addr;
                wb_dat_i = data;
                $display("Write Cycle Started.");
            end
            // Wait for an ACK
            wait(wb_ack_o == 1);
            wait(wb_ack_o == 0);
            wb_cyc_i = 0;
            wb_stb_i = 0;
            $display("Write Cycle Ended.");
        end
    endtask
    
    task read;
        input [32:0] addr;
        begin 
            @(posedge wb_clk_i) begin
                wb_stb_i = 1;
                wb_cyc_i = 1;
                wb_we_i = 0;
                wb_adr_i = addr;
                $display("Read Cycle Started.");
            end
            // Wait for an ACK
            wait(wb_ack_o == 1);
            wait(wb_ack_o == 0);
            wb_cyc_i = 0;
            wb_stb_i = 0;
            $display("Read Cycle Ended.");
        end
    endtask

    la_wb uut(
        .wb_clk_i(wb_clk_i),
	    .wb_rst_i(wb_rst_i),
        .wb_stb_i(wb_stb_i),
	    .wb_cyc_i(wb_cyc_i),
	    .wb_sel_i(wb_sel_i),
	    .wb_we_i(wb_we_i),
	    .wb_dat_i(wb_dat_i),
	    .wb_adr_i(wb_adr_i), 
        .wb_ack_o(wb_ack_o),
	    .wb_dat_o(wb_dat_o),
        .la_data(la_data)
    );

endmodule