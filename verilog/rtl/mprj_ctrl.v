module mprj_ctrl_wb #(
    parameter BASE_ADR = 32'h 2300_0000,
    parameter IO_PADS = 32,   // Number of IO control registers
    parameter PWR_CTRL = 32   // Number of power control registers
)(
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

    output [IO_PADS-1:0] output_en_n,
    output [IO_PADS-1:0] holdh_n,
    output [IO_PADS-1:0] enableh,
    output [IO_PADS-1:0] input_dis,
    output [IO_PADS-1:0] ib_mode_sel,
    output [IO_PADS-1:0] analog_en,
    output [IO_PADS-1:0] analog_sel,
    output [IO_PADS-1:0] analog_pol,
    output [IO_PADS*3-1:0] digital_mode
);

    wire resetn;
    wire valid;
    wire ready;
    wire [3:0] iomem_we;

    assign resetn = ~wb_rst_i;
    assign valid  = wb_stb_i && wb_cyc_i; 

    assign iomem_we = wb_sel_i & {4{wb_we_i}};
    assign wb_ack_o = ready;

    mprj_ctrl #(
        .BASE_ADR(BASE_ADR),
        .IO_PADS(IO_PADS),
        .PWR_CTRL(PWR_CTRL)
    ) mprj_ctrl (
        .clk(wb_clk_i),
        .resetn(resetn),
        .iomem_addr(wb_adr_i),
        .iomem_valid(valid),
        .iomem_wstrb(iomem_we),
        .iomem_wdata(wb_dat_i),
        .iomem_rdata(wb_dat_o),
        .iomem_ready(ready),
        .output_en_n(output_en_n),
        .holdh_n(holdh_n),
        .enableh(enableh),
        .input_dis(input_dis),
        .ib_mode_sel(ib_mode_sel),
        .analog_en(analog_en),
        .analog_sel(analog_sel),
        .analog_pol(analog_pol),
        .digital_mode(digital_mode)
    );

endmodule

module mprj_ctrl #(
    parameter BASE_ADR = 32'h 2300_0000,
    parameter IO_PADS = 32,
    parameter PWR_CTRL = 32
)(
    input clk,
    input resetn,

    input [31:0] iomem_addr,
    input iomem_valid,
    input [3:0] iomem_wstrb,
    input [31:0] iomem_wdata,

    output reg [31:0] iomem_rdata,
    output reg iomem_ready,

    output [IO_PADS-1:0] output_en_n,
    output [IO_PADS-1:0] holdh_n,
    output [IO_PADS-1:0] enableh,
    output [IO_PADS-1:0] input_dis,
    output [IO_PADS-1:0] ib_mode_sel,
    output [IO_PADS-1:0] analog_en,
    output [IO_PADS-1:0] analog_sel,
    output [IO_PADS-1:0] analog_pol,
    output [IO_PADS*3-1:0] digital_mode
);
	
    localparam PWR_BASE_ADR = BASE_ADR + IO_PADS*4;
    localparam OEB = 0;
    localparam HLDH = 1;
    localparam ENH  = 2;
    localparam INP_DIS = 3;
    localparam MOD_SEL = 4;
    localparam AN_EN = 5;
    localparam AN_SEL = 6;
    localparam AN_POL = 7;
    localparam DM = 8;

    reg [IO_PADS*32-1:0] io_ctrl;		
    reg [PWR_CTRL*32-1:0] pwr_ctrl;

    wire [IO_PADS-1:0] io_ctrl_sel;
    wire [PWR_CTRL-1:0] pwr_ctrl_sel;

    genvar i;
    generate
        for (i=0; i<IO_PADS; i=i+1) begin
            assign io_ctrl_sel[i] = (iomem_addr[7:0] == (BASE_ADR[7:0] + i*4)); 
            assign output_en_n[i]   = io_ctrl[i*32+OEB];
            assign holdh_n[i]  = io_ctrl[i*32+HLDH];
            assign enableh[i] = io_ctrl[i*32+ENH];
            assign input_dis[i] = io_ctrl[i*32+INP_DIS];
            assign ib_mode_sel[i] = io_ctrl[i*32+MOD_SEL];
            assign analog_en[i]  = io_ctrl[i*32+AN_EN];
            assign analog_sel[i] = io_ctrl[i*32+AN_SEL];
            assign analog_pol[i] = io_ctrl[i*32+AN_POL];
            assign digital_mode[(i+1)*3-1:i*3] = io_ctrl[i*32+DM+3-1:i*32+DM];
        end
    endgenerate

    generate
        for (i=0; i<PWR_CTRL; i=i+1) begin
            assign pwr_ctrl_sel[i] = (iomem_addr[7:0] == (PWR_BASE_ADR[7:0] + i*4)); 
        end
    endgenerate

    generate 
        for (i=0; i<IO_PADS; i=i+1) begin
             always @(posedge clk) begin
                if (!resetn) begin
                    io_ctrl[i*32+: 32]  <= 0;
                end else begin
                    iomem_ready <= 0;
                    if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
                        iomem_ready <= 1'b 1;

                        if (io_ctrl_sel[i]) begin
                            iomem_rdata <= io_ctrl[i*32+: 32];
                            if (iomem_wstrb[0])
                                io_ctrl[(i+1)*32-1-24:i*32]  <= iomem_wdata[7:0];
                            
                            if (iomem_wstrb[1])
                                io_ctrl[(i+1)*32-1-16:i*32+8] <= iomem_wdata[15:8];

                            if (iomem_wstrb[2])
                                io_ctrl[(i+1)*32-1-8:i*32+16] <= iomem_wdata[23:16];
                            
                            if (iomem_wstrb[3])
                                io_ctrl[(i+1)*32-1:i*32+24] <= iomem_wdata[31:24];
                        end 
                    end
                end
            end
        end
    endgenerate

    generate 
        for (i=0; i<PWR_CTRL; i=i+1) begin
             always @(posedge clk) begin
                if (!resetn) begin
                    pwr_ctrl[i*32+: 32]  <= 0;
                end else begin
                    iomem_ready <= 0;
                    if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
                        iomem_ready <= 1'b 1;

                        if (pwr_ctrl_sel[i]) begin
                            iomem_rdata <= pwr_ctrl[i*32+: 32];
                            if (iomem_wstrb[0])
                                pwr_ctrl[(i+1)*32-1-24:i*32]  <= iomem_wdata[7:0];
                            
                            if (pwr_ctrl_sel[1])
                                pwr_ctrl[(i+1)*32-1-16:i*32+8] <= iomem_wdata[15:8];

                            if (pwr_ctrl_sel[2])
                                pwr_ctrl[(i+1)*32-1-8:i*32+16] <= iomem_wdata[23:16];
                            
                            if (pwr_ctrl_sel[3])
                                pwr_ctrl[(i+1)*32-1:i*32+24]  <= iomem_wdata[31:24];
                        end 
                    end
                end
            end
        end
    endgenerate

endmodule