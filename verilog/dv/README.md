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
# DV Tests

Organized into two subdirectories:
  * caravel: contains tests for both the mangement SoC and an example user project.
  * wb_utests: contains unit tests for the wishbone components residing at the management SoC private bus

<pre>
├── caravel
│   ├── mgmt_soc
│   ├── user_proj_example
└── wb_utests
</pre>

# Run Timing simulations

1. Firstly, you will need to generate the SDF files to annotate the delays . Run the following from the top level makefile: 

```
  # to generate the sdf file for the mgmt_core: make rcx-mgmt_core
  make rcx-<macro-name>
```

This will generate the sdf files under `def/tmp/<macro-name>.sdf`

2. Due to an OpenSTA limitation that causes the typical delays to be missing from the SDF file, you will need to run the following script to add the typical delays to the sdf file: 

```
  # python3 sdf.py mgmt_core.sdf
  python3 sdf.py <sdf-file>
```

3. The testbench must have the sdf_annotate system call to add the delays, for example the following statements will annotate the mgmt_core and the DFFRAM delays: 

```
	$sdf_annotate("../../../../../def/tmp/DFFRAM.sdf", uut.soc.\soc.soc_mem.mem.SRAM );
	$sdf_annotate("../../../../../def/tmp/mgmt_core.sdf", uut.soc);
```

4. Run the delay simulations with CVC: 

```

SIM=GL_SDF make

```
