QSPI Flash interface
====================


The QSPI flash controller is automatically enabled on power-up, and will immediately initiate a read sequence in single-bit mode with pin "flash io0" acting as ``SDI`` (data from flash to CPU) and pin "flash io1" acting as ``SDO`` (data from CPU to flash).
Protocol is to, e.g., Cypress S25FL256L.

The initial SPI instruction sequence is described in :ref:`initial_spi_instruction_sequence`.

.. list-table:: Initial SPI instruction sequence
    :name: initial_spi_instruction_sequence
    :widths: auto

    * - ``0xFF``
      - Mode bit reset
    * - ``0xAB``
      - Release from deep power-down
    * - ``0x03``
      - Read w/3 byte address
    * - ``0x00``
      - Program start address (``0x10000000``)
    * - ``0x00``
      -
    * - ``0x00``
      -

The QSPI flash continues to read bytes, either sequentially on the same command, or issuing a new read command to read from a new address.

.. _reg_spictrl:

QSPI control register
---------------------

The behaviour of the QSPI flash controller can be modified by changing values in the register below:

.. wavedrom::

     { "reg": [
         {"name": "FLASH_IO[3:0]", "bits": 4},
         {"name": "FLASH_CLK", "bits": 1},
         {"name": "FLASH_CSB", "bits": 1},
         {"bits": 2, "type": 1},
         {"name": "OE_FLASH_IO[3:0]", "bits": 4},
         {"bits": 4, "type": 1},
         {"name": "Dummy clock cycle count", "bits": 4},
         {"name": "Access mode", "bits": 3},
         {"bits": 8, "type": 1},
         {"name": "QSPI enable", "bits": 1}],
       "config": {"bits": 32, "hspace": "width", "lanes": 2, "fontsize": 8}
     }

.. list-table:: ``reg_spictrl`` register description
    :name: reg_spictrl_description
    :header-rows: 1
    :widths: auto

    * - Mask bit
      - Default
      - Description
    * - 31
      - 1
      - QSPI flash interface enable
    * - 22-20
      - 0
      - Access mode (see :ref:`reg_spictrl_access_mode_values`)
    * - 19-16
      - 8
      - Dummy clock cycle count
    * - 11-8
      - 0
      - Bit-bang ``OE_FLASH_IO[3:0]``
    * - 5
      - 0
      - Bit-bang ``FLASH_CSB``
    * - 4
      - 0
      - Bit-bang ``FLASH_CLK``
    * - 3-0
      - 0
      - Bit-bang ``FLASH_IO[3:0]``

QSPI access modes
-----------------

.. list-table:: ``reg_spictrl`` Access mode bit values
    :name: reg_spictrl_access_mode_values
    :widths: auto

    * - 0
      - ``000``
      - Single bit per clock
    * - 1
      - ``001``
      - Single bit per clock (same as 0)

All additional modes (QSPI dual and quad modes) cannot be used, as the management SoC only has pins for data lines 0 and 1.

The SPI flash can be accessed by bit banging when the enable is off.
To do this from the CPU, the entire routine to access the SPI flash must be read into SRAM and executed from the SRAM.
