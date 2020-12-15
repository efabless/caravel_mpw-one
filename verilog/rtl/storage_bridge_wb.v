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
module storage_bridge_wb (
    // MGMT_AREA R/W WB Interface
    input wb_clk_i,
    input wb_rst_i,

    input [31:0] wb_adr_i,
    input [31:0] wb_dat_i,
    input [3:0]  wb_sel_i,
    input wb_we_i,
    input wb_cyc_i,
    input [1:0] wb_stb_i,
    output reg [1:0] wb_ack_o,
    output reg [31:0] wb_rw_dat_o,

    // MGMT_AREA RO WB Interface   
    output [31:0] wb_ro_dat_o,

    // MGMT Area native memory interface
    output [`RAM_BLOCKS-1:0] mgmt_ena, 
    output [(`RAM_BLOCKS*4)-1:0] mgmt_wen_mask,
    output [`RAM_BLOCKS-1:0] mgmt_wen,
    output [7:0] mgmt_addr,
    output [31:0] mgmt_wdata,
    input  [(`RAM_BLOCKS*32)-1:0] mgmt_rdata,

    // MGMT_AREA RO Interface 
    output mgmt_ena_ro,
    output [7:0] mgmt_addr_ro,
    input  [31:0] mgmt_rdata_ro
);
    parameter [(`RAM_BLOCKS*24)-1:0] RW_BLOCKS_ADR = {
        {24'h 10_0000},
        {24'h 00_0000}
    };

    parameter [23:0] RO_BLOCKS_ADR = {
        {24'h 20_0000}
    };

    parameter ADR_MASK = 24'h FF_0000;

    wire [1:0] valid;
    wire [1:0] wen;
    wire [7:0] wen_mask;

    assign valid = {2{wb_cyc_i}} & wb_stb_i;
    assign wen   = wb_we_i & valid;    
    assign wen_mask = wb_sel_i & {{4{wen[1]}}, {4{wen[0]}}};

    // Ack generation
    reg [1:0] wb_ack_read;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i == 1'b 1) begin
            wb_ack_read <= 2'b0;
            wb_ack_o <= 2'b0;
        end else begin
            wb_ack_o <= wb_we_i? (valid & ~wb_ack_o): wb_ack_read;
            wb_ack_read <= (valid & ~wb_ack_o) & ~wb_ack_read;
        end
    end
    
    // Address decoding
    wire [`RAM_BLOCKS-1: 0] rw_sel;
    wire ro_sel;

    genvar iS;
    generate
        for (iS = 0; iS < `RAM_BLOCKS; iS = iS + 1) begin
            assign rw_sel[iS] = 
                ((wb_adr_i[23:0] & ADR_MASK) == RW_BLOCKS_ADR[(iS+1)*24-1:iS*24]);
        end
    endgenerate

    // Management R/W interface
    assign mgmt_ena = valid[0] ? ~rw_sel : {`RAM_BLOCKS{1'b1}}; 
    assign mgmt_wen = ~{`RAM_BLOCKS{wen[0]}};
    assign mgmt_wen_mask = {`RAM_BLOCKS{wen_mask[3:0]}};
    assign mgmt_addr  = wb_adr_i[9:2];
    assign mgmt_wdata = wb_dat_i[31:0];

    integer i;
    always @(*) begin
        wb_rw_dat_o = {32{1'b0}};
        for (i=0; i<(`RAM_BLOCKS*32); i=i+1)
            wb_rw_dat_o[i%32] = wb_rw_dat_o[i%32] | (rw_sel[i/32] & mgmt_rdata[i]);
    end

    // RO Interface
    assign ro_sel = ((wb_adr_i[23:0] & ADR_MASK) == RO_BLOCKS_ADR);
    assign mgmt_ena_ro = valid[1] ? ~ro_sel : 1'b1; 
    assign mgmt_addr_ro = wb_adr_i[9:2];
    assign wb_ro_dat_o = mgmt_rdata_ro;

endmodule
`default_nettype wire
