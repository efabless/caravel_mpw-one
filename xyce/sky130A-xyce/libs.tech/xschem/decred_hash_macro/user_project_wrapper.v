`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

`include "decred_top/rtl/src/decred_defines.v"

module user_project_wrapper #(
    parameter BITS = 32
)(
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

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oen,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7.
    inout [`MPRJ_IO_PADS-8:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2
);

  /*--------------------------------------*/
  /* Instantiation of decred_top.         */
  /*--------------------------------------*/
  wire zero;
  wire one;
  assign io_oeb[27:19] = {9{zero}};
  assign io_oeb[18:8] = {11{one}};

  wire                             m1_clk_local;
  wire                             HASH_EN;
  wire [`NUMBER_OF_MACROS - 1: 0]  MACRO_WR_SELECT;
  wire [7: 0]                      DATA_TO_HASH;
  wire [`NUMBER_OF_MACROS - 1: 0]  MACRO_RD_SELECT;
  wire [5: 0]                      HASH_ADDR;
  wire [3 :0]                      THREAD_COUNT [`NUMBER_OF_MACROS-1:0];
  wire [`NUMBER_OF_MACROS - 1: 0]  DATA_AVAILABLE;
  wire [7: 0]                      DATA_FROM_HASH;

  decred_controller decred_controller_block (

    // inputs
    .PLL_INPUT(user_clock2),
    .EXT_RESET_N_fromHost(io_in[8]),
    .SCLK_fromHost(io_in[9]),
    .M1_CLK_IN(io_in[10]),
    .M1_CLK_SELECT(io_in[11]),
    .S1_CLK_IN(io_in[12]),
    .S1_CLK_SELECT(io_in[13]),
    .SCSN_fromHost(io_in[14]),
    .MOSI_fromHost(io_in[15]),
    .MISO_fromClient(io_in[16]),
    .IRQ_OUT_fromClient(io_in[17]),
    .ID_fromClient(io_in[18]),

    // outputs
    .SCSN_toClient(io_out[19]),
    .SCLK_toClient(io_out[20]),
    .MOSI_toClient(io_out[21]),
    .EXT_RESET_N_toClient(io_out[22]),
    .ID_toHost(io_out[23]),
    .CLK_LED(io_out[24]),
    .MISO_toHost(io_out[25]),
    .HASH_LED(io_out[26]),
    .IRQ_OUT_toHost(io_out[27]),

    // hash macro exports
    .m1_clk_local(m1_clk_local),
    .HASH_EN(HASH_EN),
    .MACRO_WR_SELECT(MACRO_WR_SELECT),
    .DATA_TO_HASH(DATA_TO_HASH),
    .MACRO_RD_SELECT(MACRO_RD_SELECT),
    .HASH_ADDR(HASH_ADDR),
    .THREAD_COUNT(THREAD_COUNT[0]),
    .DATA_AVAILABLE(DATA_AVAILABLE),
    .DATA_FROM_HASH(DATA_FROM_HASH),

     // user_project_wrapper exports
     .zero(zero),
     .one(one)
  );

decred_hash_macro decred_hash_block0 (
      .CLK(m1_clk_local), 
      .HASH_EN(HASH_EN), 
      .MACRO_WR_SELECT(MACRO_WR_SELECT[0]),
      .DATA_TO_HASH(DATA_TO_HASH),
      .MACRO_RD_SELECT(MACRO_RD_SELECT[0]),
      .HASH_ADDR(HASH_ADDR),
      .THREAD_COUNT(THREAD_COUNT[0]),
      .DATA_AVAILABLE(DATA_AVAILABLE[0]),
      .DATA_FROM_HASH(DATA_FROM_HASH)
  );

decred_hash_macro decred_hash_block1 (
      .CLK(m1_clk_local), 
      .HASH_EN(HASH_EN), 
      .MACRO_WR_SELECT(MACRO_WR_SELECT[1]),
      .DATA_TO_HASH(DATA_TO_HASH),
      .MACRO_RD_SELECT(MACRO_RD_SELECT[1]),
      .HASH_ADDR(HASH_ADDR),
      .THREAD_COUNT(THREAD_COUNT[1]),
      .DATA_AVAILABLE(DATA_AVAILABLE[1]),
      .DATA_FROM_HASH(DATA_FROM_HASH)
  );

decred_hash_macro decred_hash_block2 (
      .CLK(m1_clk_local), 
      .HASH_EN(HASH_EN), 
      .MACRO_WR_SELECT(MACRO_WR_SELECT[2]),
      .DATA_TO_HASH(DATA_TO_HASH),
      .MACRO_RD_SELECT(MACRO_RD_SELECT[2]),
      .HASH_ADDR(HASH_ADDR),
      .THREAD_COUNT(THREAD_COUNT[2]),
      .DATA_AVAILABLE(DATA_AVAILABLE[2]),
      .DATA_FROM_HASH(DATA_FROM_HASH)
  );


decred_hash_macro decred_hash_block3 (
      .CLK(m1_clk_local), 
      .HASH_EN(HASH_EN), 
      .MACRO_WR_SELECT(MACRO_WR_SELECT[3]),
      .DATA_TO_HASH(DATA_TO_HASH),
      .MACRO_RD_SELECT(MACRO_RD_SELECT[3]),
      .HASH_ADDR(HASH_ADDR),
      .THREAD_COUNT(THREAD_COUNT[3]),
      .DATA_AVAILABLE(DATA_AVAILABLE[3]),
      .DATA_FROM_HASH(DATA_FROM_HASH)
  );

endmodule	// user_project_wrapper
`default_nettype wire
