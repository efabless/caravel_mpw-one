Introduction
============

The efabless Caravel chip is a ready-to-use test harness for creating designs with the Google/Skywater 130nm Open PDK.
The Caravel harness comprises a small RISC-V microprocessor based on the simple 2-cycle PicoRV32 RISC-V core implementing the RV32IMC instruction set (see `riscv.org page <http://riscv.org>`_), a 32-bit wishbone bus, and an approximately 2.8mm x 2.8mm open area for the placement of user IP blocks.

The documentation contains the following chapters:

* :doc:`description` contains the general information about the Efabless Caravel "harness" SoC,
* :doc:`pinout` describes the pinout of the SoC,
* :doc:`gpio` describes GPIO and its registers,
* :doc:`housekeeping-spi` describes the SPI slave that can be accessed from a remote host,
* :doc:`qspi-flash` describes the QSPI flash controller,
* :doc:`external-clock` describes  the source external clock for the CPU,
* :doc:`uart` describes the UART interface,
* :doc:`spi` describes the SPI configuration,
* :doc:`counter-timers` describes two counter/timers blocks,
* :doc:`irq` describes the interrups,
* :doc:`quick-start` contains the minimal set of actions to get going with the project.
