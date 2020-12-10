Memory Mapped I/O summary
=========================

.. list-table:: Memory mapped I/O summary by address
    :name: memory_mapped_io_summary_by_address
    :header-rows: 1
    :widths: auto

    * - Address (bytes)
      - Function
    * - ``0x00 00 00 00``
      - Flash SPI/overlaid SRAM (4k words) start of memory block
    * - ``0x00 00 3f ff``
      - End of SRAM
    * - ``0x10 00 00 00``
      - Flash SPI start of program block.
        Program to run starts here on reset.
        Check :ref:`initial_spi_instruction_sequence`.
    * - ``0x10 ff ff ff``
      - Maximum SPI flash addressable space (16MB) with QSPI 3-byte addressing
    * - ``0x1f ff ff ff``
      - Maximum SPI flash addressable space (32MB)
    * - ``0x20 00 00 00``
      - :ref:`reg_uart_clkdiv`
    * - ``0x20 00 00 04``
      - :ref:`reg_uart_data`
    * - ``0x20 00 00 08``
      - :ref:`reg_uart_enable`
    * - ``0x21 00 00 00``
      - :ref:`reg_gpio_data`
    * - ``0x21 00 00 04``
      - :ref:`reg_gpio_ena`
    * - ``0x21 00 00 08``
      - :ref:`reg_gpio_pu`
    * - ``0x21 00 00 0c``
      - :ref:`reg_gpio_pd`
    * - ``0x22 00 00 00``
      - :ref:`reg_timer0_config`
    * - ``0x22 00 00 04``
      - :ref:`reg_timer0_value`
    * - ``0x22 00 00 08``
      - :ref:`reg_timer0_data` (timer 0 reset value)
    * - ``0x23 00 00 00``
      - :ref:`reg_timer1_config`
    * - ``0x23 00 00 04``
      - :ref:`reg_timer1_value`
    * - ``0x23 00 00 08``
      - :ref:`reg_timer1_data` (timer 1 reset value)
    * - ``0x24 00 00 00``
      - :ref:`reg_spi_config`
    * - ``0x24 00 00 08``
      - :ref:`reg_spi_data`
    * - ``0x25 00 00 00``
      - Logic Analyzer Data 0
    * - ``0x25 00 00 04``
      - Logic Analyzer Data 1
    * - ``0x25 00 00 08``
      - Logic Analyzer Data 2
    * - ``0x25 00 00 0c``
      - Logic Analyzer Data 3
    * - ``0x25 00 00 10``
      - Logic Analyzer Enable 0
    * - ``0x25 00 00 14``
      - Logic Analyzer Enable 1
    * - ``0x25 00 00 18``
      - Logic Analyzer Enable 2
    * - ``0x25 00 00 1c``
      - Logic Analyzer Enable 3
    * - ``0x26 00 00 00``
      - User project area GPIO data (L)
    * - ``0x26 00 00 04``
      - User project area GPIO data (H)
    * - ``0x26 00 00 08``
      - User project area GPIO data transfer (bit 0, auto-zeroing)
    * - ``0x26 00 00 0c``
      - User project area GPIO ``mprj_io[0]`` configure
    * - ...
      - ...
    * - ``0x26 00 00 a0``
      - User project area GPIO ``mprj_io[37]`` configure
    * - ``0x26 00 00 a4``
      - User project area GPIO power[0] configure (currently undefined/unused)
    * - ...
      - ...
    * - ``0x26 00 00 b4``
      - User project area GPIO power[3] configure (currently undefined/unused)
    * - ``0x2d 00 00 00``
      - :ref:`reg_spictrl`
    * - ``0x2f 00 00 00``
      - :ref:`reg_pll_out_dest`
    * - ``0x2f 00 00 04``
      - :ref:`reg_trap_out_dest`
    * - ``0x2f 00 00 08``
      - :ref:`reg_irq7_source`
    * - ``0x30 00 00 0``
      - User area base.
        A user project may define additional Wishbone slave modules starting at this address.
    * - ``0x80 00 00 00``
      - QSPI controller
    * - ``0x90 00 00 00``
      - :ref:`storage-area-sram`
    * - ``0xa0 00 00 00``
      - Any slave 1
    * - ``0xb0 00 00 00``
      - Any slave 2
