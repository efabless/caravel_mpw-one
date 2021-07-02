// hydra_spi_tb
//
// Testbench for Hydra v2.0 SPI controller and register map
//----------------------------------------------------------
// Written by Tim Edwards
// efabless, inc. April 23, 2017
//----------------------------------------------------------

`timescale 1ns/1ps
`include "/home/tim/gits/hydra_v2p0/qflow/controller/source/hydra_spi_controller.v"

module hydra_spi_tb();

// Exercise the hydra SPI controller module

    reg  SDI;
    reg  SCK;
    reg  CSB;
    reg  RST;
    reg  [9:0] adcvalue;
    reg	 adcdone;
    reg  [7:0] data;
    wire SDO;
    wire sdoena;
    wire sdopin;

    wire bgap1ena;
    wire bgap2ena;
    wire bgap3ena;
    wire [3:0] bgap1trim;
    wire [3:0] bgap2trim;
    wire [3:0] bgap3trim;
    wire bgena;
    wire xtalena;
    wire adcena;
    wire adcconvert;

    // Emulate the digital output pin for SDO (goes high impedence when
    // "sdoena" is low).

    assign SDO = (sdoena == 1'b1) ? sdopin : 1'bz;

    initial begin
        $d_hdl_sync("simulator_pipe",
		"/usr/local/bin/ngspice -b -r hydra_spi_tb.raw hydra_v2p0_ana.spi",
		SDI, SDO, CSB, RST);
    end

    initial begin
	$dumpfile("test.vcd");
	$dumpvars(3, hydra_spi_tb);
    end

    initial
	SDI <= 1'b0;
	SCK <= 1'b0;
	CSB <= 1'b1;
	RST <= 1'b1;
	adcvalue <= 10'd0;
	adcdone <= 1'b0;
	#50;
	RST <= 1'b0;
	#50;

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
	$finish;
    end

    // Instantiate the hydra SPI controller module

    hydra_spi_controller U0 (
	.RST(RST),
	.SCK(SCK),
	.SDI(SDI),
	.CSB(CSB),
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
