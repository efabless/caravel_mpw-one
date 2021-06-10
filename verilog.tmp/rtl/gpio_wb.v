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
module gpio_wb # (
    parameter BASE_ADR  = 32'h 2100_0000,
    parameter GPIO_DATA = 8'h 00,
    parameter GPIO_ENA  = 8'h 04,
    parameter GPIO_PU   = 8'h 08,
    parameter GPIO_PD   = 8'h 0c
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

    input  gpio_in_pad,
    output gpio,
    output gpio_oeb,
    output gpio_pu,
    output gpio_pd
);

    wire resetn;
    wire valid;
    wire ready;
    wire [3:0] iomem_we;

    assign resetn = ~wb_rst_i;
    assign valid = wb_stb_i && wb_cyc_i; 

    assign iomem_we = wb_sel_i & {4{wb_we_i}};
    assign wb_ack_o = ready;

    gpio #(
        .BASE_ADR(BASE_ADR),
        .GPIO_DATA(GPIO_DATA),
        .GPIO_ENA(GPIO_ENA),
        .GPIO_PD(GPIO_PD),
        .GPIO_PU(GPIO_PU)
    ) gpio_ctrl (
        .clk(wb_clk_i),
        .resetn(resetn),

        .gpio_in_pad(gpio_in_pad),

        .iomem_addr(wb_adr_i),
        .iomem_valid(valid),
        .iomem_wstrb(iomem_we[0]),
        .iomem_wdata(wb_dat_i),
        .iomem_rdata(wb_dat_o),
        .iomem_ready(ready),

        .gpio(gpio),
        .gpio_oeb(gpio_oeb),
        .gpio_pu(gpio_pu),
        .gpio_pd(gpio_pd)
    );
    
endmodule

module gpio #(
    parameter BASE_ADR  = 32'h 2100_0000,
    parameter GPIO_DATA = 8'h 00,
    parameter GPIO_ENA  = 8'h 04,
    parameter GPIO_PU   = 8'h 08,
    parameter GPIO_PD   = 8'h 0c
) (
    input clk,
    input resetn,

    input gpio_in_pad,

    input [31:0] iomem_addr,
    input iomem_valid,
    input iomem_wstrb,
    input [31:0] iomem_wdata,
    output reg [31:0] iomem_rdata,
    output reg iomem_ready,

    output gpio,
    output gpio_oeb,
    output gpio_pu,
    output gpio_pd
);

    reg gpio;		// GPIO output data
    reg gpio_pu;		// GPIO pull-up enable
    reg gpio_pd;		// GPIO pull-down enable
    reg gpio_oeb;    // GPIO output enable (sense negative)
    
    wire gpio_sel;
    wire gpio_oeb_sel;
    wire gpio_pu_sel;  
    wire gpio_pd_sel;

    assign gpio_sel     = (iomem_addr[7:0] == GPIO_DATA);
    assign gpio_oeb_sel = (iomem_addr[7:0] == GPIO_ENA);
    assign gpio_pu_sel  = (iomem_addr[7:0] == GPIO_PU);
    assign gpio_pd_sel  = (iomem_addr[7:0] == GPIO_PD);

    always @(posedge clk) begin
        if (!resetn) begin
            gpio <= 0;
            gpio_oeb <= 16'hffff;
            gpio_pu <= 0;
            gpio_pd <= 0;
        end else begin
            iomem_ready <= 0;
            if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
                iomem_ready <= 1'b 1;
                
                if (gpio_sel) begin
                    iomem_rdata <= {30'd0, gpio, gpio_in_pad};
                    if (iomem_wstrb) gpio <= iomem_wdata[0];

                end else if (gpio_oeb_sel) begin
                    iomem_rdata <= {31'd0, gpio_oeb};
                    if (iomem_wstrb) gpio_oeb <= iomem_wdata[0];

                end else if (gpio_pu_sel) begin
                    iomem_rdata <= {31'd0, gpio_pu};
                    if (iomem_wstrb) gpio_pu <= iomem_wdata[0];

                end else if (gpio_pd_sel) begin
                    iomem_rdata <= {31'd0, gpio_pd};          
                    if (iomem_wstrb) gpio_pd <= iomem_wdata[0];

                end

            end
        end
    end

endmodule
`default_nettype wire
