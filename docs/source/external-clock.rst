External clock
==============

The external clock is provided to :ref:`clock <clock>` pin (C9).

The external clock functions as the source clock for the entire processor.
On startup, the processor runs at the same rate as the external clock.
The processor program may access the :doc:`housekeeping-spi` to set the processor into PLL mode or DCO free-running mode.
In PLL mode, the external clock is multiplied by the feedback divider value to obtain the core clock.
In DCO mode, the processor is driven by a trimmed free-running ring oscillator.
