
`timescale 1 ns / 1 ps

`include "caravel.v"
`include "spiflash.v"

module io_ports_tb;
	reg clock;
    	reg RSTB;
	wire SDO;

    	wire gpio;
    	wire [31:0] mprj_io;
	wire [7:0] mprj_io_0;

	assign mprj_io_0 = mprj_io[7:0];

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #12.5 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	initial begin
		$dumpfile("io_ports.vcd");
		$dumpvars(0, io_ports_tb);

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (25) begin
			repeat (1000) @(posedge clock);
			// $display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		$display ("Monitor: Timeout, Test Mega-Project IO Ports (RTL) Failed");
		$display("%c[0m",27);
		$finish;
	end

	initial begin
	    // Observe Output pins [7:0]
	    wait(mprj_io_0 == 8'h01);
	    wait(mprj_io_0 == 8'h02);
	    wait(mprj_io_0 == 8'h03);
    	    wait(mprj_io_0 == 8'h04);
	    wait(mprj_io_0 == 8'h05);
            wait(mprj_io_0 == 8'h06);
	    wait(mprj_io_0 == 8'h07);
            wait(mprj_io_0 == 8'h08);
	    wait(mprj_io_0 == 8'h09);
            wait(mprj_io_0 == 8'h0A);   
	    wait(mprj_io_0 == 8'hFF);
	    wait(mprj_io_0 == 8'h00);

	    $display("Monitor: Test 1 Mega-Project IO (RTL) Passed");
	    $finish;
	end

	initial begin
		RSTB <= 1'b0;
		#1000;
		RSTB <= 1'b1;	    // Release reset
		#2000;
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

	assign VSS = 1'b0;
	assign VDD1V8 = 1'b1;
	assign VDD3V3 = 1'b1;

	caravel uut (
		.vdd3v3	  (VDD3V3),
		.vdd1v8	  (VDD1V8),
		.vss	  (VSS),
		.clock	  (clock),
		.gpio     (gpio),
        	.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("io_ports.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
