.. raw:: html

   <!---
   # SPDX-FileCopyrightText: 2020 Efabless Corporation
   #
   # Licensed under the Apache License, Version 2.0 (the "License");
   # you may not use this file except in compliance with the License.
   # You may obtain a copy of the License at
   #
   #      http://www.apache.org/licenses/LICENSE-2.0
   #
   # Unless required by applicable law or agreed to in writing, software
   # distributed under the License is distributed on an "AS IS" BASIS,
   # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   # See the License for the specific language governing permissions and
   # limitations under the License.
   #
   # SPDX-License-Identifier: Apache-2.0
   -->

.. _carave-with-openlane:

Using OpenLANE to Harden Your Design
====================================

You can utilize the Makefile existing here in this directory to do that.

But, first you need to specify 2 things:

.. code:: bash

    export PDK_ROOT=<The location where the pdk is installed>
    export OPENLANE_ROOT=<the absolute path to the openlane directory cloned or to be cloned>

If you don't have openlane already, then you can get it from
`here <https://github.com/efabless/openlane>`__. Alternatively, you can
clone and build openlane through:

.. code:: bash

        make openlane

.. note::

      We are developing caravel using efabless/openlane:rc7.

.. note::

      rc7 (current openlane master) and rc4 (previous openlane
      master) are using two different concepts of cell padding. rc4 is
      modifying the LEF, while rc7 is relying on openroad to handle the cell
      padding. Also, rc4 is using the standalone version of openDP while rc7
      is using the one integrated in the openroad app. This affects the
      concept of PL\_TARGET\_DENSITY and while in rc4 it was preferred to have
      PL\_TARGET\_DENSITY=(FP\_CORE\_UTIL-(5\~10)/100). Now, in rc7 it is
      preferred to be PL\_TARGET\_DENSITY=(FP\_CORE\_UTIL+(1\~5)/100).
      | FP\_CORE\_UTIL should be relaxed as well as it became more
      representative of the actual core utilization, which wasn't so much the
      case earlier. So, the perception of these two variables as well as
      CELL\_PAD changed between rc4 and rc7 which necessitates a change in the
      configurations of almost every single design.
      | CELL\_PAD should be 4\~6 for the skywater libraries in rc7 unlike rc4
      which was 8.

Then, you have two options:

#. Create a macro for your design and harden it, then insert it into
   user\_project\_wrapper.

#. Flatten your design with the user\_project\_wrapper and harden them
   as one.

.. note::

      The OpenLANE documentation should cover everything you might
      need to create your design. You can find that
      `here <https://openlane.readthedocs.io/en/latest/>`__.

Option 1
--------

This could be done by creating a directory for your design here in this
directory, and adding a configuration file for it under the same
directory. You can follow the instructions given
`here <https://openlane.readthedocs.io/en/latest/#adding-a-design>`__ to
generate an initial configuration file for your design, or you can start
with the following:

.. code:: tcl

    set script_dir [file dirname [file normalize [info script]]]

    set ::env(DESIGN_NAME) <Your Design Name>

    set ::env(DESIGN_IS_CORE) 0
    set ::env(FP_PDN_CORE_RING) 0
    set ::env(GLB_RT_MAXLAYER) 5

    set ::env(VERILOG_FILES) "$script_dir/../../verilog/rtl/<Your RTL.v>"

    set ::env(CLOCK_PORT) <Clock port name if it exists>
    set ::env(CLOCK_PERIOD) <Desired clock period>

Then you can add them as you see fit to get the desired DRC/LVS clean
outcome.

After that, run the following command:

.. code:: bash

    make <your design directory name>

Then, follow the instructions given in Option 2.

.. note::

      You might have other macros inside your design. In which case,
      you may need to have some special power configurations. This is covered
      `here <https://openlane.readthedocs.io/en/latest/docs/source/hardening_macros.html#power-grid-pdn>`__.

Option 2
--------

#. Add your design to the RTL of the
   `user\_project\_wrapper <https://github.com/efabless/caravel/blob/master/verilog/rtl/user_project_wrapper.v>`__.

#. Modify the configuration file `here <https://github.com/efabless/caravel/blob/master/openlane/user_project_wrapper/config.tcl>`__ to include any extra
   files you may need. Make sure to change these accordingly:

   .. code:: tcl

      set ::env(CLOCK_NET) "mprj.clk"
      set ::env(VERILOG_FILES) " \
            $script_dir/../../verilog/rtl/defines.v \
            $script_dir/../../verilog/rtl/user_project_wrapper.v"

      set ::env(VERILOG_FILES_BLACKBOX) " \
            $script_dir/../../verilog/rtl/defines.v \
            $script_dir/../../verilog/rtl/user_proj_example.v"

      set ::env(EXTRA_LEFS) " \
         $script_dir/../../lef/user_proj_example.lef"

      set ::env(EXTRA_GDS_FILES) " \
         $script_dir/../../gds/user_proj_example.gds"


#. If your design has standard cells then you need to modify the
   configuration file `here <https://github.com/efabless/caravel/blob/master/openlane/user_project_wrapper/config.tcl>`__ to
   remove or change these configs accordingly:

   .. code:: tcl

       # The following is because there are no std cells in the example wrapper project.
       set ::env(SYNTH_TOP_LEVEL) 1
       set ::env(PL_RANDOM_GLB_PLACEMENT) 1
       set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0
       set ::env(DIODE_INSERTION_STRATEGY) 0
       set ::env(FILL_INSERTION) 0
       set ::env(TAP_DECAP_INSERTION) 0
       set ::env(CLOCK_TREE_SYNTH) 0

#. Remove this line
   ``set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg`` from the
   configuration file `here <https://github.com/efabless/caravel/blob/master/openlane/user_project_wrapper/config.tcl>`__
   entirely if you have no macros. Alternatively, if you do have macros
   inside your design, then control their placement by modifying `this
   file <https://github.com/efabless/caravel/blob/master/openlane/user_project_wrapper/macro.cfg>`__

#. Run your design through the flow: ``make user_project_wrapper``

#. You may want to take a look at the `Extra
   Pointers <#extra-pointers>`__ to apply any necessary changes to the
   interactive script.

#. Re-iterate until you have what you want.

#. Go back to the main :ref:`getting-started` and continue the
   process of boarding the chip.

.. note::

    In both cases you might have other macros inside your design.
    In which case, you may need to have some special power configurations.
    This is covered `here <https://openlane.readthedocs.io/en/latest/docs/source/hardening_macros.html#power-grid-pdn>`__.

.. warning::

    Don't change the size or the pin order!


Extra Pointers
--------------

-  The OpenLANE documentation should cover everything you might need to
   create your design. You can find that
   `here <https://openlane.readthedocs.io/en/latest/>`__.
-  The OpenLANE `FAQs <https://github.com/efabless/openlane/wiki>`__ can
   guide through your troubles.
-  `Here <https://openlane.readthedocs.io/en/latest/configuration/README.html>`__
   you can find all the configurations and how to use them.
-  `Here <https://openlane.readthedocs.io/en/latest/docs/source/advanced_readme.html>`__
   you can learn how to write an interactive script.
-  `Here <https://openlane.readthedocs.io/en/latest/docs/source/OpenLANE_commands.html>`__
   you can find a full documentation for all OpenLANE commands.
-  `This
   documentation <https://openlane.readthedocs.io/en/latest/regression_results/README.html>`__
   describes how to use the exploration script to achieve an LVS/DRC
   clean design.
-  `This
   documentation <https://openlane.readthedocs.io/en/latest/docs/source/hardening_macros.html>`__
   walks you through hardening a macro and all the decisions you should
   make.

