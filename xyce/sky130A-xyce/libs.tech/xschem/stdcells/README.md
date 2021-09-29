# XSCHEM Process agnostic Digital standard cell symbols.

## *Warning: This is currently Work in progress.*

This directory contains symbols to be used in the [XSCHEM](https://github.com/StefanSchippers/xschem)
schematic editor. For a quick XSCHEM introduction see this
[presentation](https://xschem.sourceforge.io/stefan/xschem_man/tutorial_xschem_slides.html).  
These symbols represent a tentative list of digital logic standard cells to be used to build 
digital circuit schematics in XSCHEM.  
The list is based on this 
[document](https://github.com/RTimothyEdwards/open_pdks/blob/master/common/gate_list.txt) by Tim Edwards.  
The symbols have simple names to make their function clear. In order to correctly bind to the 
[Skywater PDK](https://foss-eda-tools.googlesource.com/skywater-pdk/libs/sky130_fd_pr) 
some additional work is needed. This is all **work in progress**.

## GOAL
Provide a set of digital logic gates that can be used with xschem and seamlessly simulated using the 
Skywater 130 PDK as well as other foundry provided gate libraries and SPICE dimulation models. 
Allowing verilog simulation directly from Xschem is another goal.

## SYMBOL DRAWINGS
![list of gates](https://github.com/StefanSchippers/xschem_sky130/blob/main/stdcells/doc/gates.png)

## CURRENT STATUS

The gates can be placed in a XSCHEM schematic and a valid spice netlist is generated for them. However in order to
use the SKY130 PDK circuit description some wrapper must be provided. In their final implementation, these gates
will bind directly to the Skywater 130 PDK models. Currently the cells have 4 
attributes to set supply and ground net names for source and body connections:  

![gate attributes](https://github.com/StefanSchippers/xschem_sky130/blob/main/stdcells/doc/gate_attributes.png)

## GATE FUNCTION DESCRIPTION
```
#-----------------------------------------------------------------------
# List of standard gate symbols with mapping to liberty file fields
#
# Y, X	       refer to logic output pins
# C, S, ...    refer specifically to adder carry and sum output pins
# Q, QB	       refer specifically to flip-flop or latch output pins
# IQ, IQB      refers to function entries for flops.  "I" is literal.
# A, B, C, ... refer to input pins
# D, R, S, ... refer specifically to flip-flop input pins
# SD	       refers to scan data input pin for flip-flops
# CI	       refers specifically to full adder carry-in input
# Z	       refers to high-impedance state
# &	       means AND
# |	       means OR
# !	       means NOT
# ( )	       groups
#
# Symbol    Liberty	Liberty
# primitive file	field
# name	    field	value	    ...
#-----------------------------------------------------------------------
AND2	    function	Y=A&B
AND3	    function	Y=A&B&C
AND4	    function	Y=A&B&C&D
AND5	    function	Y=A&B&C&D&E
AND8	    function	Y=A&B&C&D&E&F&G&H

AND2I	    function	Y=!A&B

AO21	    function	Y=(A&B)|C
AO22	    function	Y=(A&B)|(C&D)

AOI21	    function	Y=!((A&B)|C)
AOI22	    function	Y=!((A&B)|(C&D))

NAND2	    function	Y=!(A&B)
NAND3	    function	Y=!(A&B&C)
NAND4	    function	Y=!(A&B&C&D)
NAND5	    function	Y=!(A&B&C&D&E)
NAND8	    function	Y=!(A&B&C&D&E&F&G&H)

NAND2I	    function	Y=!(!A&B)

OR2	    function	Y=A|B
OR3	    function	Y=A|B|C
OR4	    function	Y=A|B|C|D
OR5	    function	Y=A|B|C|D|E
OR8	    function	Y=A|B|C|D|E|F|G|H

OR2I	    function	Y=!A|B

OA21	    function	Y=(A|B)&C
OA22	    function	Y=(A|B)&(C|D)

OAI21	    function	Y=!((A|B)&C)
OAI22	    function	Y=!((A|B)&(C|D))

NOR2	    function	Y=!(A|B)
NOR3	    function	Y=!(A|B|C)
NOR4	    function	Y=!(A|B|C|D)
NOR5	    function	Y=!(A|B|C|D|E)
NOR8	    function	Y=!(A|B|C|D|E|F|G|H)

NOR2I	    function	Y=!(!A|B)

XOR2	    function	Y=(A&!B)|(!A&B)

XNOR2	    function	Y=(A&B)|(!A&!B)

INV	    function	Y=!A

BUF	    function	Y=A

TBUF	    function	Y=A	three_state	E

TBUFI	    function	Y=A	three_state	!E

MUX2	    function	Y=(A&C)|(B&!C)

MUX2I	    function	Y=!((A&!C)|(B&C))

MUX4	    function	Y=(A&!E&!F)|(B&!E&F)|(C&E&!F)|(D&E&F)

MUX4I	    function	Y=!((A&!E&!F)|(B&!E&F)|(C&E&!F)|(D&E&F))

HA	    function	C=A&B	function    S=(A&!B)|(!A&B)
FA	    function	C=(A&B)|(A&CI)|(B&CI)	function    S=(A&B&CI)|(!A&B&!CI)|(!A&!B&CI)|(A&!B&!CI)

LATCH	    function	Q=IQ	enable  E	data_in  D
LATCHI	    function	Q=IQ	enable  !E	data_in  D
LATCHR	    function	Q=IQ	enable  E	data_in  D	clear !R
LATCHIR	    function	Q=IQ	enable  !E	data_in  D	clear !R
LATCHSR	    function	Q=IQ	enable  E	data_in  D	preset !S   clear !R
LATCHISR    function	Q=IQ	enable  E	data_in  D	preset !S   clear !R

LATCHQ	    function	Q=IQ	QB=IQB	enable  E	data_in  D
LATCHIQ	    function	Q=IQ	QB=IQB	enable  !E	data_in  D
LATCHRQ	    function	Q=IQ	QB=IQB	enable  E	data_in  D	clear !R
LATCHIRQ    function	Q=IQ	QB=IQB	enable  !E	data_in  D	clear !R
LATCHSRQ    function	Q=IQ	QB=IQB	enable  E	data_in  D	preset !S   clear !R
LATCHISRQ   function	Q=IQ	QB=IQB	enable  !E	data_in  D	preset !S   clear !R

DFF	    function	Q=IQ	clocked_on  C	    next_state  D
DFFQ	    function	Q=IQ	function    QB=IQB   clocked_on	C   next_state	D
DFFS	    function	Q=IQ	clocked_on  C	    next_state  D   preset	!S
DFFR	    function	Q=IQ	clocked_on  C	    next_state  D   clear	!R
DFFSR	    function	Q=IQ	clocked_on  C	    next_state	D   preset	!S  clear   !R
DFFSQ	    function	Q=IQ	function    QB=IQB   clocked_on  C   next_state  D   preset  !S
DFFRQ	    function	Q=IQ	function    QB=IQB   clocked_on  C   next_state  D   clear  !R
DFFSRQ	    function	Q=IQ	function    QB=IQB   clocked_on  C   next_state  D   clear  !R	preset !S
DFFI	    function	Q=IQ	clocked_on  !C	    next_state  D
DFFIQ	    function	Q=IQ	function    QB=IQB   clocked_on	!C   next_state	D
DFFIS	    function	Q=IQ	clocked_on  !C	    next_state  D   preset	!S
DFFIR	    function	Q=IQ	clocked_on  !C	    next_state  D   clear	!R
DFFISR	    function	Q=IQ	clocked_on  !C	    next_state	D   preset	!S  clear   !R
DFFISQ	    function	Q=IQ	function    QB=IQB   clocked_on  !C  next_state  D   preset  !S
DFFIRQ	    function	Q=IQ	function    QB=IQB   clocked_on  !C  next_state  D   clear  !R
DFFISRQ	    function	Q=IQ	function    QB=IQB   clocked_on  !C  next_state  D   clear  !R	preset !S

EDFF	    function	Q=IQ	clocked_on  C	    next_state  (D&E)|(IQ&!E)
EDFFQ	    function	Q=IQ	QB=IQB	clocked_on  C	    next_state  (D&E)|(IQ&!E)

SDFF	    function	Q=IQ	clocked_on  C	    next_state  (D&!E)|(SD&E)
SDFFQ	    function	Q=IQ	QB=IQB	clocked_on  C	    next_state  (D&!E)|(SD&E)
```
