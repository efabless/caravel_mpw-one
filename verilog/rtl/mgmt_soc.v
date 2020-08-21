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
    output [15:0] gpio_out_pad,			// Connect to out on gpio pad
    input  [15:0] gpio_in_pad,			// Connect to in on gpio pad
    output [15:0] gpio_mode0_pad,		// Connect to dm[0] on gpio pad
    output [15:0] gpio_mode1_pad,		// Connect to dm[2] on gpio pad
    output [15:0] gpio_outenb_pad,		// Connect to oe_n on gpio pad
    output [15:0] gpio_inenb_pad,		// Connect to inp_dis on gpio pad

    // LA signals
    input  [127:0] la_input,           	// From Mega-Project to cpu
    output [127:0] la_output,          	// From CPU to Mega-Project
    output [127:0] la_oe,              	// LA output enable (sensitiviy according to tri-state ?) 

    output 	      adc0_ena,
    output 	      adc0_convert,
    input  [9:0]  adc0_data,
    input  	      adc0_done,
    output	      adc0_clk,
    output [1:0]  adc0_inputsrc,
    output 	      adc1_ena,
    output 	      adc1_convert,
    output	      adc1_clk,
    output [1:0]  adc1_inputsrc,
    input  [9:0]  adc1_data,
    input  	      adc1_done,

    output	      dac_ena,
    output [9:0]  dac_value,

    output	      analog_out_sel,	// Analog output select (DAC or bandgap)
    output	      opamp_ena,		// Op-amp enable for analog output
    output	      opamp_bias_ena,	// Op-amp bias enable for analog output
    output	      bg_ena,			// Bandgap enable

    output	      comp_ena,
    output [1:0]  comp_ninputsrc,
    output [1:0]  comp_pinputsrc,
    output	      rcosc_ena,

    output	      overtemp_ena,
    input	      overtemp,
    input	      rcosc_in,		// RC oscillator output
    input	      xtal_in,		// crystal oscillator output
    input	      comp_in,		// comparator output
    input	      spi_sck,

    input [7:0]   spi_ro_config,
    input 	      spi_ro_xtal_ena,
    input 	      spi_ro_reg_ena,
    input 	      spi_ro_pll_dco_ena,
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

    // Crossbar Switch Slaves
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
    parameter integer MEM_WORDS = 256;
    parameter [31:0] STACKADDR = (4*MEM_WORDS);       // end of memory
    parameter [31:0] PROGADDR_RESET = 32'h 1000_0000; 
    parameter [31:0] PROGADDR_IRQ   = 32'h 0000_0000;

    // Slaves Base Addresses
    parameter RAM_BASE_ADR   = 32'h 0000_0000;
    parameter FLASH_BASE_ADR = 32'h 1000_0000;
    parameter UART_BASE_ADR  = 32'h 2000_0000;
    parameter GPIO_BASE_ADR  = 32'h 2100_0000;
    parameter LA_BASE_ADR   = 32'h 2200_0000;
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
    
    // LDO
    parameter LA_DATA_0 = 8'h00;
    parameter LA_DATA_1 = 8'h04;
    parameter LA_DATA_2 = 8'h08;
    parameter LA_DATA_3 = 8'h0c;
    parameter LA_ENA_0  = 8'h10;
    parameter LA_ENA_1  = 8'h14;
    parameter LA_ENA_2  = 8'h18;
    parameter LA_ENA_3  = 8'h1c;
    
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
    localparam NUM_SLAVES = 9;

    parameter [NUM_SLAVES*ADR_WIDTH-1: 0] ADR_MASK = {
        {8'h80, {ADR_WIDTH-8{1'b0}}},
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
        {LA_BASE_ADR},
        {GPIO_BASE_ADR},
        {UART_BASE_ADR},
        {FLASH_BASE_ADR},
        {RAM_BASE_ADR}
    };

    // memory-mapped I/O control registers
    wire [15:0] gpio_pullup;    	// Intermediate GPIO pullup
    wire [15:0] gpio_pulldown;  	// Intermediate GPIO pulldown
    wire [15:0] gpio_outenb;    	// Intermediate GPIO out enable (bar)
    wire [15:0] gpio_out;      	 	// Intermediate GPIO output

    wire [15:0] gpio;				// GPIO output data
    wire [15:0] gpio_pu;			// GPIO pull-up enable
    wire [15:0] gpio_pd;			// GPIO pull-down enable
    wire [15:0] gpio_oeb;			// GPIO output enable (sense negative)

    wire [1:0] rcosc_output_dest;	// RC oscillator output destination
    wire [1:0] overtemp_dest;		// Over-temperature alarm destination
    wire [1:0] pll_output_dest;		// PLL clock output destination
    wire [1:0] xtal_output_dest; 	// Crystal oscillator output destination
    wire [1:0] trap_output_dest; 	// Trap signal output destination
    wire [1:0] irq_7_inputsrc;		// IRQ 5 source
    wire [1:0] irq_8_inputsrc;		// IRQ 6 source

    // Analgo registers (not-used)
    reg	adc0_ena;					// ADC0 enable
    reg	adc0_convert;				// ADC0 convert
    reg [1:0] adc0_clksrc;			// ADC0 clock source
    reg [1:0] adc0_inputsrc;		// ADC0 input source
    reg adc1_ena;					// ADC1 enable
    reg adc1_convert;				// ADC1 convert
    reg [1:0] adc1_clksrc;			// ADC1 clock source
    reg [1:0] adc1_inputsrc;		// ADC1 input source
    reg	dac_ena;					// DAC enable
    reg [9:0] dac_value;			// DAC output value
    reg	comp_ena;					// Comparator enable
    reg [1:0] comp_ninputsrc;		// Comparator negative input source
    reg [1:0] comp_pinputsrc;		// Comparator positive input source
    reg [1:0] comp_output_dest; 	// Comparator output destination
    
    reg analog_out_sel;				// Analog output select
     reg	opamp_ena;					// Analog output op-amp enable
     reg	opamp_bias_ena;				// Analog output op-amp bias enable
     reg	bg_ena;						// Bandgap enable
    wire adc0_clk;					// ADC0 clock (multiplexed)
    wire adc1_clk;					// ADC1 clock (multiplexed)

    // ADC clock assignments
    assign adc0_clk = (adc0_clksrc == 2'b00) ? rcosc_in :
              (adc0_clksrc == 2'b01) ? spi_sck :
              (adc0_clksrc == 2'b10) ? xtal_in :
              ext_clk;

    assign adc1_clk = (adc1_clksrc == 2'b00) ? rcosc_in :
              (adc1_clksrc == 2'b01) ? spi_sck :
              (adc1_clksrc == 2'b10) ? xtal_in :
              ext_clk;

    // GPIO assignments
    assign gpio_out[0] = (comp_output_dest == 2'b01) ? comp_in : gpio[0];
    assign gpio_out[1] = (comp_output_dest == 2'b10) ? comp_in : gpio[1];
    assign gpio_out[2] = (rcosc_output_dest == 2'b01) ? rcosc_in : gpio[2];
    assign gpio_out[3] = (rcosc_output_dest == 2'b10) ? rcosc_in : gpio[3];
    assign gpio_out[4] = (rcosc_output_dest == 2'b11) ? rcosc_in : gpio[4];
    assign gpio_out[5] = (xtal_output_dest == 2'b01) ? xtal_in : gpio[5]; 
    assign gpio_out[6] = (xtal_output_dest == 2'b10) ? xtal_in : gpio[6]; 
    assign gpio_out[7] = (xtal_output_dest == 2'b11) ? xtal_in : gpio[7]; 
    assign gpio_out[8] = (pll_output_dest == 2'b01) ? pll_clk : gpio[8];
    assign gpio_out[9] = (pll_output_dest == 2'b10) ? pll_clk : gpio[9];
    assign gpio_out[10] = (pll_output_dest == 2'b11) ? clk : gpio[10];
    assign gpio_out[11] = (trap_output_dest == 2'b01) ? trap : gpio[11];
    assign gpio_out[12] = (trap_output_dest == 2'b10) ? trap : gpio[12];
    assign gpio_out[13] = (trap_output_dest == 2'b11) ? trap : gpio[13];
    assign gpio_out[14] = (overtemp_dest == 2'b01) ? overtemp : gpio[14];
    assign gpio_out[15] = (overtemp_dest == 2'b10) ? overtemp : gpio[15];

    assign gpio_outenb[0] = (comp_output_dest == 2'b00)  ? gpio_oeb[0] : 1'b0;
    assign gpio_outenb[1] = (comp_output_dest == 2'b00)  ? gpio_oeb[1] : 1'b0;
    assign gpio_outenb[2] = (rcosc_output_dest == 2'b00) ? gpio_oeb[2] : 1'b0; 
    assign gpio_outenb[3] = (rcosc_output_dest == 2'b00) ? gpio_oeb[3] : 1'b0;
    assign gpio_outenb[4] = (rcosc_output_dest == 2'b00) ? gpio_oeb[4] : 1'b0;
    assign gpio_outenb[5] = (xtal_output_dest == 2'b00)  ? gpio_oeb[5] : 1'b0;
    assign gpio_outenb[6] = (xtal_output_dest == 2'b00)  ? gpio_oeb[6] : 1'b0;
    assign gpio_outenb[7] = (xtal_output_dest == 2'b00)  ? gpio_oeb[7] : 1'b0;
    assign gpio_outenb[8] = (pll_output_dest == 2'b00)   ? gpio_oeb[8] : 1'b0;
    assign gpio_outenb[9] = (pll_output_dest == 2'b00)   ? gpio_oeb[9] : 1'b0;
    assign gpio_outenb[10] = (pll_output_dest == 2'b00)  ? gpio_oeb[10] : 1'b0;
    assign gpio_outenb[11] = (trap_output_dest == 2'b00) ? gpio_oeb[11] : 1'b0;
    assign gpio_outenb[12] = (trap_output_dest == 2'b00) ? gpio_oeb[12] : 1'b0;
    assign gpio_outenb[13] = (trap_output_dest == 2'b00) ? gpio_oeb[13] : 1'b0;
    assign gpio_outenb[14] = (overtemp_dest == 2'b00)    ? gpio_oeb[14] : 1'b0;
    assign gpio_outenb[15] = (overtemp_dest == 2'b00)    ? gpio_oeb[15] : 1'b0;

    assign gpio_pullup[0] = (comp_output_dest == 2'b00)  ? gpio_pu[0] : 1'b0;
    assign gpio_pullup[1] = (comp_output_dest == 2'b00)  ? gpio_pu[1] : 1'b0;
    assign gpio_pullup[2] = (rcosc_output_dest == 2'b00) ? gpio_pu[2] : 1'b0; 
    assign gpio_pullup[3] = (rcosc_output_dest == 2'b00) ? gpio_pu[3] : 1'b0;
    assign gpio_pullup[4] = (rcosc_output_dest == 2'b00) ? gpio_pu[4] : 1'b0;
    assign gpio_pullup[5] = (xtal_output_dest == 2'b00)  ? gpio_pu[5] : 1'b0;
    assign gpio_pullup[6] = (xtal_output_dest == 2'b00)  ? gpio_pu[6] : 1'b0;
    assign gpio_pullup[7] = (xtal_output_dest == 2'b00)  ? gpio_pu[7] : 1'b0;
    assign gpio_pullup[8] = (pll_output_dest == 2'b00)   ? gpio_pu[8] : 1'b0;
    assign gpio_pullup[9] = (pll_output_dest == 2'b00)   ? gpio_pu[9] : 1'b0;
    assign gpio_pullup[10] = (pll_output_dest == 2'b00)  ? gpio_pu[10] : 1'b0;
    assign gpio_pullup[11] = (trap_output_dest == 2'b00) ? gpio_pu[11] : 1'b0;
    assign gpio_pullup[12] = (trap_output_dest == 2'b00) ? gpio_pu[12] : 1'b0;
    assign gpio_pullup[13] = (trap_output_dest == 2'b00) ? gpio_pu[13] : 1'b0;
    assign gpio_pullup[14] = (overtemp_dest == 2'b00)    ? gpio_pu[14] : 1'b0;
    assign gpio_pullup[15] = (overtemp_dest == 2'b00)    ? gpio_pu[15] : 1'b0;

    assign gpio_pulldown[0] = (comp_output_dest == 2'b00)  ? gpio_pd[0] : 1'b0;
    assign gpio_pulldown[1] = (comp_output_dest == 2'b00)  ? gpio_pd[1] : 1'b0;
    assign gpio_pulldown[2] = (rcosc_output_dest == 2'b00) ? gpio_pd[2] : 1'b0; 
    assign gpio_pulldown[3] = (rcosc_output_dest == 2'b00) ? gpio_pd[3] : 1'b0;
    assign gpio_pulldown[4] = (rcosc_output_dest == 2'b00) ? gpio_pd[4] : 1'b0;
    assign gpio_pulldown[5] = (xtal_output_dest == 2'b00)  ? gpio_pd[5] : 1'b0;
    assign gpio_pulldown[6] = (xtal_output_dest == 2'b00)  ? gpio_pd[6] : 1'b0;
    assign gpio_pulldown[7] = (xtal_output_dest == 2'b00)  ? gpio_pd[7] : 1'b0;
    assign gpio_pulldown[8] = (pll_output_dest == 2'b00)   ? gpio_pd[8] : 1'b0;
    assign gpio_pulldown[9] = (pll_output_dest == 2'b00)   ? gpio_pd[9] : 1'b0;
    assign gpio_pulldown[10] = (pll_output_dest == 2'b00)  ? gpio_pd[10] : 1'b0;
    assign gpio_pulldown[11] = (trap_output_dest == 2'b00) ? gpio_pd[11] : 1'b0;
    assign gpio_pulldown[12] = (trap_output_dest == 2'b00) ? gpio_pd[12] : 1'b0;
    assign gpio_pulldown[13] = (trap_output_dest == 2'b00) ? gpio_pd[13] : 1'b0;
    assign gpio_pulldown[14] = (overtemp_dest == 2'b00)    ? gpio_pd[14] : 1'b0;
    assign gpio_pulldown[15] = (overtemp_dest == 2'b00)    ? gpio_pd[15] : 1'b0;

    // Convert GPIO signals to s8 pad signals
    convert_gpio_sigs convert_gpio_bit [15:0] (
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

    assign irq_7 = (irq_7_inputsrc == 2'b01) ? gpio_in_pad[0] :
            (irq_7_inputsrc == 2'b10) ? gpio_in_pad[1] :
            (irq_7_inputsrc == 2'b11) ? gpio_in_pad[2] : 1'b0;
    assign irq_8 = (irq_8_inputsrc == 2'b01) ? gpio_in_pad[3] :
            (irq_8_inputsrc == 2'b10) ? gpio_in_pad[4] :
            (irq_8_inputsrc == 2'b11) ? gpio_in_pad[5] : 1'b0;

    assign irq_uart = 0;
    assign irq_stall = 0;

    always @* begin
        irq = 0;
        irq[3] = irq_stall;
        irq[4] = irq_uart;
        irq[5] = irq_pin;
        irq[6] = irq_spi;
        irq[7] = irq_7;
        irq[8] = irq_8;
        irq[9] = comp_output_dest[0] & comp_output_dest[1] & comp_in;
        irq[10] = overtemp_dest[0] & overtemp_dest[1] & overtemp;
    end

    // wire mem_valid;
    // wire mem_instr;
    // wire mem_ready;
    // wire [31:0] mem_addr;
    // wire [31:0] mem_wdata;
    // wire [3:0] mem_wstrb;
    // wire [31:0] mem_rdata;

    // wire spimem_ready;
    // wire [31:0] spimem_rdata;

    // reg ram_ready;
    // wire [31:0] ram_rdata;

    // assign iomem_valid = mem_valid && (mem_addr[31:24] > 8'h 01);
    // assign iomem_wstrb = mem_wstrb;
    // assign iomem_addr = mem_addr;
    // assign iomem_wdata = mem_wdata;

    // wire spimemio_cfgreg_sel = mem_valid && (mem_addr == 32'h 0200_0000);
    // wire [31:0] spimemio_cfgreg_do;

    // wire        simpleuart_reg_div_sel = mem_valid && (mem_addr == 32'h 0200_0004);
    // wire [31:0] simpleuart_reg_div_do;

    // wire        simpleuart_reg_dat_sel = mem_valid && (mem_addr == 32'h 0200_0008);
    // wire [31:0] simpleuart_reg_dat_do;
    // wire        simpleuart_reg_dat_wait;

    // Akin to the slave ack ? 
    // assign mem_ready = (iomem_valid && iomem_ready) || spimem_ready || ram_ready || spimemio_cfgreg_sel ||
    // 		simpleuart_reg_div_sel || (simpleuart_reg_dat_sel && !simpleuart_reg_dat_wait);

    // Akin to wb_intercon -- mem_rdata like cpu_dat_i
    // assign mem_rdata = (iomem_valid && iomem_ready) ? iomem_rdata : spimem_ready ? spimem_rdata : ram_ready ? ram_rdata :
    // 		spimemio_cfgreg_sel ? spimemio_cfgreg_do : simpleuart_reg_div_sel ? simpleuart_reg_div_do :
    // 		simpleuart_reg_dat_sel ? simpleuart_reg_dat_do : 32'h 0000_0000;

    wire wb_clk_i;
    wire wb_rst_i;

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
        .OSC_ENA(OSC_ENA),
        .OSC_OUT(OSC_OUT),
        .XTAL_OUT(XTAL_OUT),
        .PLL_OUT(PLL_OUT),
        .TRAP_OUT(TRAP_OUT),
        .IRQ7_SRC(IRQ7_SRC),
        .IRQ8_SRC(IRQ8_SRC),
        .OVERTEMP_ENA(OVERTEMP_ENA),
        .OVERTEMP_DATA(OVERTEMP_DATA),
        .OVERTEMP_OUT(OVERTEMP_OUT)
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

        .overtemp(overtemp),
        .rcosc_ena(rcosc_ena),
        .rcosc_output_dest(rcosc_output_dest),
        .xtal_output_dest(xtal_output_dest),
        .pll_output_dest(pll_output_dest),
        .trap_output_dest(trap_output_dest),
        .irq_7_inputsrc(irq_7_inputsrc),
        .irq_8_inputsrc(irq_8_inputsrc),
        .overtemp_ena(overtemp_ena),
        .overtemp_dest(overtemp_dest)
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
        .la_ena(la_oe)
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
        .wbs_stb_o({ xbar_stb_o, sys_stb_i, spi_sys_stb_i, spimemio_cfg_stb_i, la_stb_i, gpio_stb_i, uart_stb_i, spimemio_flash_stb_i, mem_stb_i }), 
        .wbs_dat_i({ xbar_dat_i, sys_dat_o, spi_sys_dat_o, spimemio_cfg_dat_o, la_dat_o, gpio_dat_o, uart_dat_o, spimemio_flash_dat_o, mem_dat_o }),
        .wbs_ack_i({ xbar_ack_i, sys_ack_o, spi_sys_ack_o, spimemio_cfg_ack_o, la_ack_o, gpio_ack_o, uart_ack_o, spimemio_flash_ack_o, mem_ack_o })
    );

    // Akin to ram ack
    // always @(posedge clk)
    // ram_ready <= mem_valid && !mem_ready && mem_addr < 4*MEM_WORDS;

    always @(posedge clk) begin
        if (!resetn) begin
            adc0_ena <= 0;
            adc0_convert <= 0;
            adc0_clksrc <= 0;
            adc0_inputsrc <= 0;
            adc1_ena <= 0;
            adc1_convert <= 0;
            adc1_clksrc <= 0;
            adc1_inputsrc <= 0;
            dac_ena <= 0;
            dac_value <= 0;
            comp_ena <= 0;
            comp_ninputsrc <= 0;
            comp_pinputsrc <= 0;
            comp_output_dest <= 0;	
            analog_out_sel <= 0;
            opamp_ena <= 0;
            opamp_bias_ena <= 0;
            bg_ena <= 0;
        end else begin
            // iomem_ready <= 0;
            // if (iomem_valid && !iomem_ready && iomem_addr[31:8] == 24'h030000) begin
                // 	iomem_ready <= 1;	
                // end else if (iomem_addr[7:0] == 8'hc0) begin
                // 	iomem_rdata <= {31'd0, analog_out_sel};
                // 	if (iomem_wstrb[0]) analog_out_sel <= iomem_wdata[0];
                // end else if (iomem_addr[7:0] == 8'hc4) begin
                // 	iomem_rdata <= {31'd0, opamp_bias_ena};
                // 	if (iomem_wstrb[0]) opamp_bias_ena <= iomem_wdata[0];
                // end else if (iomem_addr[7:0] == 8'hc8) begin
                // 	iomem_rdata <= {31'd0, opamp_ena};
                // 	if (iomem_wstrb[0]) opamp_ena <= iomem_wdata[0];
                // end else if (iomem_addr[7:0] == 8'hd0) begin
                // 	iomem_rdata <= {31'd0, bg_ena};
                // 	if (iomem_wstrb[0]) bg_ena <= iomem_wdata[0];
            // end
        end
    end

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
