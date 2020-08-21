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

// IOs: UART (0x2000_0000), GPIO (0x2100_0000), LA (0x2200_0000)
#define reg_uart_clkdiv (*(volatile uint32_t*)0x20000000)
#define reg_uart_data   (*(volatile uint32_t*)0x20000004)

#define reg_gpio_data (*(volatile uint32_t*)0x21000000)
#define reg_gpio_ena  (*(volatile uint32_t*)0x21000004)
#define reg_gpio_pu   (*(volatile uint32_t*)0x21000008)
#define reg_gpio_pd   (*(volatile uint32_t*)0x2100000c)

#define reg_la0_data (*(volatile uint32_t*)0x22000000)
#define reg_la1_data (*(volatile uint32_t*)0x22000004)
#define reg_la2_data (*(volatile uint32_t*)0x22000008)
#define reg_la3_data (*(volatile uint32_t*)0x2200000c)

#define reg_la0_ena (*(volatile uint32_t*)0x22000010)
#define reg_la1_ena (*(volatile uint32_t*)0x22000014)
#define reg_la2_ena (*(volatile uint32_t*)0x22000018)
#define reg_la3_ena (*(volatile uint32_t*)0x2200001c)

// Flash Control SPI Configuration (2D00_0000)
#define reg_spictrl (*(volatile uint32_t*)0x2D000000)         

// House-Keeping SPI Read-Only Registers (0x2E00_0000)
#define reg_spi_config     (*(volatile uint32_t*)0x2E000000)
#define reg_spi_enables    (*(volatile uint32_t*)0x2E000004)
#define reg_spi_pll_config (*(volatile uint32_t*)0x2E000008)
#define reg_spi_mfgr_id    (*(volatile uint32_t*)0x2E00000c)
#define reg_spi_prod_id    (*(volatile uint32_t*)0x2E000010)
#define reg_spi_mask_rev   (*(volatile uint32_t*)0x2E000014)
#define reg_spi_pll_bypass (*(volatile uint32_t*)0x2E000018)

// System Area (0x2F00_0000)
#define reg_rcosc_enable   (*(volatile uint32_t*)0x2F000000)
#define reg_rcosc_out_dest (*(volatile uint32_t*)0x2F000004)

#define reg_xtal_out_dest (*(volatile uint32_t*)0x2F000008)
#define reg_pll_out_dest  (*(volatile uint32_t*)0x2F00000c)
#define reg_trap_out_dest (*(volatile uint32_t*)0x2F000010)

#define reg_irq7_source (*(volatile uint32_t*)0x2F000014)
#define reg_irq8_source (*(volatile uint32_t*)0x2F000018)

#define reg_overtemp_ena      (*(volatile uint32_t*)0x2F00001c)
#define reg_overtemp_data     (*(volatile uint32_t*)0x2F000020)
#define reg_overtemp_out_dest (*(volatile uint32_t*)0x2F000024)

// Crosbbar Slave Addresses (0x8000_0000 - 0xB000_0000)
#define qspi_ctrl_slave    (*(volatile uint32_t*)0x80000000)
#define storage_area_slave (*(volatile uint32_t*)0x90000000)
#define mega_any_slave1    (*(volatile uint32_t*)0xA0000000)
#define mega_any_slave2    (*(volatile uint32_t*)0xB0000000)

// #define reg_adc0_ena (*(volatile uint32_t*)0x21000010)
// #define reg_adc0_data (*(volatile uint32_t*)0x21000014)
// #define reg_adc0_done (*(volatile uint32_t*)0x21000018)
// #define reg_adc0_convert (*(volatile uint32_t*)0x2100001c)
// #define reg_adc0_clk_source (*(volatile uint32_t*)0x21000020)
// #define reg_adc0_input_source (*(volatile uint32_t*)0x21000024)

// #define reg_adc1_ena (*(volatile uint32_t*)0x21000030)
// #define reg_adc1_data (*(volatile uint32_t*)0x21000034)
// #define reg_adc1_done (*(volatile uint32_t*)0x21000038)
// #define reg_adc1_convert (*(volatile uint32_t*)0x2100003c)
// #define reg_adc1_clk_source (*(volatile uint32_t*)0x21000040)
// #define reg_adc1_input_source (*(volatile uint32_t*)0x21000044)

// #define reg_dac_ena (*(volatile uint32_t*)0x21000050)
// #define reg_dac_data (*(volatile uint32_t*)0x21000054)

// #define reg_comp_enable (*(volatile uint32_t*)0x21000060)
// #define reg_comp_n_source (*(volatile uint32_t*)0x21000064)
// #define reg_comp_p_source (*(volatile uint32_t*)0x21000068)
// #define reg_comp_out_dest (*(volatile uint32_t*)0x2100006c)

// #define reg_analog_out_sel (*(volatile uint32_t*)0x210000c0)
// #define reg_analog_out_bias_ena (*(volatile uint32_t*)0x210000c4)
// #define reg_analog_out_ena (*(volatile uint32_t*)0x210000c8)

// #define reg_bandgap_ena (*(volatile uint32_t*)0x210000d0)

// --------------------------------------------------------
#endif
