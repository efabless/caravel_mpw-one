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

.. _reg_gpio_data:

``reg_gpio_data``
-----------------

TODO

.. _reg_gpio_ena:

``reg_gpio_ena``
----------------

TODO

.. _reg_gpio_pu:

``reg_gpio_pu``
---------------

.. _reg_gpio_pd:

``reg_gpio_pd``
---------------

.. _reg_pll_out_dest:

``reg_pll_out_dest``
--------------------

.. _reg_trap_out_dest:

``reg_trap_out_dest``
---------------------

.. _reg_irq7_source:

``reg_irq7_source``
-------------------

