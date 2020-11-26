`default_nettype none
/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *  Revision 1,  July 2019:  Added signals to drive flash_clk and flash_csb
 *  output enable (inverted), tied to reset so that the flash is completely
 *  isolated from the processor when the processor is in reset.
 *
 *  Also: Made ram_wenb a 4-bit bus so that the memory access can be made
 *  byte-wide for byte-wide instructions.
 */

`ifdef PICORV32_V
`error "mgmt_soc.v must be read before picorv32.v!"
`endif

`define PICORV32_REGS mgmt_soc_regs

`include "picorv32.v"
`include "spimemio.v"
`include "simpleuart.v"
`include "simple_spi_master.v"
`include "counter_timer_high.v"
`include "counter_timer_low.v"
`include "wb_intercon.v"
`include "mem_wb.v"
`include "gpio_wb.v"
`include "sysctrl.v"
`include "la_wb.v"
`include "mprj_ctrl.v"
`include "convert_gpio_sigs.v"

module mgmt_soc (
`ifdef USE_POWER_PINS
    inout vdd1v8,	    /* 1.8V domain */
    inout vss,
`endif
    input clk,
    input resetn,

    // Trap state from CPU
    output trap,

    // GPIO (one pin)
    output gpio_out_pad,	// Connect to out on gpio pad
    input  gpio_in_pad,		// Connect to in on gpio pad
    output gpio_mode0_pad,	// Connect to dm[0] on gpio pad
    output gpio_mode1_pad,	// Connect to dm[2] on gpio pad
    output gpio_outenb_pad,	// Connect to oe_n on gpio pad
    output gpio_inenb_pad,	// Connect to inp_dis on gpio pad

    // LA signals
    input  [127:0] la_input,           	// From User Project to cpu
    output [127:0] la_output,          	// From CPU to User Project
    output [127:0] la_oen,              // LA output enable (active low) 

    // User Project I/O Configuration (serial load)
    input  mprj_vcc_pwrgood,
    input  mprj2_vcc_pwrgood,
    input  mprj_vdd_pwrgood,
    input  mprj2_vdd_pwrgood,
    output mprj_io_loader_resetn,
    output mprj_io_loader_clock,
    output mprj_io_loader_data,

    // User Project pad data (when management SoC controls the pad)
    input [`MPRJ_IO_PADS-1:0] mgmt_in_data,
    output [`MPRJ_IO_PADS-1:0] mgmt_out_data,
    output [`MPRJ_PWR_PADS-1:0] pwr_ctrl_out,

    // IRQ
    input  irq_spi,		// IRQ from standalone SPI

    // Flash memory control (SPI master)
    output flash_csb,
    output flash_clk,

    output flash_csb_oeb,
    output flash_clk_oeb,

    output flash_io0_oeb,
    output flash_io1_oeb,
    output flash_io2_oeb,
    output flash_io3_oeb,

    output flash_csb_ieb,
    output flash_clk_ieb,

    output flash_io0_ieb,
    output flash_io1_ieb,
    output flash_io2_ieb,
    output flash_io3_ieb,

    output flash_io0_do,
    output flash_io1_do,
    output flash_io2_do,
    output flash_io3_do,

    input  flash_io0_di,
    input  flash_io1_di,
    input  flash_io2_di,
    input  flash_io3_di,

    // SPI pass-thru mode
    input  pass_thru_mgmt,
    input  pass_thru_mgmt_csb,
    input  pass_thru_mgmt_sck,
    input  pass_thru_mgmt_sdi,
    output pass_thru_mgmt_sdo,

    // State of JTAG and SDO pins (override for management output use)
    output sdo_oenb_state,
    output jtag_oenb_state,
    // SPI master->slave direct link
    output hk_connect,
    // User clock monitoring
    input  user_clk,

    // WB MI A (User project)
    input mprj_ack_i,
    input [31:0] mprj_dat_i,
    output mprj_cyc_o,
    output mprj_stb_o,
    output mprj_we_o,
    output [3:0] mprj_sel_o,
    output [31:0] mprj_adr_o,
    output [31:0] mprj_dat_o,

    // MGMT area R/W interface for mgmt RAM
    output [`RAM_BLOCKS-1:0] mgmt_ena, 
    output [(`RAM_BLOCKS*4)-1:0] mgmt_wen_mask,
    output [`RAM_BLOCKS-1:0] mgmt_wen,
    output [7:0] mgmt_addr,
    output [31:0] mgmt_wdata,
    input  [(`RAM_BLOCKS*32)-1:0] mgmt_rdata,

    // MGMT area RO interface for user RAM 
    output mgmt_ena_ro,
    output [7:0] mgmt_addr_ro,
    input  [31:0] mgmt_rdata_ro
);
    /* Memory reverted back to 256 words while memory has to be synthesized */
    parameter [31:0] STACKADDR = (4*(`MEM_WORDS));       // end of memory
    parameter [31:0] PROGADDR_RESET = 32'h 1000_0000; 
    parameter [31:0] PROGADDR_IRQ   = 32'h 0000_0000;

    // Slaves Base Addresses
    parameter RAM_BASE_ADR    = 32'h 0000_0000;
    parameter STORAGE_RW_ADR  = 32'h 0100_0000;
    parameter STORAGE_RO_ADR  = 32'h 0200_0000;
    parameter FLASH_BASE_ADR  = 32'h 1000_0000;
    parameter UART_BASE_ADR   = 32'h 2000_0000;
    parameter GPIO_BASE_ADR   = 32'h 2100_0000;
    parameter COUNTER_TIMER0_BASE_ADR = 32'h 2200_0000;
    parameter COUNTER_TIMER1_BASE_ADR = 32'h 2300_0000;
    parameter SPI_MASTER_BASE_ADR = 32'h 2400_0000;
    parameter LA_BASE_ADR     = 32'h 2500_0000;
    parameter MPRJ_CTRL_ADR   = 32'h 2600_0000;
    parameter FLASH_CTRL_CFG  = 32'h 2D00_0000;
    parameter SYS_BASE_ADR    = 32'h 2F00_0000;
    parameter MPRJ_BASE_ADR   = 32'h 3000_0000;   // WB MI A
    
    // UART
    parameter UART_CLK_DIV = 8'h00;
    parameter UART_DATA    = 8'h04;

    // SPI Master
    parameter SPI_MASTER_CONFIG = 8'h00;
    parameter SPI_MASTER_DATA = 8'h04;

    // Counter-timer 0
    parameter COUNTER_TIMER0_CONFIG = 8'h00;
    parameter COUNTER_TIMER0_VALUE = 8'h04;
    parameter COUNTER_TIMER0_DATA = 8'h08;

    // Counter-timer 1
    parameter COUNTER_TIMER1_CONFIG = 8'h00;
    parameter COUNTER_TIMER1_VALUE = 8'h04;
    parameter COUNTER_TIMER1_DATA = 8'h08;
    
    // SOC GPIO
    parameter GPIO_DATA = 8'h00;
    parameter GPIO_ENA  = 8'h04;
    parameter GPIO_PU   = 8'h08;
    parameter GPIO_PD   = 8'h0c;
    
    // LA
    parameter LA_DATA_0 = 8'h00;
    parameter LA_DATA_1 = 8'h04;
    parameter LA_DATA_2 = 8'h08;
    parameter LA_DATA_3 = 8'h0c;
    parameter LA_ENA_0  = 8'h10;
    parameter LA_ENA_1  = 8'h14;
    parameter LA_ENA_2  = 8'h18;
    parameter LA_ENA_3  = 8'h1c;
    
    // System Control Registers
    parameter PWRGOOD       = 8'h00;
    parameter CLK_OUT       = 8'h04;
    parameter TRAP_OUT      = 8'h08;
    parameter IRQ_SRC       = 8'h0c;

    // Storage area RAM blocks
    parameter [(`RAM_BLOCKS*24)-1:0] RW_BLOCKS_ADR = {
        {24'h 10_0000},
        {24'h 00_0000}
    };

    parameter [23:0] RO_BLOCKS_ADR = {
        {24'h 00_0000}
    };

    // Wishbone Interconnect 
    localparam ADR_WIDTH = 32;
    localparam DAT_WIDTH = 32;
    localparam NUM_SLAVES = 14;

    parameter [NUM_SLAVES*ADR_WIDTH-1: 0] ADR_MASK = {
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}},
        {8'hFF, {ADR_WIDTH-8{1'b0}}}
    };

    parameter [NUM_SLAVES*ADR_WIDTH-1: 0] SLAVE_ADR = {
        {SYS_BASE_ADR},
        {FLASH_CTRL_CFG},
        {MPRJ_BASE_ADR},
        {MPRJ_CTRL_ADR},
        {LA_BASE_ADR},
	{SPI_MASTER_BASE_ADR},
	{COUNTER_TIMER1_BASE_ADR},
	{COUNTER_TIMER0_BASE_ADR},
        {GPIO_BASE_ADR},
        {UART_BASE_ADR},
        {FLASH_BASE_ADR},
        {STORAGE_RO_ADR},
        {STORAGE_RW_ADR},
        {RAM_BASE_ADR}
    };

    // The following functions are connected to specific user project
    // area pins, when under control of the management area (during
    // startup, and when not otherwise programmed for the user project).

    // JTAG      = jtag_out		 (inout)
    // SDO       = sdo_out	         (output)   (shared with SPI master)
    // SDI       = mgmt_in_data[2]       (input)    (shared with SPI master)
    // CSB       = mgmt_in_data[3]       (input)    (shared with SPI master)
    // SCK       = mgmt_in_data[4]       (input)    (shared with SPI master)
    // ser_rx    = mgmt_in_data[5]       (input)
    // ser_tx    = mgmt_out_data[6]      (output)
    // irq_pin   = mgmt_in_data[7]       (input)
    // flash_csb = mgmt_out_data[8]      (output)   (user area flash)
    // flash_sck = mgmt_out_data[9]      (output)   (user area flash)
    // flash_io0 = mgmt_in/out_data[10]  (input)    (user area flash)
    // flash_io1 = mgmt_in/out_data[11]  (output)   (user area flash)
    // irq2_pin	 = mgmt_in_data[12]	 (input)
    // trap_mon	 = mgmt_in_data[13]	 (output)
    // clk1_mon	 = mgmt_in_data[14]	 (output)
    // clk2_mon	 = mgmt_in_data[15]	 (output)

    // OEB lines for [0] and [1] are the only ones connected directly to
    // the pad.  All others have OEB controlled by the configuration bit
    // in the control block.

    // memory-mapped I/O control registers
    wire gpio_pullup;    	// Intermediate GPIO pullup
    wire gpio_pulldown;  	// Intermediate GPIO pulldown
    wire gpio_outenb;    	// Intermediate GPIO out enable (bar)
    wire gpio_out;      	// Intermediate GPIO output

    wire trap_output_dest; 	// Trap signal output destination
    wire clk1_output_dest; 	// Core clock1 signal output destination
    wire clk2_output_dest; 	// Core clock2 signal output destination
    wire irq_7_inputsrc;	// IRQ 7 source
    wire irq_8_inputsrc;	// IRQ 8 source

    // Convert GPIO signals to sky130_fd_io pad signals
    convert_gpio_sigs convert_gpio_bit (
        .gpio_out(gpio_out),
        .gpio_outenb(gpio_outenb),
        .gpio_pu(gpio_pullup),
        .gpio_pd(gpio_pulldown),
        .gpio_out_pad(gpio_out_pad),
        .gpio_outenb_pad(gpio_outenb_pad),
        .gpio_inenb_pad(gpio_inenb_pad),
        .gpio_mode1_pad(gpio_mode1_pad),
        .gpio_mode0_pad(gpio_mode0_pad)
    );

    reg [31:0] irq;
    wire irq_7;
    wire irq_8;
    wire irq_stall;
    wire irq_uart;
    wire irq_spi_master;
    wire irq_counter_timer0;
    wire irq_counter_timer1;
    wire ser_tx;

    wire wb_clk_i;
    wire wb_rst_i;

    assign irq_stall = 0;
    assign irq_7 = (irq_7_inputsrc == 1'b1) ? mgmt_in_data[7] : 1'b0;
    assign irq_8 = (irq_8_inputsrc == 1'b1) ? mgmt_in_data[12] : 1'b0;

    always @* begin
        irq = 0;
        irq[3] = irq_stall;
        irq[4] = irq_uart;
        irq[6] = irq_spi;
        irq[7] = irq_7;
        irq[9] = irq_spi_master;
        irq[10] = irq_counter_timer0;
        irq[11] = irq_counter_timer1;
    end

    // Assumption : no syscon module and wb_clk is the clock coming from the
    // caravel_clocking module

    assign wb_clk_i = clk;
    assign wb_rst_i = ~resetn;      // Redundant

    // Wishbone Master
    wire [31:0] cpu_adr_o;
    wire [31:0] cpu_dat_i;
    wire [3:0] cpu_sel_o;
    wire cpu_we_o;
    wire cpu_cyc_o;
    wire cpu_stb_o;
    wire [31:0] cpu_dat_o;
    wire cpu_ack_i;
    wire mem_instr;
    
    picorv32_wb #(
        .STACKADDR(STACKADDR),
        .PROGADDR_RESET(PROGADDR_RESET),
        .PROGADDR_IRQ(PROGADDR_IRQ),
        .BARREL_SHIFTER(1),
        .COMPRESSED_ISA(1),
        .ENABLE_MUL(1),
        .ENABLE_DIV(1),
        .ENABLE_IRQ(1),
        .ENABLE_IRQ_QREGS(0)
    ) cpu (
        .wb_clk_i (wb_clk_i),
        .wb_rst_i (wb_rst_i),
        .trap     (trap),
        .irq      (irq),
        .mem_instr(mem_instr),
        .wbm_adr_o(cpu_adr_o),     
        .wbm_dat_i(cpu_dat_i),    
        .wbm_stb_o(cpu_stb_o),    
        .wbm_ack_i(cpu_ack_i),    
        .wbm_cyc_o(cpu_cyc_o),    
        .wbm_dat_o(cpu_dat_o),    
        .wbm_we_o(cpu_we_o),      
        .wbm_sel_o(cpu_sel_o)     
    );

    // Wishbone Slave SPIMEMIO
    wire spimemio_flash_stb_i;
    wire spimemio_flash_ack_o;
    wire [31:0] spimemio_flash_dat_o;

    wire spimemio_cfg_stb_i;
    wire spimemio_cfg_ack_o;
    wire [31:0] spimemio_cfg_dat_o;

    spimemio_wb spimemio (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        .wb_adr_i(cpu_adr_o), 
        .wb_dat_i(cpu_dat_o),
        .wb_sel_i(cpu_sel_o),
        .wb_we_i(cpu_we_o),
        .wb_cyc_i(cpu_cyc_o),

        // FLash Slave
        .wb_flash_stb_i(spimemio_flash_stb_i),
        .wb_flash_ack_o(spimemio_flash_ack_o),
        .wb_flash_dat_o(spimemio_flash_dat_o),
        
        // Config Register Slave 
        .wb_cfg_stb_i(spimemio_cfg_stb_i),
        .wb_cfg_ack_o(spimemio_cfg_ack_o),
        .wb_cfg_dat_o(spimemio_cfg_dat_o),

	.pass_thru(pass_thru_mgmt),
	.pass_thru_csb(pass_thru_mgmt_csb),
	.pass_thru_sck(pass_thru_mgmt_sck),
	.pass_thru_sdi(pass_thru_mgmt_sdi),
	.pass_thru_sdo(pass_thru_mgmt_sdo),

        .flash_csb (flash_csb),
        .flash_clk (flash_clk),

        .flash_csb_oeb (flash_csb_oeb),
        .flash_clk_oeb (flash_clk_oeb),

        .flash_io0_oeb (flash_io0_oeb),
        .flash_io1_oeb (flash_io1_oeb),
        .flash_io2_oeb (flash_io2_oeb),
        .flash_io3_oeb (flash_io3_oeb),

        .flash_csb_ieb (flash_csb_ieb),
        .flash_clk_ieb (flash_clk_ieb),

        .flash_io0_ieb (flash_io0_ieb),
        .flash_io1_ieb (flash_io1_ieb),
        .flash_io2_ieb (flash_io2_ieb),
        .flash_io3_ieb (flash_io3_ieb),

        .flash_io0_do (flash_io0_do),
        .flash_io1_do (flash_io1_do),
        .flash_io2_do (flash_io2_do),
        .flash_io3_do (flash_io3_do),

        .flash_io0_di (flash_io0_di),
        .flash_io1_di (flash_io1_di),
        .flash_io2_di (flash_io2_di),
        .flash_io3_di (flash_io3_di)
    );

    // Wishbone Slave uart	
    wire uart_stb_i;
    wire uart_ack_o;
    wire [31:0] uart_dat_o;
    wire uart_enabled;

    simpleuart_wb #(
        .BASE_ADR(UART_BASE_ADR),
        .CLK_DIV(UART_CLK_DIV),
        .DATA(UART_DATA)
    ) simpleuart (
        // Wishbone Interface
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        .wb_adr_i(cpu_adr_o),      
        .wb_dat_i(cpu_dat_o),
        .wb_sel_i(cpu_sel_o),
        .wb_we_i(cpu_we_o),
        .wb_cyc_i(cpu_cyc_o),

        .wb_stb_i(uart_stb_i),
        .wb_ack_o(uart_ack_o),
        .wb_dat_o(uart_dat_o),

	.uart_enabled(uart_enabled),
        .ser_tx(ser_tx),
        .ser_rx(mgmt_in_data[5])
    );

    // Wishbone SPI master
    wire spi_master_stb_i;
    wire spi_master_ack_o;
    wire [31:0] spi_master_dat_o;

    simple_spi_master_wb #(
        .BASE_ADR(SPI_MASTER_BASE_ADR),
        .CONFIG(SPI_MASTER_CONFIG),
        .DATA(SPI_MASTER_DATA)
    ) simple_spi_master_inst (
        // Wishbone Interface
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        .wb_adr_i(cpu_adr_o),      
        .wb_dat_i(cpu_dat_o),
        .wb_sel_i(cpu_sel_o),
        .wb_we_i(cpu_we_o),
        .wb_cyc_i(cpu_cyc_o),

        .wb_stb_i(spi_master_stb_i),
        .wb_ack_o(spi_master_ack_o),
        .wb_dat_o(spi_master_dat_o),

	.hk_connect(hk_connect),
        .csb(mgmt_out_pre[3]),
        .sck(mgmt_out_pre[4]),
        .sdi(mgmt_in_data[1]),
        .sdo(mgmt_out_pre[2]),
        .sdoenb(),
	.irq(irq_spi_master)
    );

    wire counter_timer_strobe, counter_timer_offset;
    wire counter_timer0_enable, counter_timer1_enable;
    wire counter_timer0_stop, counter_timer1_stop;

    // Wishbone Counter-timer 0
    wire counter_timer0_stb_i;
    wire counter_timer0_ack_o;
    wire [31:0] counter_timer0_dat_o;

    counter_timer_low_wb #(
        .BASE_ADR(COUNTER_TIMER0_BASE_ADR),
        .CONFIG(COUNTER_TIMER0_CONFIG),
        .VALUE(COUNTER_TIMER0_VALUE),
        .DATA(COUNTER_TIMER0_DATA)
    ) counter_timer_0 (
        // Wishbone Interface
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        .wb_adr_i(cpu_adr_o),      
        .wb_dat_i(cpu_dat_o),
        .wb_sel_i(cpu_sel_o),
        .wb_we_i(cpu_we_o),
        .wb_cyc_i(cpu_cyc_o),

        .wb_stb_i(counter_timer0_stb_i),
        .wb_ack_o(counter_timer0_ack_o),
        .wb_dat_o(counter_timer0_dat_o),

	.enable_in(counter_timer1_enable),
	.stop_in(counter_timer1_stop),
	.strobe(counter_timer_strobe),
	.is_offset(counter_timer_offset),
	.enable_out(counter_timer0_enable),
	.stop_out(counter_timer0_stop),
	.irq(irq_counter_timer0)
    );

    // Wishbone Counter-timer 1
    wire counter_timer1_stb_i;
    wire counter_timer1_ack_o;
    wire [31:0] counter_timer1_dat_o;

    counter_timer_high_wb #(
        .BASE_ADR(COUNTER_TIMER1_BASE_ADR),
        .CONFIG(COUNTER_TIMER1_CONFIG),
        .VALUE(COUNTER_TIMER1_VALUE),
        .DATA(COUNTER_TIMER1_DATA)
    ) counter_timer_1 (
        // Wishbone Interface
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        .wb_adr_i(cpu_adr_o),      
        .wb_dat_i(cpu_dat_o),
        .wb_sel_i(cpu_sel_o),
        .wb_we_i(cpu_we_o),
        .wb_cyc_i(cpu_cyc_o),

        .wb_stb_i(counter_timer1_stb_i),
        .wb_ack_o(counter_timer1_ack_o),
        .wb_dat_o(counter_timer1_dat_o),

	.enable_in(counter_timer0_enable),
	.strobe(counter_timer_strobe),
	.stop_in(counter_timer0_stop),
	.is_offset(counter_timer_offset),
	.enable_out(counter_timer1_enable),
	.stop_out(counter_timer1_stop),
	.irq(irq_counter_timer1)
    );

    // Wishbone Slave GPIO Registers
    wire gpio_stb_i;
    wire gpio_ack_o;
    wire [31:0] gpio_dat_o;

    gpio_wb #(
        .BASE_ADR(GPIO_BASE_ADR),
        .GPIO_DATA(GPIO_DATA),
        .GPIO_ENA(GPIO_ENA),
        .GPIO_PD(GPIO_PD),
        .GPIO_PU(GPIO_PU)
    ) gpio_wb (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wb_adr_i(cpu_adr_o), 
        .wb_dat_i(cpu_dat_o),
        .wb_sel_i(cpu_sel_o),
        .wb_we_i(cpu_we_o),
        .wb_cyc_i(cpu_cyc_o),
        .wb_stb_i(gpio_stb_i),
        .wb_ack_o(gpio_ack_o),
        .wb_dat_o(gpio_dat_o),
        .gpio_in_pad(gpio_in_pad),
        .gpio(gpio_out),
        .gpio_oeb(gpio_outenb),
        .gpio_pu(gpio_pullup),
        .gpio_pd(gpio_pulldown)
    );

    // Wishbone Slave System Control Register
    wire sys_stb_i;
    wire sys_ack_o;
    wire [31:0] sys_dat_o;
    
    sysctrl_wb #(
        .BASE_ADR(SYS_BASE_ADR),
        .PWRGOOD(PWRGOOD),
        .CLK_OUT(CLK_OUT),
        .TRAP_OUT(TRAP_OUT),
        .IRQ_SRC(IRQ_SRC)
    ) sysctrl (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        .wb_adr_i(cpu_adr_o), 
        .wb_dat_i(cpu_dat_o),
        .wb_sel_i(cpu_sel_o),
        .wb_we_i(cpu_we_o),
        .wb_cyc_i(cpu_cyc_o),
        
        .wb_stb_i(sys_stb_i),
        .wb_ack_o(sys_ack_o),
        .wb_dat_o(sys_dat_o),

	.usr1_vcc_pwrgood(mprj_vcc_pwrgood),
	.usr2_vcc_pwrgood(mprj2_vcc_pwrgood),
	.usr1_vdd_pwrgood(mprj_vdd_pwrgood),
	.usr2_vdd_pwrgood(mprj2_vdd_pwrgood),
        .trap_output_dest(trap_output_dest),
        .clk1_output_dest(clk1_output_dest),
        .clk2_output_dest(clk2_output_dest),
        .irq_7_inputsrc(irq_7_inputsrc),
        .irq_8_inputsrc(irq_8_inputsrc)
    );

    // Logic Analyzer 
    wire la_stb_i;
    wire la_ack_o;
    wire [31:0] la_dat_o;

    la_wb #(
        .BASE_ADR(LA_BASE_ADR),
        .LA_DATA_0(LA_DATA_0),
        .LA_DATA_1(LA_DATA_1),
        .LA_DATA_3(LA_DATA_3),
        .LA_ENA_0(LA_ENA_0),
        .LA_ENA_1(LA_ENA_1),
        .LA_ENA_2(LA_ENA_2),
        .LA_ENA_3(LA_ENA_3)
    ) la (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        .wb_adr_i(cpu_adr_o), 
        .wb_dat_i(cpu_dat_o),
        .wb_sel_i(cpu_sel_o),
        .wb_we_i(cpu_we_o),
        .wb_cyc_i(cpu_cyc_o),
        
        .wb_stb_i(la_stb_i),
        .wb_ack_o(la_ack_o),
        .wb_dat_o(la_dat_o),

        .la_data(la_output),
        .la_data_in(la_input),
        .la_oen(la_oen)
    );
    
    // User project WB MI A port
    assign mprj_cyc_o = cpu_cyc_o;
    assign mprj_we_o  = cpu_we_o;
    assign mprj_sel_o = cpu_sel_o;
    assign mprj_adr_o = cpu_adr_o;
    assign mprj_dat_o = cpu_dat_o;

    // WB Slave User Project Control
    wire mprj_ctrl_stb_i;
    wire mprj_ctrl_ack_o;
    wire [31:0] mprj_ctrl_dat_o;
    wire [`MPRJ_IO_PADS-1:0] mgmt_out_pre;

    // Bits assigned to specific functions as outputs prevent the
    // mprj GPIO-as-output from applying data when that function
    // is active

    assign mgmt_out_data[`MPRJ_IO_PADS-1:16] = mgmt_out_pre[`MPRJ_IO_PADS-1:16];

    // Routing of output monitors (PLL, trap, clk1, clk2)
    assign mgmt_out_data[15] = clk2_output_dest ? user_clk : mgmt_out_pre[15];
    assign mgmt_out_data[14] = clk1_output_dest ? clk : mgmt_out_pre[14];
    assign mgmt_out_data[13] = trap_output_dest ? trap : mgmt_out_pre[13];

    assign mgmt_out_data[12:7] = mgmt_out_pre[12:7];
    assign mgmt_out_data[6] = uart_enabled ? ser_tx : mgmt_out_pre[6];
    assign mgmt_out_data[5:0] = mgmt_out_pre[5:0];

    mprj_ctrl_wb #(
        .BASE_ADR(MPRJ_CTRL_ADR)
    ) mprj_ctrl (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        .wb_adr_i(cpu_adr_o), 
        .wb_dat_i(cpu_dat_o),
        .wb_sel_i(cpu_sel_o),
        .wb_we_i(cpu_we_o),
        .wb_cyc_i(cpu_cyc_o),
        .wb_stb_i(mprj_ctrl_stb_i),
        .wb_ack_o(mprj_ctrl_ack_o),
        .wb_dat_o(mprj_ctrl_dat_o),

	.serial_clock(mprj_io_loader_clock),
	.serial_resetn(mprj_io_loader_resetn),
	.serial_data_out(mprj_io_loader_data),
	.sdo_oenb_state(sdo_oenb_state),
	.jtag_oenb_state(jtag_oenb_state),
	.mgmt_gpio_out(mgmt_out_pre),
	.mgmt_gpio_in(mgmt_in_data),
	.pwr_ctrl_out(pwr_ctrl_out)
    );

    // Wishbone Slave RAM
    wire mem_stb_i;
    wire mem_ack_o;
    wire [31:0] mem_dat_o;

    mem_wb soc_mem (
    `ifdef USE_POWER_PINS
        .VPWR(vdd1v8),
        .VGND(vss),
    `endif
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        .wb_adr_i(cpu_adr_o), 
        .wb_dat_i(cpu_dat_o),
        .wb_sel_i(cpu_sel_o),
        .wb_we_i(cpu_we_o),
        .wb_cyc_i(cpu_cyc_o),

        .wb_stb_i(mem_stb_i),
        .wb_ack_o(mem_ack_o), 
        .wb_dat_o(mem_dat_o)
    );

    wire stg_rw_stb_i;
    wire stg_ro_stb_i;
    wire stg_rw_ack_o;
    wire stg_ro_ack_o;
    wire [31:0] stg_rw_dat_o;
    wire [31:0] stg_ro_dat_o;

    // Storage area wishbone brige
    storage_bridge_wb #(
        .RW_BLOCKS_ADR(RW_BLOCKS_ADR),
        .RO_BLOCKS_ADR(RO_BLOCKS_ADR)
    ) wb_bridge (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wb_adr_i(cpu_adr_o),
        .wb_dat_i(cpu_dat_o),
        .wb_sel_i(cpu_sel_o),
        .wb_we_i(cpu_we_o),
        .wb_cyc_i(cpu_cyc_o),
        .wb_stb_i({stg_ro_stb_i, stg_rw_stb_i}),
        .wb_ack_o({stg_ro_ack_o, stg_rw_ack_o}),
        .wb_rw_dat_o(stg_rw_dat_o),
        // MGMT_AREA RO WB Interface  
        .wb_ro_dat_o(stg_ro_dat_o),
        // MGMT Area native memory interface
        .mgmt_ena(mgmt_ena), 
        .mgmt_wen_mask(mgmt_wen_mask),
        .mgmt_wen(mgmt_wen),
        .mgmt_addr(mgmt_addr),
        .mgmt_wdata(mgmt_wdata),
        .mgmt_rdata(mgmt_rdata),
        // MGMT_AREA RO interface 
        .mgmt_ena_ro(mgmt_ena_ro),
        .mgmt_addr_ro(mgmt_addr_ro),
        .mgmt_rdata_ro(mgmt_rdata_ro)
    );

    // Wishbone intercon logic
    wb_intercon #(
        .AW(ADR_WIDTH),
        .DW(DAT_WIDTH),
        .NS(NUM_SLAVES),
        .ADR_MASK(ADR_MASK),
        .SLAVE_ADR(SLAVE_ADR)
    ) intercon (
        // Master Interface
        .wbm_adr_i(cpu_adr_o),
        .wbm_stb_i(cpu_stb_o),
        .wbm_dat_o(cpu_dat_i),
        .wbm_ack_o(cpu_ack_i),

        // Slaves Interface
        .wbs_stb_o({ sys_stb_i, spimemio_cfg_stb_i,
		mprj_stb_o, mprj_ctrl_stb_i, la_stb_i, 
		spi_master_stb_i, counter_timer1_stb_i, counter_timer0_stb_i,
		gpio_stb_i, uart_stb_i,
		spimemio_flash_stb_i, stg_ro_stb_i, stg_rw_stb_i, mem_stb_i }), 
        .wbs_dat_i({ sys_dat_o, spimemio_cfg_dat_o,
		mprj_dat_i, mprj_ctrl_dat_o, la_dat_o,
		spi_master_dat_o, counter_timer1_dat_o, counter_timer0_dat_o,
		gpio_dat_o, uart_dat_o,
		spimemio_flash_dat_o, stg_ro_dat_o ,stg_rw_dat_o, mem_dat_o }),
        .wbs_ack_i({ sys_ack_o, spimemio_cfg_ack_o,
		mprj_ack_i, mprj_ctrl_ack_o, la_ack_o,
		spi_master_ack_o, counter_timer1_ack_o, counter_timer0_ack_o,
		gpio_ack_o, uart_ack_o,
		spimemio_flash_ack_o, stg_ro_ack_o, stg_rw_ack_o, mem_ack_o })
    );

endmodule

// Implementation note:
// Replace the following two modules with wrappers for your SRAM cells.

module mgmt_soc_regs (
    input clk, wen,
    input [5:0] waddr,
    input [5:0] raddr1,
    input [5:0] raddr2,
    input [31:0] wdata,
    output [31:0] rdata1,
    output [31:0] rdata2
);
    reg [31:0] regs [0:31];

    always @(posedge clk)
        if (wen) regs[waddr[4:0]] <= wdata;

    assign rdata1 = regs[raddr1[4:0]];
    assign rdata2 = regs[raddr2[4:0]];
endmodule
`default_nettype wire
