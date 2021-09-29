`timescale 1ns / 1ps

`include "decred_defines.v"

module decred_controller (
`ifdef USE_POWER_PINS
  inout vdda1,	// User area 1 3.3V supply
  inout vdda2,	// User area 2 3.3V supply
  inout vssa1,	// User area 1 analog ground
  inout vssa2,	// User area 2 analog ground
  inout vccd1,	// User area 1 1.8V supply
  inout vccd2,	// User area 2 1.8v supply
  inout vssd1,	// User area 1 digital ground
  inout vssd2,	// User area 2 digital ground
`endif
  input  wire  EXT_RESET_N_fromHost,
  input  wire  SCLK_fromHost,
  input  wire  M1_CLK_IN,
  input  wire  M1_CLK_SELECT,
  output wire  m1_clk_local,
  input  wire  PLL_INPUT,
  input  wire  S1_CLK_IN,
  input  wire  S1_CLK_SELECT,
  input  wire  SCSN_fromHost,
  input  wire  MOSI_fromHost,
  input  wire  MISO_fromClient,
  input  wire  IRQ_OUT_fromClient,
  input  wire  ID_fromClient,

  output wire  SCSN_toClient,
  output wire  SCLK_toClient,
  output wire  MOSI_toClient,
  output wire  EXT_RESET_N_toClient,
  output wire  ID_toHost,

  output wire  CLK_LED,
  output wire  MISO_toHost,
  output wire  HASH_LED,
  output wire  IRQ_OUT_toHost,

  // hash macro exports
  output wire                            HASH_EN,
  output wire [`NUMBER_OF_MACROS - 1: 0] MACRO_WR_SELECT,
  output wire [7: 0]                     DATA_TO_HASH,
  output wire [`NUMBER_OF_MACROS - 1: 0] MACRO_RD_SELECT,
  output wire [5: 0]                     HASH_ADDR,
  input wire  [3 :0]                     THREAD_COUNT,
  input wire  [`NUMBER_OF_MACROS - 1: 0] DATA_AVAILABLE,
  input wire  [7: 0]                     DATA_FROM_HASH,

  // user_project_wrapper exports
  output wire zero,
  output wire one
  );

  assign zero = 1'b0;
  assign one = 1'b1;

  // //////////////////////////////////////////////////////
  // Clocking

  // M1 clock is sourced from pin or PLL
  assign m1_clk_local = (M1_CLK_SELECT) ? M1_CLK_IN : PLL_INPUT;

  // Resync reset pin to m1_clk_local
  reg [1:0] reset_resync;
  always @(posedge m1_clk_local)
    reset_resync = {reset_resync[0], !EXT_RESET_N_fromHost};

  wire   rst_local_m1;
  assign rst_local_m1 = reset_resync[1];

  // Stretch reset signal for SPI - assume m1 >> s1
  reg [19:0] spi_reset_stretch;
  always @(posedge m1_clk_local)
    spi_reset_stretch = {spi_reset_stretch[18:0], !EXT_RESET_N_fromHost};

  wire   s1_reset_stretch;
  assign s1_reset_stretch = spi_reset_stretch[19];

  // S1 clock is sourced from pin or divider
  wire s1_clk_local;
  wire s1_div_output;

  clock_div clock_divBlock (
    .iCLK(m1_clk_local),
    .clk_out(s1_div_output),
    .RST(rst_local_m1)
  );

  assign s1_clk_local = (S1_CLK_SELECT) ? S1_CLK_IN : s1_div_output;

  // //////////////////////////////////////////////////////
  // Pass-through wires
  wire rst_local_s1;
  wire sclk_local;
  wire scsn_local;
  wire mosi_local;
  wire miso_local;
  wire irq_local;
  wire address_stobe;
  wire write_enable;
  wire [6:0] setSPIAddr;

  // //////////////////////////////////////////////////////
  // Heartbeat output

  reg [23:1] counter;
  
  always @(posedge m1_clk_local)
    if (rst_local_m1) 
	    counter <= 0;
	  else
	    counter <= counter + 1'b1;

  assign CLK_LED = counter[23];

  // //////////////////////////////////////////////////////
  // SPI deserializer

  wire       start_of_transfer;
  wire       end_of_transfer;
  wire [7:0] mosi_data_out;
  wire       mosi_data_ready;
  wire       miso_data_request;
  wire [7:0] miso_data_in;

  spi spiBlock(
    .SPI_CLK(s1_clk_local),
    .RST(rst_local_s1),
    .SCLK(sclk_local),
    .SCSN(scsn_local),
    .MOSI(mosi_local),

    .start_of_transfer(start_of_transfer),
    .end_of_transfer(end_of_transfer),
	  .mosi_data_out(mosi_data_out),
    .mosi_data_ready(mosi_data_ready),
    .MISO(miso_local),
    .miso_data_request(miso_data_request),
    .miso_data_in(miso_data_in)
  );

  // //////////////////////////////////////////////////////
  // SPI pass through
  assign EXT_RESET_N_toClient = EXT_RESET_N_fromHost;
  assign SCLK_toClient = SCLK_fromHost;
  assign SCSN_toClient = SCSN_fromHost;
  assign MOSI_toClient = MOSI_fromHost;

  spi_passthrough spiPassBlock(
    .SPI_CLK(s1_clk_local),
    .SPI_CLK_RST(s1_reset_stretch),
    .RSTin(rst_local_m1),
    .ID_in(ID_fromClient),
    .IRQ_in(IRQ_OUT_fromClient),
    .address_strobe(address_stobe),
    .currentSPIAddr(address[14:8]),
    .setSPIAddr(setSPIAddr),

    .SCLKin(SCLK_fromHost),
    .SCSNin(SCSN_fromHost),
    .MOSIin(MOSI_fromHost),
    .MISOout(MISO_toHost),

    .rst_local_s1(rst_local_s1),
    .sclk_local(sclk_local),
    .scsn_local(scsn_local),
    .mosi_local(mosi_local),
    .miso_local(miso_local),
    .irq_local(irq_local),
    .write_enable(write_enable),

    .MISOin(MISO_fromClient),
    .IRQout(IRQ_OUT_toHost)
  );

  // //////////////////////////////////////////////////////
  // Interface to addressalyzer

  wire [14:0] address;
  wire        regFile_read_strobe;
  wire        regFile_write_strobe;

  addressalyzer addressalyzerBlock (
    .SPI_CLK(s1_clk_local),
    .RST(rst_local_s1),

    .start_of_transfer(start_of_transfer),
    .end_of_transfer(end_of_transfer),
    .data_in_value(mosi_data_out),
    .data_in_ready(mosi_data_ready),
    .data_out_request(miso_data_request),
    .write_enable_mask(write_enable),

    .ram_address_out(address),
    .address_strobe(address_stobe),
    .ram_read_strobe(regFile_read_strobe),
    .ram_write_strobe(regFile_write_strobe)
  );

  // //////////////////////////////////////////////////////
  // Interface to regfile

  regBank regBankBlock (
    .SPI_CLK(s1_clk_local),
    .RST_S1(rst_local_s1),
    .M1_CLK(m1_clk_local),
    .RST_M1(rst_local_m1),
    .address(address[7:0]),
    .data_in(mosi_data_out),
    .read_strobe(regFile_read_strobe),
    .write_strobe(regFile_write_strobe),
    .hash_clock_reset(),
    .data_out(miso_data_in),
    .LED_out(HASH_LED),
    .spi_addr(setSPIAddr),
    .ID_out(ID_toHost),
    .interrupt_out(irq_local),

    // hash macro exports
    .HASH_EN(HASH_EN),
    .MACRO_WR_SELECT(MACRO_WR_SELECT),
    .DATA_TO_HASH(DATA_TO_HASH),
    .MACRO_RD_SELECT(MACRO_RD_SELECT),
    .HASH_ADDR(HASH_ADDR),
    .THREAD_COUNT(THREAD_COUNT),
    .DATA_AVAILABLE(DATA_AVAILABLE),
    .DATA_FROM_HASH(DATA_FROM_HASH)
  );

endmodule // decred_controller
