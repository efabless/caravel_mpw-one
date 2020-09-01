# CIIC Harness (Phase 1)

A template SoC for Google SKY130 free shuttles. It is still WIP. The current SoC architecture is given below.

<p align=”center”>
<img src="/doc/ciic_harness.png" width="75%" height="75%"> 
</p>

## Managment SoC
The managment SoC runs firmware taht can be used to:
- Configure Mega Project I/O pads
- Observe and control Mega Project signals (through on-chip logic analyzer probes)
- Control the Mega Project power supply

The memory map of the management SoC is given below <br>
<img src="/doc/mgmt_soc_memory_map.png" width="40%" height="40%">

## Mega Project Area
This is the user space. It has limitted silicon area (???) as well as a fixed number of I/O pads (???).
The repoo contains a [sample mega project](/verilog/rtl/mprj_counter.v) that contains a binary 32-bit up counter.  </br>

<p align=”center”>
<img src="/doc/counter_32.png" width="50%" height="50%">
</p>

The firmware running on the Management Area SoC, configures the I/O pads used by the counter and uses the logic probes to observe/control the counter. Three firmware examples are provided:
1. Configure the Mega Project I/O pads as o/p. Observe the counter value in the testbench: [IO_Ports Test](verilog/dv/harness/mprj_counter/io_ports).
2. Configure the Mega Project I/O pads as o/p. Use the Chip LA to load the counter and observe the o/p till it reaches 500: [LA_Test1](verilog/dv/harness/mprj_counter/la_test1).
3. Configure the Mega Project I/O pads as o/p. Use the Chip LA to control the clock source and reset signals and observe the counter value for five clock cylcles:  [LA_Test2](verilog/dv/harness/mprj_counter/la_test2).
