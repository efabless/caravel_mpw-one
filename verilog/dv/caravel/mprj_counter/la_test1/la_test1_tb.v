
`timescale 1 ns / 1 ps

`include "caravel.v"
`include "spiflash.v"
`include "tbuart.v"

module la_test1_tb;
	reg clock;

    	reg SDI, CSB, SCK, RSTB;
	wire SDO;

    	wire [1:0] gpio;
    	wire [31:0] mprj_io;
	wire [7:0] mprj_io_0;

	assign mprj_io_0 = mprj_io[7:0];

	always #12.5 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	initial begin
		$dumpfile("la_test1.vcd");
		$dumpvars(0, la_test1_tb);

		// Repeat cycles of 1000 XCLK edges as needed to complete testbench
		repeat (200) begin
			repeat (1000) @(posedge XCLK);
			// $display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		$display ("Monitor: Timeout, Test Mega-Project IO (RTL) Failed");
		$display("%c[0m",27);
		$finish;
	end

	initial begin
		wait(gpio == 16'hAB40);
		$display("LA Test 1 started");
		wait(gpio == 16'hAB41);
		wait(gpio == 16'hAB51);
		#10000;
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

	caravel uut (
		.vdd3v3	  (VDD3V3),
		.vdd1v8	  (VDD1V8),
		.vss	  (VSS),
		.clock	  (clock),
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
		.RSTB	  (RSTB)
	);

	spiflash #(
		.FILENAME("la_test1.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(flash_io2),
		.io3(flash_io3)
	);

	// Testbench UART
	tbuart tbuart (
		.ser_rx(tbuart_rx)
	);

endmodule
