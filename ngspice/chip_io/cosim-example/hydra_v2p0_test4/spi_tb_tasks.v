// spi_tb_tasks.v
//
// Testbench tasks for SPI slave module and register map
//----------------------------------------------------------
// Written by Tim Edwards
// efabless, inc. April 23, 2017
//----------------------------------------------------------

// Set up signaling tasks

task spi_clock;
    input idata;
    output odata;
    begin
	#100;
	`SDI <= idata;
	#200;
	`SCK <= 1'b1;
	#200;
        odata <= SDO;
	#200;
	`SCK <= 1'b0;
	#100;
    end
endtask

task spi_byte;
    input [7:0] idata;
    output [7:0] odata;
    begin
	spi_clock(idata[7], odata[7]);
	spi_clock(idata[6], odata[6]);
	spi_clock(idata[5], odata[5]);
	spi_clock(idata[4], odata[4]);
	spi_clock(idata[3], odata[3]);
	spi_clock(idata[2], odata[2]);
	spi_clock(idata[1], odata[1]);
	spi_clock(idata[0], odata[0]);
    end
endtask
	
task stream_begin;
    begin
	#200;
	`CSB <= 1'b0;
	#200;
    end
endtask

task stream_end;
    begin
	#200;
	`CSB <= 1'b1;
	#200;
    end
endtask

// Stream write setup

task spi_write_stream;
    input  [7:0] register;
    output [7:0] odata;
    begin
	#200;
	spi_byte(8'h80, odata);
	spi_byte(register, odata);
    end
endtask

// Stream read setup

task spi_read_stream;
    input  [7:0] register;
    output [7:0] odata;
    begin
	#200;
	spi_byte(8'h40, odata);
	spi_byte(register, odata);
    end
endtask

// Stream read/write setup

task spi_rw_stream;
    input  [7:0] register;
    output [7:0] odata;
    begin
	#200;
	spi_byte(8'hc0, odata);
	spi_byte(register, odata);
    end
endtask

// SPI read and/or write 1 byte
// (Standard for all modes.  Chain these together for more bytes)

task spi_rw;
    input  [7:0] idata;
    output [7:0] odata;
    begin
	spi_byte(idata, odata);
    end
endtask

// N-byte write 1 byte (no streaming)

task spi_write1b;
    input  [7:0] register;
    output [7:0] odata;
    begin
	#200;
	spi_byte(8'h88, odata);
	spi_byte(register, odata);
    end
endtask

// N-byte read 1 byte setup (no streaming)

task spi_read1b;
    input  [7:0] register;
    output [7:0] odata;
    begin
	#200;
	spi_byte(8'h48, odata);
	spi_byte(register, odata);
    end
endtask

// N-byte read/write 1 byte setup (no streaming)

task spi_rw1b;
    input  [7:0] register;
    output [7:0] odata;
    begin
	#200;
	spi_byte(8'hc8, odata);
	spi_byte(register, odata);
    end
endtask

// N-byte write 2 bytes setup (no streaming)

task spi_write2b;
    input  [7:0] register;
    output [7:0] odata;
    begin
	#200;
	spi_byte(8'h90, odata);
	spi_byte(register, odata);
    end
endtask

// N-byte read 2 bytes setup (no streaming)

task spi_read2b;
    input  [7:0] register;
    output [7:0] odata;
    begin
	#200;
	spi_byte(8'h58, odata);
	spi_byte(register, odata);
    end
endtask

// N-byte read/write 2 bytes setup (no streaming)

task spi_rw2b;
    input  [7:0] register;
    output [7:0] odata;
    begin
	#200;
	spi_byte(8'hd8, odata);
	spi_byte(register, odata);
    end
endtask

// N-byte write 4 bytes setup (no streaming)

task spi_write4b;
    input  [7:0] register;
    output [7:0] odata;
    begin
	#200;
	spi_byte(8'ha0, odata);
	spi_byte(register, odata);
    end
endtask

// N-byte read 4 bytes setup (no streaming)

task spi_read4b;
    input  [7:0] register;
    output [7:0] odata;
    begin
	#200;
	spi_byte(8'h60, odata);
	spi_byte(register, odata);
    end
endtask

// N-byte read/write 4 bytes setup (no streaming)

task spi_rw4b;
    input  [7:0] register;
    output [7:0] odata;
    begin
	#200;
	spi_byte(8'he0, odata);
	spi_byte(register, odata);
    end
endtask
