# Copyright 2020 Efabless Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#      http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

drc off
gds readonly true
gds rescale false

gds read chip_io.gds

gds read gpio_control_block.gds

gds read mgmt_protect.gds

gds read simple_por.gds

gds read digital_pll.gds
gds read DFFRAM.gds
gds read mgmt_core.gds

gds read storage.gds

gds read user_id_programming.gds

gds read sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.gds

# Your project goes aboard here
gds read user_project_wrapper.gds

load ../mag/caravel.mag -dereference
property GDS_FILE ""
property GDS_START ""
property GDS_END ""

save caravel

select top cell

# cif *hier write disable

gds write caravel.gds
