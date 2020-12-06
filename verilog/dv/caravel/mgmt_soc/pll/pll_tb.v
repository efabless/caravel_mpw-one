`default_nettype none

`timescale 1 ns / 1 ps

`include "caravel.v"
`include "spiflash.v"

module pll_tb;
	reg clock;
	reg power1;
	reg power2;
	reg RSTB;

	wire gpio;
	wire [15:0] checkbits;
	wire [7:0] spivalue;
	wire [37:0] mprj_io;
	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;
	wire SDO;

	assign checkbits = mprj_io[31:16];
	assign spivalue  = mprj_io[15:8];

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #10 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	initial begin
		$dumpfile("pll.vcd");
		$dumpvars(0, pll_tb);
		repeat (25) begin
			repeat (1000) @(posedge clock);
			$display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		`ifdef GL
			$display ("Monitor: Timeout, Test PLL (GL) Failed");
		`else
			$display ("Monitor: Timeout, Test PLL (RTL) Failed");
		`endif
		 $display("%c[0m",27);
		$finish;
	end

	// Monitor
	initial begin
	    wait(checkbits == 16'hA040);
		`ifdef GL
			$display("Monitor: Test PLL (GL) Started");
		`else
			$display("Monitor: Test PLL (RTL) Started");
		`endif

	    wait(checkbits == 16'hA041);
            // $display("   SPI value = 0x%x (should be 0x04)", spivalue);
            // if(spivalue !== 32'h04) begin
            //     $display("Monitor: Test PLL (RTL) Failed");
            //     $finish;
            // end
	    wait(checkbits == 16'hA042);
            // $display("   SPI value = 0x%x (should be 0x56)", spivalue);
            // if(spivalue !== 32'h56) begin
            //     $display("Monitor: Test PLL (RTL) Failed");
            //     $finish;
            // end

	    wait(checkbits == 16'hA090);
		`ifdef GL
            $display("Monitor: Test PLL (GL) Passed");
		`else
		    $display("Monitor: Test PLL (RTL) Passed");
		`endif
            $finish;
	end

	initial begin
		RSTB <= 1'b0;
		#1000;
		RSTB <= 1'b1;	    // Release reset
		#2000;
	end

	initial begin
		power1 <= 1'b0;
		power2 <= 1'b0;
		#200;
		power1 <= 1'b1;
		#200;
		power2 <= 1'b1;
	end

	always @(checkbits) begin
		#1 $display("GPIO state = %b ", checkbits);
	end

	wire VDD3V3;
	wire VDD1V8;
	wire VSS;
	
	assign VDD3V3 = power1;
	assign VDD1V8 = power2;
	assign VSS = 1'b0;

	assign mprj_io[3] = 1'b1;  // Force CSB high.

	caravel uut (
		.vddio	  (VDD3V3),
		.vssio	  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (VDD3V3),
		.vdda2    (VDD3V3),
		.vssa1	  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (VDD1V8),
		.vccd2	  (VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock    (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("pll.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
`default_nettype wire
