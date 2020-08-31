
`timescale 1 ns / 1 ps

`include "harness_chip.v"
`include "spiflash.v"

module io_ports_tb;
	reg XCLK;
	reg XI;

	reg real adc_h, adc_l;
	reg real adc_0, adc_1;
	reg real comp_n, comp_p;
    reg SDI, CSB, SCK, RSTB;
	wire SDO;

    wire [15:0] gpio;
    wire [31:0] mprj_io;
	wire [7:0] mprj_io_0;

	assign mprj_io_0 = mprj_io[7:0];

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #12.5 XCLK <= (XCLK === 1'b0);
	always #220 XI <= (XI === 1'b0);

	initial begin
		XI = 0;
		XCLK = 0;
	end

	initial begin
		$dumpfile("io_ports.vcd");
		$dumpvars(0, io_ports_tb);

		// Repeat cycles of 1000 XCLK edges as needed to complete testbench
		repeat (25) begin
			repeat (1000) @(posedge XCLK);
			// $display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		$display ("Monitor: Timeout, Test Mega-Project IO Ports (RTL) Failed");
		$display("%c[0m",27);
		$finish;
	end

	initial begin
		// Observe Output pins [7:0]
		wait(mprj_io_0==8'h01);
		wait(mprj_io_0==8'h02);
		wait(mprj_io_0==8'h03);
    	wait(mprj_io_0==8'h04);
		wait(mprj_io_0==8'h05);
        wait(mprj_io_0==8'h06);
		wait(mprj_io_0==8'h07);
        wait(mprj_io_0==8'h08);
		wait(mprj_io_0==8'h09);
        wait(mprj_io_0==8'h0A);   
		wait(mprj_io_0==8'hFF);
		wait(mprj_io_0==8'h00);
		$display("Monitor: Test 1 Mega-Project IO (RTL) Passed");
		$finish;
	end

	initial begin
		CSB <= 1'b1;
		SCK <= 1'b0;
		SDI <= 1'b0;
		RSTB <= 1'b0;
		#1000;
		RSTB <= 1'b1;	    // Release reset
		#2000;
		CSB <= 1'b0;	    // Apply CSB to start transmission
	end

	always @(mprj_io) begin
		#1 $display("MPRJ-IO state = %b ", mprj_io[7:0]);
	end

	wire VDD1V8;
    wire VDD3V3;
	wire VSS;
    
    wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;
	wire flash_io2;
	wire flash_io3;

	assign VSS = 1'b0;
	assign VDD1V8 = 1'b1;
	assign VDD3V3 = 1'b1;

	harness_chip uut (
		.vdd	  (VDD3V3),
		.vdd1v8	  (VDD1V8),
		.vss	  (VSS),
		.xi	  	  (XI),
		.xclk	  (XCLK),
		.SDI	  (SDI),
		.SDO	  (SDO),
		.CSB	  (CSB),
		.SCK	  (SCK),
		.ser_rx	  (1'b0),
		.ser_tx	  (tbuart_rx),
		.irq	  (1'b0),
		.gpio     (gpio),
        .mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.flash_io2(flash_io2),
		.flash_io3(flash_io3),
		.adc_high (adc_h),
		.adc_low  (adc_l),
		.adc0_in  (adc_0),
		.adc1_in  (adc_1),
		.RSTB	  (RSTB),
		.comp_inp (comp_p),
		.comp_inn (comp_n)
	);

	spiflash #(
		.FILENAME("io_ports.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(flash_io2),
		.io3(flash_io3)
	);

endmodule
