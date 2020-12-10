SRAM
====

Management area SRAM
--------------------

The Caravel chip has an on-board memory of 256 words of width 32 bits.
The memory is located at address ``0``.
There are additional blocks of memory above this area, size and location TDB.

Storage area SRAM
-----------------

The Caravel chip has a "storage area" SRAM block that is auxiliary space that can be used by either the management SoC or the user project, through the Wishbone bus interface.
The storage area is connected into the user area 2 power supply, and so is nominally considered to be part of the user area.

The storage area may be used as an experimentation area for OpenRAM, so for any user project making use of this space, the user should notify efabless of their requirement for the size and configuration of the SRAM block.
