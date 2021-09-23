# IRSIM simulation for mgmt_soc
# Simulates the caravel mgmt_soc core while emulating the SPI flash
# Other blocks are ignored.
# This is mainly to see if IRSIM will catch hold timing violations on the
# generation of the first address passed to the SPI flash.

l VGND
h VPWR
settle 4

analyzer

vector mgmt_in_data mgmt_in_data\[37:0\]
vector mgmt_out_data mgmt_out_data\[37:0\]

ana clock gpio_out_pad gpio_in_pad resetb porb flash_io0_do flash_io1_di flash_clk flash_csb trap

l clock
l resetb
l porb

l gpio_in_pad

setvector mgmt_in_data 0d0

l flash_io0_di
l flash_io1_di
l flash_io2_di
l flash_io3_di

s 200

#-------------------------------------
# SPI flash emulation
#-------------------------------------

set flash_cmd_count 8
set flash_cmd 0
set flash_addr_count 24
set flash_addr 0
set flash_data_count 8
set flash_data_in 0
set flash_data_out 0

whenever flash_csb l {
    set flash_cmd_count 0
    set flash_cmd 0
}

whenever flash_clk hl {
    if {[query flash_clk] == 1} {
	# On flash_clk rising edge:
	if {$flash_cmd_count < 8} {
	    incr flash_cmd_count
	    set flash_cmd [expr {$flash_cmd << 1 | [query flash_io0_do]}]
	    if {$flash_cmd_count == 8} {
		if {$flash_cmd == 0x03} {
		    set flash_addr_count 0
		    set flash_addr 0
		}
	    }
	} elseif {$flash_addr_count < 24} {
	    incr flash_addr_count
	    set flash_addr [expr {$flash_addr << 1 | [query flash_io0_do]}]
	    if {$flash_addr_count == 24} {
		set flash_data_count 0
		set flash_addr [expr {$flash_addr - 0x100000}]
		set flash_data_out [lindex $flash_contents $flash_addr]
		puts stdout "Flash SPI Addr = $flash_addr Data = $flash_data_out"
	    }
	} else {
	    incr flash_data_count
	    set flash_data_in [expr {$flash_data_in << 1 | [query flash_io0_do]}]
	    if {$flash_data_count == 8} {
		set flash_data_count 0
		incr flash_addr
	    }
	}
    } else {
	# On flash_clk falling edge:
	if {$flash_cmd_count == 8 && $flash_addr_count == 24} {
	    if {$flash_data_count == 0} {
		set flash_data_out [lindex $flash_contents $flash_addr]
		puts stdout "Flash SPI Addr = $flash_addr Data = $flash_data_out"
	    }
	    if {[expr {$flash_data_out & 0x80}] != 0} {
		h flash_io1_di
	    } else {
		l flash_io1_di
	    }
	    set flash_data_out [expr {$flash_data_out << 1}]
	} else {
	    l flash_io1_di
	}
    }
}

# Load the hex file

set hf [open /home/tim/gits/caravel/verilog/dv/caravel/mgmt_soc/gpio_mgmt/gpio_mgmt.hex r]
# Throw away first line
gets $hf line
set flash_contents {}
while {[gets $hf line] >= 0} {
    for {set i 0} {$i < 16} {incr i} {
	catch {lappend flash_contents [expr 0x[lindex $line $i]]}
    }
}
close $hf

# Input clock emulation

set core_freq 10.0	;# in MHz

set core_period [expr 1.0 / ($core_freq * 1.0E6)]
set half_period_ns [expr 1.0E9 * $core_period / 2.0]

every $half_period_ns {
    if {[query clock] == 0} {
        printp 10
    }
    toggle clock
}

# Raise power-on-reset (bar), then reset (bar).
s 200
h porb
s 200
h resetb

s 1000

# Continue simulation manually from the command line, e.g.,
# run "s 50000"
#
# Run "histflush" after every 50k steps or the computer will run out of
# memory.
