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
`error "openstriVe_soc.v must be read before picorv32.v!"
`endif

`define PICORV32_REGS openstriVe_soc_regs

`include "picorv32.v"
`include "spimemio.v"
`include "simpleuart.v"
`include "wb_intercon.v"
`include "mem_wb.v"
`include "gpio_wb.v"
`include "spi_sysctrl.v"
`include "sysctrl.v"
`include "la_wb.v"
`include "mprj_ctrl.v"

module mgmt_soc (
`ifdef LVS
    inout vdd1v8,	    /* 1.8V domain */
    inout vss,
`endif
    input pll_clk,
    input ext_clk,
    input ext_clk_sel,

    input clk,
    input resetn,

    // Memory mapped I/O signals
    output [1:0] gpio_out_pad,		// Connect to out on gpio pad
    input  [1:0] gpio_in_pad,		// Connect to in on gpio pad
    output [1:0] gpio_mode0_pad,	// Connect to dm[0] on gpio pad
    output [1:0] gpio_mode1_pad,	// Connect to dm[2] on gpio pad
    output [1:0] gpio_outenb_pad,	// Connect to oe_n on gpio pad
    output [1:0] gpio_inenb_pad,	// Connect to inp_dis on gpio pad

    // LA signals
    input  [127:0] la_input,           	// From Mega-Project to cpu
    output [127:0] la_output,          	// From CPU to Mega-Project
    output [127:0] la_oen,              // LA output enable (active low) 

    // Mega-Project Control
    output [MPRJ_IO_PADS-1:0] mprj_io_oeb_n,
    output [MPRJ_IO_PADS-1:0] mprj_io_hldh_n,
    output [MPRJ_IO_PADS-1:0] mprj_io_enh,
    output [MPRJ_IO_PADS-1:0] mprj_io_inp_dis,
    output [MPRJ_IO_PADS-1:0] mprj_io_ib_mode_sel,
    output [MPRJ_IO_PADS-1:0] mprj_io_analog_en,
    output [MPRJ_IO_PADS-1:0] mprj_io_analog_sel,
    output [MPRJ_IO_PADS-1:0] mprj_io_analog_pol,
    output [MPRJ_IO_PADS*3-1:0] mprj_io_dm,

    input [7:0]   spi_ro_config,
    input 	  spi_ro_pll_dco_ena,
    input [4:0]   spi_ro_pll_div,
    input [2:0]   spi_ro_pll_sel,
    input [25:0]  spi_ro_pll_trim,

    input [11:0]  spi_ro_mfgr_id,
    input [7:0]   spi_ro_prod_id,
    input [3:0]   spi_ro_mask_rev,

    output ser_tx,
    input  ser_rx,

    // IRQ
    input  irq_pin,		// dedicated IRQ pin
    input  irq_spi,		// IRQ from standalone SPI

    // trap
    output trap,

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

    // WB MI A (Mega project)
    input mprj_ack_i,
    input [31:0] mprj_dat_i,
    output mprj_cyc_o,
    output mprj_stb_o,
    output mprj_we_o,
    output [3:0] mprj_sel_o,
    output [31:0] mprj_adr_o,
    output [31:0] mprj_dat_o,
	
    // WB MI B (xbar)
    input [31:0] xbar_dat_i,
    input xbar_ack_i,
    output xbar_cyc_o,	
    output xbar_stb_o,
    output xbar_we_o,
    output [3:0] xbar_sel_o,
    output [31:0] xbar_adr_o,
    output [31:0] xbar_dat_o
);
    /* Memory reverted back to 256 words while memory has to be synthesized */
    parameter integer MEM_WORDS = 8192;
    parameter [31:0] STACKADDR = (4*MEM_WORDS);       // end of memory
    parameter [31:0] PROGADDR_RESET = 32'h 1000_0000; 
    parameter [31:0] PROGADDR_IRQ   = 32'h 0000_0000;

    // Slaves Base Addresses
    parameter RAM_BASE_ADR   = 32'h 0000_0000;
    parameter FLASH_BASE_ADR = 32'h 1000_0000;
    parameter UART_BASE_ADR  = 32'h 2000_0000;
    parameter GPIO_BASE_ADR  = 32'h 2100_0000;
    parameter LA_BASE_ADR    = 32'h 2200_0000;
    parameter MPRJ_CTRL_ADR  = 32'h 2300_0000;
    parameter MPRJ_BASE_ADR  = 32'h 3000_0000;   // WB MI A
    parameter SYS_BASE_ADR   = 32'h 2F00_0000;
    parameter SPI_BASE_ADR   = 32'h 2E00_0000;
    parameter FLASH_CTRL_CFG = 32'h 2D00_0000;
    parameter XBAR_BASE_ADR  = 32'h 8000_0000;

    // UART
    parameter UART_CLK_DIV = 8'h00;
    parameter UART_DATA    = 8'h04;
    
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
    
    // Mega-Project Control
    parameter MPRJ_IO_PADS  = 32;
    parameter MPRJ_PWR_CTRL = 32;
   
    // SPI-Controlled Registers 
    parameter SPI_CFG        = 8'h00;
    parameter SPI_ENA        = 8'h04;
    parameter SPI_PLL_CFG    = 8'h08;
    parameter SPI_MFGR_ID    = 8'h0c;
    parameter SPI_PROD_ID    = 8'h10;
    parameter SPI_MASK_REV   = 8'h14;
    parameter SPI_PLL_BYPASS = 8'h18;
    
    // System Control Registers
    parameter OSC_ENA       = 8'h00;
    parameter OSC_OUT       = 8'h04;
    parameter XTAL_OUT      = 8'h08;
    parameter PLL_OUT       = 8'h0c;
    parameter TRAP_OUT      = 8'h10;
    parameter IRQ7_SRC      = 8'h14;
    parameter IRQ8_SRC      = 8'h18;
    parameter OVERTEMP_ENA  = 8'h1c;
    parameter OVERTEMP_DATA = 8'h20;
    parameter OVERTEMP_OUT  = 8'h24;

    // Wishbone Interconnect 
    localparam ADR_WIDTH = 32;
    localparam DAT_WIDTH = 32;
    localparam NUM_SLAVES = 11;

    parameter [NUM_SLAVES*ADR_WIDTH-1: 0] ADR_MASK = {
        {8'h80, {ADR_WIDTH-8{1'b0}}},
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
        {XBAR_BASE_ADR},
        {SYS_BASE_ADR},
        {SPI_BASE_ADR},
        {FLASH_CTRL_CFG},
        {MPRJ_BASE_ADR},
        {MPRJ_CTRL_ADR},
        {LA_BASE_ADR},
        {GPIO_BASE_ADR},
        {UART_BASE_ADR},
        {FLASH_BASE_ADR},
        {RAM_BASE_ADR}
    };

    // memory-mapped I/O control registers
    wire [1:0] gpio_pullup;    	// Intermediate GPIO pullup
    wire [1:0] gpio_pulldown;  	// Intermediate GPIO pulldown
    wire [1:0] gpio_outenb;    	// Intermediate GPIO out enable (bar)
    wire [1:0] gpio_out;      	// Intermediate GPIO output

    wire [1:0] gpio;		// GPIO output data
    wire [1:0] gpio_pu;		// GPIO pull-up enable
    wire [1:0] gpio_pd;		// GPIO pull-down enable
    wire [1:0] gpio_oeb;	// GPIO output enable (sense negative)

    wire pll_output_dest;	// PLL clock output destination
    wire trap_output_dest; 	// Trap signal output destination
    wire irq_7_inputsrc;	// IRQ 7 source
    wire irq_8_inputsrc;	// IRQ 8 source

    // GPIO assignments
    assign gpio_out[0] = (pll_output_dest == 1'b1) ? pll_clk : gpio[0];
    assign gpio_out[1] = (trap_output_dest == 1'b1) ? trap : gpio[1];

    assign gpio_outenb[0] = (pll_output_dest == 1'b0)   ? gpio_oeb[0] : 1'b0;
    assign gpio_outenb[1] = (trap_output_dest == 1'b0) ? gpio_oeb[1] : 1'b0;

    assign gpio_pullup[0] = (pll_output_dest == 1'b0)   ? gpio_pu[0] : 1'b0;
    assign gpio_pullup[1] = (trap_output_dest == 1'b0) ? gpio_pu[1] : 1'b0;

    assign gpio_pulldown[0] = (pll_output_dest == 1'b0)   ? gpio_pd[0] : 1'b0;
    assign gpio_pulldown[1] = (trap_output_dest == 1'b0) ? gpio_pd[1] : 1'b0;

    // Convert GPIO signals to sky130_fd_io pad signals
    convert_gpio_sigs convert_gpio_bit [1:0] (
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

    wire [7:0] mprj_io_oeb;
    convert_gpio_sigs convert_io_bit [7:0] (
        .gpio_out(),
        .gpio_outenb(mprj_io_oeb),
        .gpio_pu(mprj_io_pu),
        .gpio_pd(mprj_io_pd),
        .gpio_out_pad(),
        .gpio_outenb_pad(mprj_io_outenb_pad),
        .gpio_inenb_pad(mprj_io_inenb_pad),
        .gpio_mode1_pad(mprj_io_mode1_pad),
        .gpio_mode0_pad(mprj_io_mode0_pad)
    );
    
    reg [31:0] irq;
    wire irq_7;
    wire irq_8;
    wire irq_stall;
    wire irq_uart;

    assign irq_uart = 0;
    assign irq_stall = 0;
    assign irq_7 = (irq_7_inputsrc == 1'b1) ? gpio_in_pad[0] : 1'b0;
    assign irq_8 = (irq_8_inputsrc == 1'b1) ? gpio_in_pad[1] : 1'b0;

    always @* begin
        irq = 0;
        irq[3] = irq_stall;
        irq[4] = irq_uart;
        irq[5] = irq_pin;
        irq[6] = irq_spi;
        irq[7] = irq_7;
        irq[8] = irq_8;
    end

    // Assumption : no syscon module and wb_clk is the clock coming from the chip pin ? 
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

    assign xbar_cyc_o = cpu_cyc_o;
    assign xbar_we_o  = cpu_we_o;
    assign xbar_sel_o = cpu_sel_o;
    assign xbar_adr_o = cpu_adr_o;
    assign xbar_dat_o = cpu_dat_o;
    
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

        .ser_tx(ser_tx),
        .ser_rx(ser_rx)
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
        .gpio(gpio),
        .gpio_oeb(gpio_oeb),
        .gpio_pu(gpio_pu),
        .gpio_pd(gpio_pd)
    );

    // Wishbone SPI System Control Registers (RO)
    wire spi_sys_stb_i;
    wire spi_sys_ack_o;
    wire [31:0] spi_sys_dat_o;

    spi_sysctrl_wb #(
        .BASE_ADR(SPI_BASE_ADR),
        .SPI_CFG(SPI_CFG),
        .SPI_ENA(SPI_ENA),
        .SPI_PLL_CFG(SPI_PLL_CFG),
        .SPI_MFGR_ID(SPI_MFGR_ID),
        .SPI_PROD_ID(SPI_PROD_ID),
        .SPI_MASK_REV(SPI_MASK_REV),
        .SPI_PLL_BYPASS(SPI_PLL_BYPASS)
    ) spi_sysctrl (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        .wb_adr_i(cpu_adr_o), 
        .wb_dat_i(cpu_dat_o),
        .wb_sel_i(cpu_sel_o),
        .wb_we_i(cpu_we_o),
        .wb_cyc_i(cpu_cyc_o),

        .wb_stb_i(spi_sys_stb_i),
        .wb_ack_o(spi_sys_ack_o),
        .wb_dat_o(spi_sys_dat_o),
        
        .spi_ro_config(spi_ro_config), // (verify) wire input to the core not connected to HKSPI, what should it be connected to ? 
        .spi_ro_pll_div(spi_ro_pll_div), 
        .spi_ro_pll_sel(spi_ro_pll_sel),
        .spi_ro_xtal_ena(spi_ro_xtal_ena),
        .spi_ro_reg_ena(spi_ro_reg_ena), 
    
        .spi_ro_pll_trim(spi_ro_pll_trim),
        .spi_ro_pll_dco_ena(spi_ro_pll_dco_ena),  

        .spi_ro_mfgr_id(spi_ro_mfgr_id),
        .spi_ro_prod_id(spi_ro_prod_id), 
        .spi_ro_mask_rev(spi_ro_mask_rev), 
        .pll_bypass(ext_clk_sel)
    );
    
    // Wishbone Slave System Control Register
    wire sys_stb_i;
    wire sys_ack_o;
    wire [31:0] sys_dat_o;
    
    sysctrl_wb #(
        .BASE_ADR(SYS_BASE_ADR),
        .PLL_OUT(PLL_OUT),
        .TRAP_OUT(TRAP_OUT),
        .IRQ7_SRC(IRQ7_SRC),
        .IRQ8_SRC(IRQ8_SRC)
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

        .pll_output_dest(pll_output_dest),
        .trap_output_dest(trap_output_dest),
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
    
    // WB Slave Mega-Project Control
    wire mprj_ctrl_stb_i;
    wire mprj_ctrl_ack_o;
    wire [31:0] mprj_ctrl_dat_o;

    mprj_ctrl_wb #(
        .BASE_ADR(MPRJ_CTRL_ADR),
        .IO_PADS(MPRJ_IO_PADS),
        .PWR_CTRL(MPRJ_PWR_CTRL)
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

        .output_en_n(mprj_io_oeb_n),
        .holdh_n(mprj_io_hldh_n),
        .enableh(mprj_io_enh),
        .input_dis(mprj_io_inp_dis),
        .ib_mode_sel(mprj_io_ib_mode_sel),
        .analog_en(mprj_io_analog_en),
        .analog_sel(mprj_io_analog_sel),
        .analog_pol(mprj_io_analog_pol),
        .digital_mode(mprj_io_dm)
    );

    // Wishbone Slave RAM
    wire mem_stb_i;
    wire mem_ack_o;
    wire [31:0] mem_dat_o;

    mem_wb #(
        .MEM_WORDS(MEM_WORDS)
    ) soc_mem (
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
        .wbs_stb_o({ xbar_stb_o, sys_stb_i, spi_sys_stb_i, spimemio_cfg_stb_i, mprj_stb_o, mprj_ctrl_stb_i, la_stb_i, gpio_stb_i, uart_stb_i, spimemio_flash_stb_i, mem_stb_i }), 
        .wbs_dat_i({ xbar_dat_i, sys_dat_o, spi_sys_dat_o, spimemio_cfg_dat_o, mprj_dat_i, mprj_ctrl_dat_o, la_dat_o, gpio_dat_o, uart_dat_o, spimemio_flash_dat_o, mem_dat_o }),
        .wbs_ack_i({ xbar_ack_i, sys_ack_o, spi_sys_ack_o, spimemio_cfg_ack_o, mprj_ack_i, mprj_ctrl_ack_o, la_ack_o, gpio_ack_o, uart_ack_o, spimemio_flash_ack_o, mem_ack_o })
    );

endmodule


/* Convert the standard set of GPIO signals: input, output, output_enb,
 * pullup, and pulldown into the set needed by the s8 GPIO pads:
 * input, output, output_enb, input_enb, mode.  Note that dm[2] on
 * thepads is always equal to dm[1] in this setup, so mode is shown as
 * only a 2-bit signal.
 *
 * This module is bit-sliced.  Instantiate once for each GPIO pad.
 */

module convert_gpio_sigs (
    input        gpio_out,
    input        gpio_outenb,
    input        gpio_pu,
    input        gpio_pd,
    output       gpio_out_pad,
    output       gpio_outenb_pad,
    output       gpio_inenb_pad,
    output       gpio_mode1_pad,
    output       gpio_mode0_pad
);

    assign gpio_out_pad = (gpio_pu == 1'b0 && gpio_pd == 1'b0) ? gpio_out :
            (gpio_pu == 1'b1) ? 1 : 0;

    assign gpio_outenb_pad = (gpio_outenb == 1'b0) ? 0 :
            (gpio_pu == 1'b1 || gpio_pd == 1'b1) ? 0 : 1;

    assign gpio_inenb_pad = ~gpio_outenb;

    assign gpio_mode1_pad = ~gpio_outenb_pad;
    assign gpio_mode0_pad = gpio_outenb;

endmodule

// Implementation note:
// Replace the following two modules with wrappers for your SRAM cells.

module openstriVe_soc_regs (
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
