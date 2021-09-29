// hydra_spi_tb
//
// Testbench for Hydra v2.0 SPI controller and register map
//----------------------------------------------------------
// Written by Tim Edwards
// efabless, inc. April 23, 2017
//----------------------------------------------------------

`timescale 1ns/1ps
`include "hydra_spi_controller.v"

module hydra_spi_tb;

// map inputs to SPI pin names for use by spi_tb_tasks.v
`define RST inputs[0]
`define SDI inputs[1]
`define SCK inputs[2]
`define CSB inputs[3]

// inputs and outputs are the register connections between
// the analog and digital simulations.  To make the source
// easier to read, define meaningful names for them.

// Exercise the hydra SPI controller module

    // Main connections between the analog and digital sides
    reg [4:0] inputs;
    wire [5:0] outputs;
    reg  trigger;
    reg  SCKgen;
    reg  SDIgen;
    reg  CSBgen;

    wire sdopin;
    wire sdoena;
    wire bgena;
    wire adcena;
    wire adcconvert;
    reg [9:0] adcvalue;
    reg adcdone;

    wire iRST;
    wire iSDI;
    wire iSCK;
    wire iCSB;
    wire SDO;

    // Local connections
    reg  [7:0] data;

    // These will be definitions, eventually.
    wire bgap1ena;
    wire bgap2ena;
    wire bgap3ena;
    wire [3:0] bgap1trim;
    wire [3:0] bgap2trim;
    wire [3:0] bgap3trim;
    wire xtalena;

    assign iRST = inputs[0];
    assign iSDI = inputs[1];
    assign iSCK = inputs[2];
    assign iCSB = inputs[3];
    assign SDO = inputs[4];

    assign outputs = {CSBgen, SDIgen, SCKgen, bgena, sdoena, sdopin};

    // Call to start the ngspice simulator

    initial begin
        $d_hdl_sync("simulator_pipe",
		"/usr/local/bin/ngspice -b -r hydra_spi_tb.raw hydra_v2p0_test.spi",
		outputs, inputs, trigger);
    end

    // Testbench
 
    initial begin
	$dumpfile("test.vcd");
	$dumpvars(3, hydra_spi_tb);

	// Initial signal assignments
	SCKgen <= 1'b0;
	SDIgen <= 1'b0;
	CSBgen <= 1'b1;
	adcvalue <= 10'b0;
	adcdone <= 1'b0;

	// Wait for RST to go low
	#1000;
	@ (negedge iRST) ;
	#1000;

	// Test simple streaming
	
        $display("Simple streaming test, 1 byte");
        $display("Time is: %f", $realtime);
	stream_begin();
	spi_read_stream(8'h00, data);	// Address 0, data unused
	spi_rw(8'h00, data);
	stream_end();
	$display("Register 0 = %h", data);

        $display("Simple streaming test, 4 bytes");
        $display("Time is: %f", $realtime);
	stream_begin();
	spi_read_stream(8'h01, data);	// Address 1, data unused
	spi_rw(8'h00, data);
	$display("Register 1 = %h", data);
	spi_rw(8'h00, data);	// Advance to address 2
	$display("Register 2 = %h", data);
	spi_rw(8'h00, data);	// Advance to address 3
	$display("Register 3 = %h", data);
	spi_rw(8'h00, data);	// Advance to address 4
	$display("Register 4 = %h", data);
	stream_end();

	// Do that again with a fixed-byte read
        $display("Fixed read test, 1 byte");
        $display("Time is: %f", $realtime);
	stream_begin();			// Not a stream, but must apply CSB
	spi_read1b(8'h00, data);	// Address 0, data unused
	spi_rw(8'h00, data);
	$display("Register 0 = %h", data);

        $display("Fixed read test, 4 bytes");
        $display("Time is: %f", $realtime);
	spi_read4b(8'h01, data);	// Address 1, data unused
	spi_rw(8'h00, data);
	$display("Register 1 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 2 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 3 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 4 = %h", data);

	// Now write 0xff to all addresses 0 to 10 and read back.
	// (Non streaming write, streaming read)

        $display("Write 1-bits to all, 10 bytes, fixed");
        $display("Time is: %f", $realtime);
	spi_write4b(8'h00, data);
	spi_rw(8'hff, data);
	spi_rw(8'hff, data);
	spi_rw(8'hff, data);
	spi_rw(8'hff, data);

	spi_write4b(8'h04, data);
	spi_rw(8'hff, data);
	spi_rw(8'hff, data);
	spi_rw(8'hff, data);
	spi_rw(8'hff, data);

	spi_write2b(8'h08, data);
	spi_rw(8'hff, data);
	spi_rw(8'hff, data);

	// Read-back

        $display("Read back 1-bits from all, 10 bytes, stream");
        $display("Time is: %f", $realtime);
	spi_read_stream(8'h00, data);	// Address 0, data unused
	spi_rw(8'h00, data);
	$display("Register 0 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 1 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 2 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 3 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 4 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 5 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 6 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 7 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 8 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 9 = %h", data);
	stream_end();

	// Now write 0x00 to all addresses 0 to 10 and read back.
	// (Streaming write, non-streaming read)

        $display("Write 0-bits to all, 10 bytes, stream");
        $display("Time is: %f", $realtime);
	stream_begin();
	spi_write_stream(8'h00, data);	// Address 0, data unused
	spi_rw(8'h00, data);
	spi_rw(8'h00, data);
	spi_rw(8'h00, data);
	spi_rw(8'h00, data);
	spi_rw(8'h00, data);
	spi_rw(8'h00, data);
	spi_rw(8'h00, data);
	spi_rw(8'h00, data);
	spi_rw(8'h00, data);
	spi_rw(8'h00, data);
	stream_end();

        $display("Read back 0-bits from all, 10 bytes, fixed");
        $display("Time is: %f", $realtime);
	stream_begin();			// Not a stream, but must apply CSB
	spi_read4b(8'h00, data);
	spi_rw(8'h00, data);
	$display("Register 0 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 1 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 2 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 3 = %h", data);

	spi_read4b(8'h04, data);
	spi_rw(8'h00, data);
	$display("Register 4 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 5 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 6 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 7 = %h", data);

	spi_read2b(8'h08, data);
	spi_rw(8'h00, data);
	$display("Register 8 = %h", data);
	spi_rw(8'h00, data);
	$display("Register 9 = %h", data);

	stream_end();	// Finish, close interface with CSB
	#10;
        $display("End simulation");
        $display("Time is: %f", $realtime);
	// $finish;	// ngspice does the finish for mixed-mode simulation

    end

    // Instantiate the hydra SPI controller module

    hydra_spi_controller U0 (
	.RST(iRST),
	.SCK(iSCK),
	.SDI(iSDI),
	.CSB(iCSB),
	.SDO(sdopin),
	.sdoena(sdoena),
        .bgap1ena(bgap1ena),
	.bgap1trim(bgap1trim),
        .bgap2ena(bgap2ena),
	.bgap2trim(bgap2trim),
        .bgap3ena(bgap3ena),
	.bgap3trim(bgap3trim),
        .bgena(bgena),
	.xtalena(xtalena),
	.adcena(adcena),
	.adcconvert(adcconvert),
        .adcvalue(adcvalue),
        .adcdone(adcdone)
    );

// Set up signalling tasks

`include "spi_tb_tasks.v"

endmodule	// hydra_spi_tb
