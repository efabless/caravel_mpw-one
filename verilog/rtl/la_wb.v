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
module la_wb # (
    parameter BASE_ADR  = 32'h 2200_0000,
    parameter LA_DATA_0 = 8'h00,
    parameter LA_DATA_1 = 8'h04,
    parameter LA_DATA_2 = 8'h08,
    parameter LA_DATA_3 = 8'h0c,
    parameter LA_ENA_0 = 8'h10,
    parameter LA_ENA_1 = 8'h14,
    parameter LA_ENA_2 = 8'h18,
    parameter LA_ENA_3 = 8'h1c
) (
    input wb_clk_i,
    input wb_rst_i,

    input [31:0] wb_dat_i,
    input [31:0] wb_adr_i,
    input [3:0] wb_sel_i,
    input wb_cyc_i,
    input wb_stb_i,
    input wb_we_i,

    output [31:0] wb_dat_o,
    output wb_ack_o,

    input  [127:0] la_data_in, // From MPRJ 
    output [127:0] la_data,
    output [127:0] la_oen
);

    wire resetn;
    wire valid;
    wire ready;
    wire [3:0] iomem_we;

    assign resetn = ~wb_rst_i;
    assign valid = wb_stb_i && wb_cyc_i; 

    assign iomem_we = wb_sel_i & {4{wb_we_i}};
    assign wb_ack_o = ready;

    la #(
        .BASE_ADR(BASE_ADR),
        .LA_DATA_0(LA_DATA_0),
        .LA_DATA_1(LA_DATA_1),
        .LA_DATA_2(LA_DATA_2),
        .LA_DATA_3(LA_DATA_3),
        .LA_ENA_0(LA_ENA_0),
        .LA_ENA_1(LA_ENA_1),
        .LA_ENA_2(LA_ENA_2),
        .LA_ENA_3(LA_ENA_3)
    ) la_ctrl (
        .clk(wb_clk_i),
        .resetn(resetn),
        .iomem_addr(wb_adr_i),
        .iomem_valid(valid),
        .iomem_wstrb(iomem_we),
        .iomem_wdata(wb_dat_i),
        .iomem_rdata(wb_dat_o),
        .iomem_ready(ready),
        .la_data_in(la_data_in),
        .la_data(la_data),
        .la_oen(la_oen)
    );
    
endmodule

module la #(
    parameter BASE_ADR  = 32'h 2200_0000,
    parameter LA_DATA_0 = 8'h00,
    parameter LA_DATA_1 = 8'h04,
    parameter LA_DATA_2 = 8'h08,
    parameter LA_DATA_3 = 8'h0c,
    parameter LA_ENA_0  = 8'h10,
    parameter LA_ENA_1  = 8'h14,
    parameter LA_ENA_2  = 8'h18,
    parameter LA_ENA_3  = 8'h1c
) (
    input clk,
    input resetn,

    input [31:0] iomem_addr,
    input iomem_valid,
    input [3:0] iomem_wstrb,
    input [31:0] iomem_wdata,

    output reg [31:0] iomem_rdata,
    output reg iomem_ready,

    input  [127:0] la_data_in, // From MPRJ 
    output [127:0] la_data,    // To MPRJ
    output [127:0] la_oen
);

    reg [31:0] la_data_0;		
    reg [31:0] la_data_1;		
    reg [31:0] la_data_2;		
    reg [31:0] la_data_3; 

    reg [31:0] la_ena_0;		
    reg [31:0] la_ena_1;		
    reg [31:0] la_ena_2;		
    reg [31:0] la_ena_3;    
    
    wire [3:0] la_data_sel;
    wire [3:0] la_ena_sel;

    assign la_data = {la_data_3, la_data_2, la_data_1, la_data_0};
    assign la_oen  = {la_ena_3, la_ena_2, la_ena_1, la_ena_0};

    assign la_data_sel = {
        (iomem_addr[7:0] == LA_DATA_3),
        (iomem_addr[7:0] == LA_DATA_2),
        (iomem_addr[7:0] == LA_DATA_1),
        (iomem_addr[7:0] == LA_DATA_0)
    };

    assign la_ena_sel = {
        (iomem_addr[7:0] == LA_ENA_3),
        (iomem_addr[7:0] == LA_ENA_2),
        (iomem_addr[7:0] == LA_ENA_1),
        (iomem_addr[7:0] == LA_ENA_0)
    };


    always @(posedge clk) begin
        if (!resetn) begin
            la_data_0 <= 0;
            la_data_1 <= 0;
            la_data_2 <= 0;
            la_data_3 <= 0;
            la_ena_0  <= 32'hFFFF_FFFF;  // default is tri-state buff disabled
            la_ena_1  <= 32'hFFFF_FFFF;
            la_ena_2  <= 32'hFFFF_FFFF;
            la_ena_3  <= 32'hFFFF_FFFF;
        end else begin
            iomem_ready <= 0;
            if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
                iomem_ready <= 1'b 1;
                
                if (la_data_sel[0]) begin
                    iomem_rdata <= la_data_0 | (la_data_in[31:0] & la_ena_0);

                    if (iomem_wstrb[0]) la_data_0[ 7: 0] <= iomem_wdata[ 7: 0];
                    if (iomem_wstrb[1]) la_data_0[15: 8] <= iomem_wdata[15: 8];
                    if (iomem_wstrb[2]) la_data_0[23:16] <= iomem_wdata[23:16];
                    if (iomem_wstrb[3]) la_data_0[31:24] <= iomem_wdata[31:24];

                end else if (la_data_sel[1]) begin
                    iomem_rdata <= la_data_1 | (la_data_in[63:32] & la_ena_1);

                    if (iomem_wstrb[0]) la_data_1[ 7: 0] <= iomem_wdata[ 7: 0];
                    if (iomem_wstrb[1]) la_data_1[15: 8] <= iomem_wdata[15: 8];
                    if (iomem_wstrb[2]) la_data_1[23:16] <= iomem_wdata[23:16];
                    if (iomem_wstrb[3]) la_data_1[31:24] <= iomem_wdata[31:24];

                end else if (la_data_sel[2]) begin
                    iomem_rdata <= la_data_2 | (la_data_in[95:64] & la_ena_2);

                    if (iomem_wstrb[0]) la_data_2[ 7: 0] <= iomem_wdata[ 7: 0];
                    if (iomem_wstrb[1]) la_data_2[15: 8] <= iomem_wdata[15: 8];
                    if (iomem_wstrb[2]) la_data_2[23:16] <= iomem_wdata[23:16];
                    if (iomem_wstrb[3]) la_data_2[31:24] <= iomem_wdata[31:24];

                end else if (la_data_sel[3]) begin
                    iomem_rdata <= la_data_3 | (la_data_in[127:96] & la_ena_3);

                    if (iomem_wstrb[0]) la_data_3[ 7: 0] <= iomem_wdata[ 7: 0];
                    if (iomem_wstrb[1]) la_data_3[15: 8] <= iomem_wdata[15: 8];
                    if (iomem_wstrb[2]) la_data_3[23:16] <= iomem_wdata[23:16];
                    if (iomem_wstrb[3]) la_data_3[31:24] <= iomem_wdata[31:24];
                end else if (la_ena_sel[0]) begin
                    iomem_rdata <= la_ena_0;

                    if (iomem_wstrb[0]) la_ena_0[ 7: 0] <= iomem_wdata[ 7: 0];
                    if (iomem_wstrb[1]) la_ena_0[15: 8] <= iomem_wdata[15: 8];
                    if (iomem_wstrb[2]) la_ena_0[23:16] <= iomem_wdata[23:16];
                    if (iomem_wstrb[3]) la_ena_0[31:24] <= iomem_wdata[31:24];
                end else if (la_ena_sel[1]) begin
                    iomem_rdata <= la_ena_1;

                    if (iomem_wstrb[0]) la_ena_1[ 7: 0] <= iomem_wdata[ 7: 0];
                    if (iomem_wstrb[1]) la_ena_1[15: 8] <= iomem_wdata[15: 8];
                    if (iomem_wstrb[2]) la_ena_1[23:16] <= iomem_wdata[23:16];
                    if (iomem_wstrb[3]) la_ena_1[31:24] <= iomem_wdata[31:24];
                end else if (la_ena_sel[2]) begin
                    iomem_rdata <= la_ena_2;

                    if (iomem_wstrb[0]) la_ena_2[ 7: 0] <= iomem_wdata[ 7: 0];
                    if (iomem_wstrb[1]) la_ena_2[15: 8] <= iomem_wdata[15: 8];
                    if (iomem_wstrb[2]) la_ena_2[23:16] <= iomem_wdata[23:16];
                    if (iomem_wstrb[3]) la_ena_2[31:24] <= iomem_wdata[31:24];
                end else if (la_ena_sel[3]) begin
                    iomem_rdata <= la_ena_3;

                    if (iomem_wstrb[0]) la_ena_3[ 7: 0] <= iomem_wdata[ 7: 0];
                    if (iomem_wstrb[1]) la_ena_3[15: 8] <= iomem_wdata[15: 8];
                    if (iomem_wstrb[2]) la_ena_3[23:16] <= iomem_wdata[23:16];
                    if (iomem_wstrb[3]) la_ena_3[31:24] <= iomem_wdata[31:24];
                end 
            end
        end
    end

endmodule
`default_nettype wire
