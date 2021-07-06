## spice import of a synthetized RTL design into XSCHEM

- copy `decred_controller.spice` and `decred_hash_macro.spice` to `test1.spice` and `test2.spice`
- in test?.spice:
- delete FILLER, ANTENNA  and tapvpwrvgnd cells (delete these lines)
- delete  VGND VGND VPWR VPWR power pins from stdcell instances; xschem propagates power pins on standard cells via attributes.  
  from:  
    `X_1468_ _1428_/Y VGND VGND VPWR VPWR _1548_/D sky130_fd_sc_hd__buf_2`  
  to:  
    `X_1468_ _1428_/Y _1548_/D sky130_fd_sc_hd__buf_2`  
- be careful when doing above since some long netlist lines are folded:  
  ```
  Xclkbuf_1_0_0_addressalyzerBlock.SPI_CLK clkbuf_0_addressalyzerBlock.SPI_CLK/X VGND
  + VGND VPWR VPWR clkbuf_2_1_0_addressalyzerBlock.SPI_CLK/A sky130_fd_sc_hd__clkbuf_1
  ```
- `./make_sch_from_spice.awk user_project_wrapper.spice > log`
- `./make_sch_from_spice.awk test1.spice >log`
- `./make_sch_from_spice.awk test2.spice >log`
- manually fix port directions using info from verilog files
- rename top level nets to more sane names

## Opening the schematic
from `xschem_sky130/` directory:

  `xschem decred_hash_macro/user_project_wrapper.sch`  
    
  Warning: the `decred_hash_macro` is an extremely big schematic, xschem takes some seconds to load it in when descending into it.


![schematic](https://github.com/StefanSchippers/xschem_sky130/blob/main/decred_hash_macro/decred_hash_macro.png)
  
![schematic2](https://github.com/StefanSchippers/xschem_sky130/blob/main/decred_hash_macro/decred_hash_macro_2.png)

