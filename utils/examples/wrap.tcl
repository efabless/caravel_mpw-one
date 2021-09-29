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
# SPDX-License-Identifier: Apache-2.0

drc off
gds readonly yes
gds rescale no

gds read ../macros/sram/riscv-sky130/sram_1rw1r_32_256_8_sky130.gds
load sram_1rw1r_32_256_8_sky130

select top cell
property LEFview "TRUE"

save pk_sram_1rw1r_32_256_8_sky130.mag

# exec sed -i -E "/^.*GDS_END.*$/d" sram_1rw1r_32_256_8_sky130_original.mag
