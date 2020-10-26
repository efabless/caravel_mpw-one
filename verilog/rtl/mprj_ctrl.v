module mprj_ctrl_wb #(
    parameter BASE_ADR = 32'h 2300_0000,
    parameter DATA   = 8'h 00,
    parameter XFER   = 8'h 04,
    parameter CONFIG = 8'h 08,
    parameter IO_PADS = 32,   // Number of IO control registers
    parameter PWR_PADS = 32  // Number of power control registers
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

    // Pass state of OEB bit on SDO and JTAG back to the core
    // so that the function can be overridden for management output
    output sdo_oenb_state,
    output jtag_oenb_state,

    // Read/write data to each GPIO pad from management SoC
    input [IO_PADS-1:0] mgmt_gpio_in,
    output [IO_PADS-1:0] mgmt_gpio_out
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
        .PWR_PADS(PWR_PADS)
    ) mprj_ctrl (
        .clk(wb_clk_i),
        .resetn(resetn),
        .iomem_addr(wb_adr_i),
        .iomem_valid(valid),
        .iomem_wstrb(iomem_we[1:0]),
        .iomem_wdata(wb_dat_i),
        .iomem_rdata(wb_dat_o),
        .iomem_ready(ready),

	.serial_clock(serial_clock),
	.serial_resetn(serial_resetn),
	.serial_data_out(serial_data_out),
	.sdo_oenb_state(sdo_oenb_state),
	.jtag_oenb_state(jtag_oenb_state),
	// .mgmt_gpio_io(mgmt_gpio_io)
	.mgmt_gpio_in(mgmt_gpio_in),
	.mgmt_gpio_out(mgmt_gpio_out)
    );

endmodule

module mprj_ctrl #(
    parameter BASE_ADR = 32'h 2300_0000,
    parameter DATA   = 8'h 00,
    parameter XFER   = 8'h 04,
    parameter CONFIG = 8'h 08,
    parameter IO_PADS = 32,
    parameter PWR_PADS = 32,
    parameter IO_CTRL_BITS = 13,
    parameter PWR_CTRL_BITS = 1
)(
    input clk,
    input resetn,

    input [31:0] iomem_addr,
    input iomem_valid,
    input [1:0] iomem_wstrb,
    input [31:0] iomem_wdata,
    output reg [31:0] iomem_rdata,
    output reg iomem_ready,

    output serial_clock,
    output serial_resetn,
    output serial_data_out,
    output sdo_oenb_state,
    output jtag_oenb_state,
    input  [IO_PADS-1:0] mgmt_gpio_in,
    output [IO_PADS-1:0] mgmt_gpio_out
);

`define IDLE	2'b00
`define START	2'b01
`define XBYTE	2'b10
`define LOAD	2'b11

    localparam IO_WORDS = 1 + (IO_PADS / 32);
    localparam PWR_WORDS = 1 + (PWR_PADS / 32);

    localparam IO_BASE_ADR = (BASE_ADR | CONFIG) + ((IO_WORDS + PWR_WORDS - 2) * 4);
    localparam PWR_BASE_ADR = IO_BASE_ADR + (IO_PADS * 4);
    localparam OEB = 1;			// Offset of output enable in shift register.
    localparam INP_DIS = 3;		// Offset of input disable in shift register. 
    localparam XFER_ADJ = XFER + ((IO_WORDS + PWR_WORDS - 2) * 4);

    reg [IO_CTRL_BITS-1:0] io_ctrl[IO_PADS-1:0];  // I/O control, 1 word per gpio pad
    reg [PWR_CTRL_BITS-1:0] pwr_ctrl[PWR_PADS-1:0]; // Power control, 1 word per power pad
    reg [IO_PADS-1:0] mgmt_gpio_outr; // I/O write data, 1 bit per gpio pad
    wire [IO_PADS-1:0] mgmt_gpio_out;	 // I/O write data output when input disabled
    reg xfer_ctrl;			// Transfer control (1 bit)

    wire [IO_WORDS-1:0] io_data_sel;	// wishbone selects
    wire xfer_sel;
    wire [IO_PADS-1:0] io_ctrl_sel;
    wire [PWR_PADS-1:0] pwr_ctrl_sel;
    wire [IO_PADS-1:0] mgmt_gpio_in;

    wire sdo_oenb_state, jtag_oenb_state;

    // JTAG and housekeeping SDO are normally controlled by their respective
    // modules with OEB set to the default 1 value.  If configured for an
    // additional output by setting the OEB bit low, then pass this information
    // back to the core so that the default signals can be overridden.

    assign jtag_oenb_state = io_ctrl[0][OEB];
    assign sdo_oenb_state = io_ctrl[1][OEB];

    assign xfer_sel = (iomem_addr[7:0] == XFER_ADJ);

    genvar i;

    generate
        for (i=0; i<IO_WORDS; i=i+1) begin
    	    assign io_data_sel[i] = (iomem_addr[7:0] == (DATA + i*4)); 
	end
    endgenerate

    generate
        for (i=0; i<IO_PADS; i=i+1) begin
            assign io_ctrl_sel[i] = (iomem_addr[7:0] == (IO_BASE_ADR[7:0] + i*4)); 
    	    assign mgmt_gpio_out[i] = (io_ctrl[i][INP_DIS] == 1'b1) ?
			mgmt_gpio_outr[i] : 1'bz;
        end
    endgenerate

    generate
        for (i=0; i<PWR_PADS; i=i+1) begin
            assign pwr_ctrl_sel[i] = (iomem_addr[7:0] == (PWR_BASE_ADR[7:0] + i*4)); 
        end
    endgenerate

    // I/O transfer of xfer bit.  Also handles iomem_ready signal.

    always @(posedge clk) begin
	if (!resetn) begin
	    xfer_ctrl <= 0;
	end else begin
	    iomem_ready <= 0;
	    if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
		iomem_ready <= 1'b 1;

		if (xfer_sel) begin
		    iomem_rdata <= {31'd0, busy};
		    if (iomem_wstrb[0]) xfer_ctrl <= iomem_wdata[0];
		end
	    end else begin
		xfer_ctrl <= 1'b0;	// Immediately self-resetting
	    end
	end
    end

    // I/O transfer of gpio data to/from user project region under management
    // SoC control

    `define wtop (((i+1)*32 > IO_PADS) ? IO_PADS-1 : (i+1)*32-1)
    `define wbot (i*32)
    `define rtop (`wtop - `wbot + 1)

    generate 
        for (i=0; i<IO_WORDS; i=i+1) begin
	    always @(posedge clk) begin
		if (!resetn) begin
		    mgmt_gpio_outr[`wtop:`wbot] <= 'd0;
		end else begin
		    if (iomem_valid && !iomem_ready && iomem_addr[31:8] ==
					BASE_ADR[31:8]) begin
			if (io_data_sel[i]) begin
			    iomem_rdata[`rtop:0] <= mgmt_gpio_in[`wtop:`wbot];
			    if (iomem_wstrb[0]) begin
				mgmt_gpio_outr[`wtop:`wbot] <= iomem_wdata[`rtop:0];
			    end
			end
		    end
		end
	    end
	end
    endgenerate

    generate 
        for (i=0; i<IO_PADS; i=i+1) begin
             always @(posedge clk) begin
                if (!resetn) begin
		    // NOTE:  This initialization must match the defaults passed
		    // to the control blocks.  Specifically, 0x1803 is for a
		    // bidirectional pad, and 0x0403 is for a simple input pad
		    if (i < 2) begin
                    	io_ctrl[i] <= 'h1803;
		    end else begin
                    	io_ctrl[i] <= 'h0403;
		    end
                end else begin
                    if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
                        if (io_ctrl_sel[i]) begin
                            iomem_rdata <= io_ctrl[i];
			    // NOTE:  Byte-wide write to io_ctrl is prohibited
                            if (iomem_wstrb[0])
				io_ctrl[i] <= iomem_wdata[IO_CTRL_BITS-1:0];
                        end 
                    end
                end
            end
        end
    endgenerate

    generate 
        for (i=0; i<PWR_PADS; i=i+1) begin
             always @(posedge clk) begin
                if (!resetn) begin
                    pwr_ctrl[i] <= 'd0;
                end else begin
                    if (iomem_valid && !iomem_ready && iomem_addr[31:8] == BASE_ADR[31:8]) begin
                        if (pwr_ctrl_sel[i]) begin
                            iomem_rdata <= pwr_ctrl[i];
                            if (iomem_wstrb[0])
				pwr_ctrl[i] <= iomem_wdata[PWR_CTRL_BITS-1:0];
                        end 
                    end
                end
            end
        end
    endgenerate

    reg [3:0]  xfer_count;
    reg [5:0]  pad_count;
    reg [1:0]  xfer_state;
    reg	       serial_clock;
    reg	       serial_resetn;

    // NOTE:  Ignoring power control bits for now. . .  need to revisit.
    // Depends on how the power pads are arranged among the GPIO, and
    // whether or not switching will be internal and under the control
    // of the SoC.

    reg [IO_CTRL_BITS-1:0] serial_data_staging;

    wire       serial_data_out;
    wire       busy;

    assign serial_data_out = serial_data_staging[IO_CTRL_BITS-1];
    assign busy = (xfer_state != `IDLE);
 
    always @(posedge clk or negedge resetn) begin
	if (resetn == 1'b0) begin

	    xfer_state <= `IDLE;
	    xfer_count <= 4'd0;
	    pad_count  <= IO_PADS;
	    serial_resetn <= 1'b0;
	    serial_clock <= 1'b0;

	end else begin

	    if (xfer_state == `IDLE) begin
	    	pad_count  <= IO_PADS;
	    	serial_resetn <= 1'b1;
		serial_clock <= 1'b0;
		if (xfer_ctrl == 1'b1) begin
		    xfer_state <= `START;
		end
	    end else if (xfer_state == `START) begin
	    	serial_resetn <= 1'b1;
		serial_clock <= 1'b0;
	    	xfer_count <= 6'd0;
		pad_count <= pad_count - 1;
		xfer_state <= `XBYTE;
		serial_data_staging <= io_ctrl[pad_count - 1];
	    end else if (xfer_state == `XBYTE) begin
	    	serial_resetn <= 1'b1;
		serial_clock <= ~serial_clock;
		if (serial_clock == 1'b0) begin
		    if (xfer_count == IO_CTRL_BITS - 1) begin
			if (pad_count == 0) begin
		    	    xfer_state <= `LOAD;
			end else begin
		    	    xfer_state <= `START;
			end
		    end else begin
		    	xfer_count <= xfer_count + 1;
		    end
		end else begin
		    serial_data_staging <= {serial_data_staging[IO_CTRL_BITS-2:0], 1'b0};
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
		    xfer_state <= `IDLE;
		end
	    end	
	end
    end

endmodule
