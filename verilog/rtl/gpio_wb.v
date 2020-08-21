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

    input [15:0] gpio_in_pad,
    output [15:0] gpio,
    output [15:0] gpio_oeb,
    output [15:0] gpio_pu,
    output [15:0] gpio_pd
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
        .iomem_wstrb(iomem_we),
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

    input [15:0] gpio_in_pad,

    input [31:0] iomem_addr,
    input iomem_valid,
    input [3:0] iomem_wstrb,
    input [31:0] iomem_wdata,
    output reg [31:0] iomem_rdata,
    output reg iomem_ready,

    output [15:0] gpio,
    output [15:0] gpio_oeb,
    output [15:0] gpio_pu,
    output [15:0] gpio_pd
);

    reg [15:0] gpio;		// GPIO output data
    reg [15:0] gpio_pu;		// GPIO pull-up enable
    reg [15:0] gpio_pd;		// GPIO pull-down enable
    reg [15:0] gpio_oeb;    // GPIO output enable (sense negative)
    
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
                    iomem_rdata <= {gpio, gpio_in_pad};

                    if (iomem_wstrb[0]) gpio[ 7: 0] <= iomem_wdata[ 7: 0];
                    if (iomem_wstrb[1]) gpio[15: 8] <= iomem_wdata[15: 8];

                end else if (gpio_oeb_sel) begin
                    iomem_rdata <= {16'd0, gpio_oeb};

                    if (iomem_wstrb[0]) gpio_oeb[ 7: 0] <= iomem_wdata[ 7: 0];
                    if (iomem_wstrb[1]) gpio_oeb[15: 8] <= iomem_wdata[15: 8];

                end else if (gpio_pu_sel) begin
                    iomem_rdata <= {16'd0, gpio_pu};

                    if (iomem_wstrb[0]) gpio_pu[ 7: 0] <= iomem_wdata[ 7: 0];
                    if (iomem_wstrb[1]) gpio_pu[15: 8] <= iomem_wdata[15: 8];

                end else if (gpio_pd_sel) begin
                    iomem_rdata <= {16'd0, gpio_pd};          

                    if (iomem_wstrb[0]) gpio_pd[ 7: 0] <= iomem_wdata[ 7: 0];
                    if (iomem_wstrb[1]) gpio_pd[15: 8] <= iomem_wdata[15: 8];

                end

            end
        end
    end

endmodule