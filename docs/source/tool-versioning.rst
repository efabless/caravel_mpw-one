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

Repositories and versions to use
================================

skywater-pdk
------------

| Please stick to commit hash: ``bb2f842ac8d1b750677ca25bc71fb312859edb82`` |

.. code:: bash

    git clone https://github.com/google/skywater-pdk.git
    cd skywater-pdk
    git checkout -qf bb2f842ac8d1b750677ca25bc71fb312859edb82
    git submodule update --init libraries/sky130_fd_sc_hd/latest
    git submodule update --init libraries/sky130_fd_sc_hvl/latest
    git submodule update --init libraries/sky130_fd_sc_hs/latest
    git submodule update --init libraries/sky130_fd_sc_ms/latest
    git submodule update --init libraries/sky130_fd_sc_ls/latest
    git submodule update --init libraries/sky130_fd_sc_hdll/latest
    git submodule update --init libraries/sky130_fd_io/latest
    make timing

open\_pdks
----------

Please stick to the
`1.0.150 <https://github.com/RTimothyEdwards/open_pdks/tree/1.0.150>`__
tag.

.. code:: bash

    git clone https://github.com/RTimothyEdwards/open_pdks.git -b 1.0.150 

OpenLane
--------

Please stick to the v0.15 `tag <https://github.com/efabless/openlane/tree/v0.15>`__ of openlane. 

.. code:: bash

    git clone https://github.com/efabless/openlane.git -b v0.15


Caravel/Caravel-lite
--------------------

Please stick to the ``mpw-two-c`` tag.

.. code:: bash

    git clone https://github.com/efabless/caravel.git -b mpw-two-c
    git clone https://github.com/efabless/caravel-lite.git -b mpw-two-c caravel

Open\_mpw\_precheck
-------------------

Please run the offline
`precheck <https://github.com/efabless/open_mpw_precheck>`__:

.. code:: bash

    git clone https://github.com/efabless/open_mpw_precheck.git


Notes
-----

-  | If you have already successfully hardened your blocks and have a clean
   |  ``user_project_wrapper``, you don't have to recreate it and can just reuse it.
   | This is only if no changes have been made to the user project area or to the tools that
   |  require you to reharden your design(s).

-  | If you will use openlane to harden your blocks, you can refer to
   |  this `README <https://github.com/efabless/caravel/blob/master/openlane/README.rst>`__.

-  | **IMPORTANT**. Do not forget to run ``make uncompress -j4`` in your user project root
   |  directory before you start working. Likewise, before you commit and push your
   |  changes back, run ``make compress -j4``.

-  | If you already have a clean working tree in a previously cloned repository from
   |  those listed above, what you need to do is:
   |  ``git pull   git checkout tag``

