# IRSIM simulation for gpio_control_block
# This is a simple/quick test to make sure IRSIM runs correctly on the
# sky130A technology.

# l vssd
l vssd1
# h vccd
h vccd1
settle 4

analyzer

ana serial_clock resetn serial_data_in serial_data_out

l serial_clock
l resetn

l serial_data_in
l user_gpio_in
l user_gpio_in
l mgmt_gpio_in


s 20

# Input clock emulation

set core_freq 5.0	;# in MHz, half the rate of the SoC core clock

set core_period [expr 1.0 / ($core_freq * 1.0E6)]
set half_period_ns [expr 1.0E9 * $core_period / 2.0]

every $half_period_ns {
    if {[query serial_clock] == 0} {
        printp 10
    }
    toggle serial_clock
}

s 20
h resetn
s 20

s 500

# Continue simulation manually from the command line, e.g.,
# run "s 50000"
#
# Run "histflush" after every 50k steps or the computer will run out of
# memory.
