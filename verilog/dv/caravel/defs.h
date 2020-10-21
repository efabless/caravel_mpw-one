#ifndef _STRIVE_H_
#define _STRIVE_H_

#include <stdint.h>
#include <stdbool.h>

// a pointer to this is a null pointer, but the compiler does not
// know that because "sram" is a linker symbol from sections.lds.
extern uint32_t sram;

// Pointer to firmware flash routines
extern uint32_t flashio_worker_begin;
extern uint32_t flashio_worker_end;

// SYNTH_MEM (0x0100_0000)
#define reg_synth_mem (*(volatile uint32_t*)0x01000000)

// UART (0x2000_0000)
#define reg_uart_clkdiv (*(volatile uint32_t*)0x20000000)
#define reg_uart_data   (*(volatile uint32_t*)0x20000004)
#define reg_uart_enable (*(volatile uint32_t*)0x20000008)

// GPIO (0x2100_0000)
#define reg_gpio_data (*(volatile uint32_t*)0x21000000)
#define reg_gpio_ena  (*(volatile uint32_t*)0x21000004)
#define reg_gpio_pu   (*(volatile uint32_t*)0x21000008)
#define reg_gpio_pd   (*(volatile uint32_t*)0x2100000c)

// Logic Analyzer (0x2200_0000)
#define reg_la0_data (*(volatile uint32_t*)0x25000000)
#define reg_la1_data (*(volatile uint32_t*)0x25000004)
#define reg_la2_data (*(volatile uint32_t*)0x25000008)
#define reg_la3_data (*(volatile uint32_t*)0x2500000c)

#define reg_la0_ena (*(volatile uint32_t*)0x25000010)
#define reg_la1_ena (*(volatile uint32_t*)0x25000014)
#define reg_la2_ena (*(volatile uint32_t*)0x25000018)
#define reg_la3_ena (*(volatile uint32_t*)0x2500001c)

// Mega Project Control (0x2300_0000)
#define reg_mprj_datal (*(volatile uint32_t*)0x26000000)
#define reg_mprj_datah (*(volatile uint32_t*)0x26000004)
#define reg_mprj_xfer (*(volatile uint32_t*)0x26000008)

#define reg_mprj_io_0 (*(volatile uint32_t*)0x2600000c)
#define reg_mprj_io_1 (*(volatile uint32_t*)0x26000010)
#define reg_mprj_io_2 (*(volatile uint32_t*)0x26000014)
#define reg_mprj_io_3 (*(volatile uint32_t*)0x26000018)
#define reg_mprj_io_4 (*(volatile uint32_t*)0x2600001c)
#define reg_mprj_io_5 (*(volatile uint32_t*)0x26000020)
#define reg_mprj_io_6 (*(volatile uint32_t*)0x26000024)

#define reg_mprj_io_7 (*(volatile uint32_t*)0x26000028)
#define reg_mprj_io_8 (*(volatile uint32_t*)0x2600002c)
#define reg_mprj_io_9 (*(volatile uint32_t*)0x26000030)
#define reg_mprj_io_10 (*(volatile uint32_t*)0x26000034)

#define reg_mprj_io_11 (*(volatile uint32_t*)0x26000038)
#define reg_mprj_io_12 (*(volatile uint32_t*)0x2600003c)
#define reg_mprj_io_13 (*(volatile uint32_t*)0x26000040)
#define reg_mprj_io_14 (*(volatile uint32_t*)0x26000044)

#define reg_mprj_io_15 (*(volatile uint32_t*)0x26000048)
#define reg_mprj_io_16 (*(volatile uint32_t*)0x2600004c)
#define reg_mprj_io_17 (*(volatile uint32_t*)0x26000050)
#define reg_mprj_io_18 (*(volatile uint32_t*)0x26000054)

#define reg_mprj_io_19 (*(volatile uint32_t*)0x26000058)
#define reg_mprj_io_20 (*(volatile uint32_t*)0x2600005c)
#define reg_mprj_io_21 (*(volatile uint32_t*)0x26000060)
#define reg_mprj_io_22 (*(volatile uint32_t*)0x26000064)

#define reg_mprj_io_23 (*(volatile uint32_t*)0x26000068)
#define reg_mprj_io_24 (*(volatile uint32_t*)0x2600006c)
#define reg_mprj_io_25 (*(volatile uint32_t*)0x26000070)
#define reg_mprj_io_26 (*(volatile uint32_t*)0x26000074)

#define reg_mprj_io_27 (*(volatile uint32_t*)0x26000078)
#define reg_mprj_io_28 (*(volatile uint32_t*)0x2600007c)
#define reg_mprj_io_29 (*(volatile uint32_t*)0x26000080)
#define reg_mprj_io_30 (*(volatile uint32_t*)0x26000084)
#define reg_mprj_io_31 (*(volatile uint32_t*)0x26000088)

#define reg_mprj_io_32 (*(volatile uint32_t*)0x2600008c)
#define reg_mprj_io_33 (*(volatile uint32_t*)0x26000090)
#define reg_mprj_io_34 (*(volatile uint32_t*)0x26000094)
#define reg_mprj_io_35 (*(volatile uint32_t*)0x26000098)
#define reg_mprj_io_36 (*(volatile uint32_t*)0x2600009c)
#define reg_mprj_io_37 (*(volatile uint32_t*)0x260000a0)

// Mega Project Slaves (0x3000_0000)
#define reg_mprj_slave (*(volatile uint32_t*)0x30000000)

// Flash Control SPI Configuration (2D00_0000)
#define reg_spictrl (*(volatile uint32_t*)0x2d000000)         

// Counter-Timer 0 Configuration
#define reg_timer0_config (*(volatile uint32_t*)0x22000000)
#define reg_timer0_value  (*(volatile uint32_t*)0x22000004)
#define reg_timer0_data   (*(volatile uint32_t*)0x22000008)

// Counter-Timer 1 Configuration
#define reg_timer1_config (*(volatile uint32_t*)0x23000000)
#define reg_timer1_value  (*(volatile uint32_t*)0x23000004)
#define reg_timer1_data   (*(volatile uint32_t*)0x23000008)

// SPI Master Configuration
#define reg_spimaster_config (*(volatile uint32_t*)0x24000000)
#define reg_spimaster_data   (*(volatile uint32_t*)0x24000004)

// System Area (0x2F00_0000)
#define reg_clk1_out_dest  (*(volatile uint32_t*)0x2F000000)
#define reg_clk2_out_dest  (*(volatile uint32_t*)0x2F000004)
#define reg_trap_out_dest (*(volatile uint32_t*)0x2F000008)
#define reg_irq7_source (*(volatile uint32_t*)0x2F00000C)
#define reg_irq8_source (*(volatile uint32_t*)0x2F000010)

// Crossbar Slave Addresses (0x8000_0000 - 0xB000_0000)
#define qspi_ctrl_slave    (*(volatile uint32_t*)0x80000000)
#define storage_area_slave (*(volatile uint32_t*)0x90000000)
#define mega_any_slave1    (*(volatile uint32_t*)0xA0000000)
#define mega_any_slave2    (*(volatile uint32_t*)0xB0000000)

// Useful GPIO mode values
#define GPIO_MODE_MGMT_STD_INPUT_NOPULL    0x0403
#define GPIO_MODE_MGMT_STD_INPUT_PULLDOWN  0x0803
#define GPIO_MODE_MGMT_STD_INPUT_PULLUP	   0x0c03
#define GPIO_MODE_MGMT_STD_OUTPUT	   0x1809

#define GPIO_MODE_USER_STD_INPUT_NOPULL	   0x0402
#define GPIO_MODE_USER_STD_INPUT_PULLDOWN  0x0802
#define GPIO_MODE_USER_STD_INPUT_PULLUP	   0x0c02
#define GPIO_MODE_USER_STD_OUTPUT	   0x1808

// --------------------------------------------------------
#endif
