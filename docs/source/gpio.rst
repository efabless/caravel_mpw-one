General Purpose Input/Output
============================

The GPIO pin is a single assignable general-purpose digital input or output that is available only to the management SoC and cannot be assigned to the user project area.
On the test board provided with the completed user projects, this pin is used to enable the voltage regulators generating the user area power supplies.

The basic function of the GPIO is illustrated in :ref:`gpio_structure`.
All writes to :ref:`reg_gpio_data` are registered.
All reads from :ref:`reg_gpio_data` are immediate.

.. figure:: _static/gpio.svg
    :name: gpio_structure
    :alt: GPIO channel structure
    :align: center

    GPIO channel structure

Register descriptions
~~~~~~~~~~~~~~~~~~~~~

.. list-table:: GPIO memory address map
    :name: gpio_memory_address_map
    :header-rows: 1

    * - C header name
      - Address
      - Description
    * - :ref:`reg_gpio_data`
      - ``0x21000000``
      - GPIO input/output (low bit)

        GPIO output readback (16th bit)
    * - :ref:`reg_gpio_ena`
      - ``0x21000004``
      - GPIO output enable (`0 = output`, `1 = input`)
    * - :ref:`reg_gpio_pu`
      - ``0x21000008``
      - GPIO pullup enable (`0 = none`, `1 = pullup`)
    * - :ref:`reg_gpio_pd`
      - ``0x2100000c``
      - GPIO pulldown enable (`0 = none`, `1 = pulldown`)
    * - :ref:`reg_pll_out_dest`
      - ``0x2f000000``
      - PLL clock output destination (low bit)
    * - :ref:`reg_trap_out_dest`
      - ``0x2f000004``
      - Trap output destination (low bit)
    * - :ref:`reg_irq7_source`
      - ``0x2f000008``
      - IRQ 7 input source (low bit)

.. note::
    
    In the registers description below, each register is shown as 32 bits corresponding
    to the data bus width of the wishbone bus. Depending on the instruction and data type,
    the entire 32-bit register can be read in one instruction, or one 16-bit word,
    or one 8-bit byte.

.. _reg_gpio_data:

``reg_gpio_data``
-----------------

Base address: ``0x21000000``

.. wavedrom::

     { "reg": [
         {"name": "GPIO input/output", "bits": 16},
         {"name": "GPIO output readback", "bits": 16}],
     }

|

* Writing to the address low bit always sets the registered value at the GPIO.
* Writing to address bit 16 has no effect.
* Reading from the address low bit reads the value at the chip pin.
* Reading from address bit 16 reads the value at the multiplexer output (see :ref:`gpio_structure`).

.. _reg_gpio_ena:

``reg_gpio_ena``
----------------

Base address: ``0x21000004``

.. wavedrom::

     { "reg": [
         {"name": "GPIO output enable", "bits": 16},
         {"name": "(undefined, reads zero)", "bits": 16, "type": 1}],
     }

|

* Bit 0 corresponds to the GPIO channel enable.
* Bit value 1 indicates an output channel; 0 indicates an input.

.. _reg_gpio_pu:

``reg_gpio_pu``
---------------

Base address: ``0x21000008``

.. wavedrom::

     { "reg": [
         {"name": "GPIO pin pull-up", "bits": 16},
         {"name": "(undefined, reads zero)", "bits": 16, "type": 1}],
     }

|

* Bit 0 corresponds to the GPIO channel pull-up state.
* Bit value 1 indicates pullup is active; 0 indicates pullup is inactive.

.. _reg_gpio_pd:

``reg_gpio_pd``
---------------

Base address: ``0x2100000c``

.. wavedrom::

     { "reg": [
         {"name": "GPIO pin pull-down (inverted)", "bits": 16},
         {"name": "(undefined, reads zero)", "bits": 16, "type": 1}],
     }

|

.. attention::

    The statement below (second sentence) seems to be invalid.

* Bit 0 corresponds to the GPIO channel pull-down state.
* Bit value 1 indicates pullup is active; 0 indicates pulldown is inactive.

.. _reg_pll_out_dest:

``reg_pll_out_dest``
--------------------

Base address: ``0x2f000000``

.. wavedrom::

     { "reg": [
         {"name": "PLL clock dest.", "bits": 8},
         {"name": "(undefined, reads zero)", "bits": 24, "type": 1}],
     }

|

The PLL clock (crystal oscillator clock multiplied up by PLL) can be viewed on the GPIO pin.
The GPIO pin cannot be used as general-purpose I/O when selected for PLL clock output.

The low bit of this register directs the output of the core clock to the GPIO channel, according to the :ref:`reg_pll_out_dest_table`.

.. list-table:: ``reg_pll_out_dest`` register settings
    :name: reg_pll_out_dest_table
    :header-rows: 1

    * - ``0x2f000000`` value
      - Clock output directed to this channel
    * - ``0``
      - (none)
    * - ``1``
      - Core PLL clock to GPIO output

.. note::
    
    High rate core clock (e.g. 80MHz) may be unable to generate a full swing on the GPIO output, but is detectable.

.. _reg_trap_out_dest:

``reg_trap_out_dest``
---------------------

Base address: ``0x2f000004``

.. wavedrom::

     { "reg": [
         {"name": "trap signal dest.", "bits": 8},
         {"name": "(undefined, reads zero)", "bits": 24, "type": 1}],
     }

|

The CPU fault state (trap) can be viewed at the GPIO pin as a way to monitor the CPU trap state externally.
The low bit of this register directs the output of the processor trap signal to the GPIO channel, according to the :ref:`reg_trap_out_dest_table`.


.. list-table:: ``reg_trap_out_dest`` register settings
    :name: reg_trap_out_dest_table
    :header-rows: 1

    * - ``0x2f000004`` value
      - Trap signal output directed to this channel
    * - ``0``
      - (none)
    * - ``1``
      - GPIO

.. _reg_irq7_source:

``reg_irq7_source``
-------------------

Base address: ``0x2f000008``

.. wavedrom::

     { "reg": [
         {"name": "IRQ 7 source", "bits": 8},
         {"name": "(undefined, reads zero)", "bits": 24, "type": 1}],
     }

|

The GPIO input can be used as an IRQ event source and passed to the CPU through IRQ channel 7 (see :doc:`irq`).
When used as an IRQ source, the GPIO pin must be configured as an input.
The low bit of this register directs the input of the GPIO to the processor's IRQ7 channel, according to the :ref:`reg_irq7_source_table`.


.. list-table:: ``reg_irq7_source`` register settings
    :name: reg_irq7_source_table
    :header-rows: 1

    * - Register byte
      - ``0x2f000008`` value
      - This channel directed to IRQ channel 7
    * - 0
      - ``00``
      - (none)
    * - 1
      - ``01``
      - GPIO
