module mprj_ctrl_wb #(
    parameter BASE_ADR = 32'h 2300_0000,
    parameter DATA   = 8'h 00,
    parameter XFER   = 8'h 04,
    parameter CONFIG = 8'h 08,
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

    // Output is to serial loader
    output serial_clock,
    output serial_resetn,
    output serial_data_out,

    // Read/write data to each GPIO pad from management SoC
    inout [IO_PADS-1:0] mgmt_gpio_io
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
	.DATA(DATA),
        .CONFIG(CONFIG),
        .XFER(XFER),
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

	.serial_clock(serial_clock),
	.serial_resetn(serial_resetn),
	.serial_data_out(serial_data_out),
	.mgmt_gpio_io(mgmt_gpio_io)
    );

endmodule

module mprj_ctrl #(
    parameter BASE_ADR = 32'h 2300_0000,
    parameter DATA   = 8'h 00,
    parameter XFER   = 8'h 04,
    parameter CONFIG = 8'h 08,
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

    output serial_clock,
    output serial_resetn,
    output serial_data_out,
    inout [IO_PADS-1:0] mgmt_gpio_io
);
	
    localparam IO_BASE_ADR = (BASE_ADR | CONFIG);
    localparam PWR_BASE_ADR = (BASE_ADR | CONFIG) + IO_PADS*4;
    localparam OEB = 1;			// Offset of OEB in shift register block.

    reg [IO_PADS*32-1:0] io_ctrl;	// I/O control, 1 word per gpio pad
    reg [PWR_CTRL*32-1:0] pwr_ctrl;	// Power control, 1 word per power pad
    reg [IO_PADS-1:0] mgmt_gpio_out;	// I/O read/write data, 1 bit per gpio pad
    reg xfer_ctrl;			// Transfer control (1 bit)

    wire [IO_PADS-1:0] io_ctrl_sel;	// wishbone selects
    wire [PWR_CTRL-1:0] pwr_ctrl_sel;
    wire io_data_sel;
    wire xfer_sel;

    assign xfer_sel = (iomem_addr[7:0] == XFER);
    assign io_data_sel = (iomem_addr[7:0] == DATA); 

    // Direction of mgmt_gpio_io depends on the value of io_ctrl pad bit 1 (OEB)
    // if OEB = 0 then mgmt_gpio_out --> mgmt_gpio_io;  if OEB = 1 then
    // mgmt_gpio_io --> mgmt_gpio_in.  mgmt_gpio_in is always a copy of mgmt_gpio_io.

    assign mgmt_gpio_in = mgmt_gpio_io;

    genvar i;
    generate
        for (i=0; i<IO_PADS; i=i+1) begin
            assign io_ctrl_sel[i] = (iomem_addr[7:0] == (IO_BASE_ADR[7:0] + i*4)); 
            assign mgmt_gpio_io[i] = (io_ctrl[i*32] + OEB == 1'b0) ?
				mgmt_gpio_out[i] : 1'bz;
        end
    endgenerate

    generate
        for (i=0; i<PWR_CTRL; i=i+1) begin
            assign pwr_ctrl_sel[i] = (iomem_addr[7:0] == (PWR_BASE_ADR[7:0] + i*4)); 
        end
    endgenerate

    // I/O transfer of xfer bit and gpio data to/from user project region under
    // management SoC control

    always @(posedge clk) begin
	if (!resetn) begin
	    xfer_ctrl <= 0;
	    mgmt_gpio_out <= 'd0;
	end else begin
	    iomem_ready <= 0;
	    if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADDR[31:8]) begin
		iomem_ready <= 1'b 1;

		if (io_data_sel) begin
		    iomem_rdata <= mgmt_gpio_in;
		    mgmt_gpio_out <= 'd0;
		    if (iomem_wstrb[0]) mgmt_gpio_out[IO_PADS-1:0] <= iomem_wdata[IO_PADS-1:0];

		end else if (xfer_sel) begin
		    iomem_rdata <= {31'd0, xfer_ctrl};
		    if (iomem_wstrb[0]) xfer_ctrl <= iomem_wdata[1:0];
		end
	    end
	end
    end

    generate 
        for (i=0; i<IO_PADS; i=i+1) begin
             always @(posedge clk) begin
                if (!resetn) begin
                    io_ctrl[i*32+: 32]  <= 0;
                end else begin
                    if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
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
                    if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
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

    // Instantiate the GPIO transfer circuit

    gpio_transfer_data #(
	.NUM_GPIO_PADS(IO_PADS),
	.PAD_CTRL_BITS(14)
    ) gpio_xfer (
	.resetn(resetn),
	.clock(clk),
	.pad_configure(io_ctrl),
	.serial_clock(serial_clock),
	.serial_resetn(serial_resetn),
	.serial_data_out(serial_data_out)
    );

endmodule

/*
 *----------------------------------------------------
 *
 * This module initiates a write to the shift register
 * chain from registered data in the processor core.
 *
 *----------------------------------------------------
 */

`define START	2'b00
`define XBYTE	2'b01
`define LOAD	2'b10

module gpio_transfer_data #(
    parameter NUM_GPIO_PADS = 32,
    parameter PAD_CTRL_BITS = 13
) (
    input resetn,
    input clock,
    input [NUM_GPIO_PADS*PAD_CTRL_BITS-1:0] pad_configure,

    output	 serial_clock,
    output	 serial_resetn,
    output 	 serial_data_out
);
    reg [3:0]  xfer_count;
    reg [5:0]  pad_count;
    reg [1:0]  xfer_state;
    reg	       serial_clock;
    reg	       serial_resetn;
    reg	       serial_data_out;
    reg [PAD_CTRL_BITS-1:0] serial_data_staging;

    integer i;

    always @(posedge clock or negedge resetn) begin
	if (resetn == 1'b0) begin

	    xfer_state <= `START;
	    xfer_count <= 4'd0;
	    pad_count  <= 6'd0;
	    serial_resetn <= 1'b0;
	    serial_clock <= 1'b0;
	    serial_data_out <= 1'b0;

	end else begin

	    if (xfer_state == `START) begin
	    	serial_resetn <= 1'b1;
		serial_clock <= 1'b0;
	    	xfer_count <= 6'd0;
		if (pad_count == NUM_GPIO_PADS) begin
		    xfer_state <= `LOAD;
		end else begin
		    pad_count <= pad_count + 1;
		    xfer_state <= `XBYTE;

		    for (i=0; i < NUM_GPIO_PADS; i = i + 1) begin
			if (pad_count == i) 
			    serial_data_staging <=
				pad_configure[(i+1)*PAD_CTRL_BITS-1 : i*PAD_CTRL_BITS];
		    end
		end
	    end else if (xfer_state == `XBYTE) begin
	    	serial_resetn <= 1'b1;
		serial_clock <= ~serial_clock;
		if (serial_clock == 1'b0) begin
		    if (xfer_count == PAD_CTRL_BITS) begin
		    	xfer_state <= `START;
		    end else begin
		    	xfer_count <= xfer_count + 1;
		    end
		end else begin
		    serial_data_staging <= {serial_data_staging[PAD_CTRL_BITS-2:0], 1'b0};
		    serial_data_out <= serial_data_staging[PAD_CTRL_BITS-1];
		end
	    end else if (xfer_state == `LOAD) begin
		xfer_count <= xfer_count + 1;

		/* Load sequence:  Raise clock for final data shift in;
		 * Pulse reset low while clock is high
		 * Set clock back to zero.
		 * Return to idle mode.
		 */
		if (xfer_count == 4'd0) begin
		    serial_clock <= 1'b1;
		    serial_resetn <= 1'b1;
		end else if (xfer_count == 4'd1) begin
		    serial_clock <= 1'b1;
		    serial_resetn <= 1'b0;
		end else if (xfer_count == 4'd2) begin
		    serial_clock <= 1'b1;
		    serial_resetn <= 1'b1;
		end else if (xfer_count == 4'd3) begin
		    serial_resetn <= 1'b1;
		    serial_clock <= 1'b0;
		    xfer_state <= `START;
		end
	    end	
	end
    end

endmodule
