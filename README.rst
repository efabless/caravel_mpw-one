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

Caravel Harness
===============

|License| |Documentation Status| |Build Status|

A template SoC for Google SKY130 free shuttles. It is still WIP. The
current SoC architecture is given below.

.. raw:: html

   <p align="center">
   <img src="/docs/source/_static/caravel_harness.png" width="75%" height="75%">
   </p>

Datasheet and detailed documentation exists `here <https://caravel-harness.readthedocs.io/>`__

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
.. _getting-started:

Getting Started
===============

-  For information on tooling and versioning, please refer to `tool-versioning.rst <./docs/source/tool-versioning.rst>`__.

Start by cloning the repo and uncompressing the files.

.. code:: bash

    git clone https://github.com/efabless/caravel.git
    cd caravel
    make uncompress

Then you need to install the open\_pdks prerequisite:

-  `Magic VLSI Layout
   Tool <http://opencircuitdesign.com/magic/index.html>`__ is needed to
   run open\_pdks -- version >= 8.3.60\*

   **NOTE:**

      You can avoid the need for the magic prerequisite by using
      the openlane docker to do the installation step in open\_pdks. This
      could be done by cloning
      `openlane <https://github.com/efabless/openlane/tree/master>`__ and
      following the instructions given there to use the Makefile.

Install the required version of the PDK by running the following
commands:

.. code:: bash

    export PDK_ROOT=<The place where you want to install the pdk>
    make pdk

Then, you can learn more about the caravel chip by watching these video:

-  Caravel User Project Features -- https://youtu.be/zJhnmilXGPo
-  Aboard Caravel -- How to put your design on Caravel? --
   https://youtu.be/9QV8SDelURk
-  Things to Clarify About Caravel -- What versions to use with Caravel?
   -- https://youtu.be/-LZ522mxXMw

   -  You could only use efabless/openlane:rc7
   -  Make sure you have the commit hashes provided here inside the
      `Makefile <https://github.com/efabless/caravel/blob/master/Makefile>`__

Aboard Caravel
--------------

Your area is the full user\_project\_wrapper, so feel free to add your
project there or create a differnt macro and harden it seperately then
insert it into the user\_project\_wrapper. For example, if your design
is analog or you're using a different tool other than OpenLANE.

If you will use OpenLANE to harden your design, go through the
instructions in this `README <https://github.com/efabless/caravel/blob/master/openlane/README.rst>`__.

You must copy your synthesized gate-level-netlist for
``user_project_wrapper`` to ``verilog/gl/`` and overwrite
``user_project_wrapper.v``. Otherwise, you can point to it in
`info.yaml <https://github.com/efabless/caravel/blob/master/info.yaml>`__.

**NOTE:**

    If you're using openlane to harden your design, this should
    happen automatically.

Then, you will need to put your design aboard the Caravel chip. Make
sure you have the following:

-  `Magic VLSI Layout
   Tool <http://opencircuitdesign.com/magic/index.html>`__ installed on
   your machine. We may provide a Dockerized version later.\*
-  You have your user\_project\_wrapper.gds under ``./gds/`` in the
   Caravel directory.

**NOTE:**

    You can avoid the need for the magic prerequisite by
    using the openlane docker to run the make step. This
    `section <#running-make-using-openlane-magic>`__ shows how.

Run the following command:

.. code:: bash

    export PDK_ROOT=<The place where the installed pdk resides. The same PDK_ROOT used in the pdk installation step>
    make

|Expectation_DRC|

Running Make using OpenLANE Magic
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To use the magic installed inside Openlane to complete the final GDS
streaming out step, export the following:

.. code:: bash

    export PDK_ROOT=<The location where the pdk is installed>
    export OPENLANE_ROOT=<the absolute path to the openlane directory cloned or to be cloned>
    export IMAGE_NAME=<the openlane image name installed on your machine. Preferably efabless/openlane:rc7>
    export CARAVEL_PATH=$(pwd)

Then, mount the docker:

.. code:: bash

    docker run -it -v $CARAVEL_PATH:$CARAVEL_PATH -v $OPENLANE_ROOT:/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -e CARAVEL_PATH=$CARAVEL_PATH -e PDK_ROOT=$PDK_ROOT -u $(id -u $USER):$(id -g $USER) $IMAGE_NAME

Finally, once inside the docker run the following commands:

.. code:: bash

    cd $CARAVEL_PATH
    make
    exit

|Expectation_DRC|

IMPORTANT
^^^^^^^^^

Please make sure to run ``make compress`` before commiting anything to
your repository. Avoid having 2 versions of the
gds/user\_project\_wrapper.gds or gds/caravel.gds one compressed and the
other not compressed.

Required Directory Structure
----------------------------

-  ./gds/ : includes all the gds files used or produced from the
   project.
-  ./def/ : includes all the def files used or produced from the
   project.
-  ./lef/ : includes all the lef files used or produced from the
   project.
-  ./mag/ : includes all the mag files used or produced from the
   project.
-  ./maglef/ : includes all the maglef files used or produced from the
   project.
-  ./spi/lvs/ : includes all the maglef files used or produced from the
   project.
-  ./verilog/dv/ : includes all the simulation test benches and how to
   run them.
-  ./verilog/gl/ : includes all the synthesized/elaborated netlists.
-  ./verilog/rtl/ : includes all the Verilog RTLs and source files.
-  ./openlane/\ ``<macro>``/ : includes all configuration files used to
   run openlane on your project.
-  info.yaml: includes all the info required in `this
   example <https://github.com/efabless/caravel/blob/master/info.yaml>`__. Please make sure that you are pointing to an
   elaborated caravel netlist as well as a synthesized
   gate-level-netlist for the user\_project\_wrapper

Managment SoC
-------------

The managment SoC runs firmware that can be used to:

-  Configure User Project I/O pads
-  Observe and control User Project signals (through on-chip logic
   analyzer probes)
-  Control the User Project power supply

The memory map of the management SoC can be found
`here <https://github.com/efabless/caravel/blob/master/verilog/rtl/README>`__

User Project Area
-----------------

This is the user space. It has limited silicon area (TBD, about 3.1mm x 3.8mm) as well as a fixed number of I/O pads (37) and power pads (10).

See `the Caravel premliminary datasheet` https://caravel-harness.readthedocs.io/ for details.

The repository contains a `sample user project <https://github.com/efabless/caravel/blob/master/verilog/rtl/user_proj_example.v>`__ that contains a binary 32-bit up counter.

.. raw:: html

   <p align="center">
   <img src="/docs/source/_static/counter_32.png" width="50%" height="50%">
   </p>

The firmware running on the Management Area SoC, configures the I/O pads
used by the counter and uses the logic probes to observe/control the
counter. Three firmware examples are provided:

#. Configure the User Project I/O pads as o/p. Observe the counter value
   in the testbench: `IO\_Ports
   Test <https://github.com/efabless/caravel/blob/master/verilog/dv/caravel/user_proj_example/io_ports>`__.
#. Configure the User Project I/O pads as o/p. Use the Chip LA to load
   the counter and observe the o/p till it reaches 500:
   `LA\_Test1 <https://github.com/efabless/caravel/blob/master/verilog/dv/caravel/user_proj_example/la_test1>`__.
#. Configure the User Project I/O pads as o/p. Use the Chip LA to
   control the clock source and reset signals and observe the counter
   value for five clock cylcles:
   `LA\_Test2 <https://github.com/efabless/caravel/blob/master/verilog/dv/caravel/user_proj_example/la_test2>`__.

.. |Expectation_DRC| replace:: This should merge the GDSes using magic and you'll end up with your version of ``./gds/caravel.gds``. You should expect 0 magic DRC violations with the current state of caravel.

.. |License| image:: https://img.shields.io/github/license/efabless/caravel
   :alt: GitHub license - Apache 2.0
   :target: https://github.com/efabless/caravel
.. |Documentation Status| image:: https://readthedocs.org/projects/caravel-harness/badge/?version=latest
   :alt: ReadTheDocs Badge - https://caravel-harness.rtfd.io
   :target: https://caravel-harness.readthedocs.io/en/latest/?badge=latest
.. |Build Status| image:: https://travis-ci.com/efabless/caravel.svg?branch=master
   :alt: Travis Badge - https://travis-ci.org/efabless/caravel
   :target: https://travis-ci.com/efabless/caravel

