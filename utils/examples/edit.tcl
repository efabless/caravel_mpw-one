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
puts "Small delay..."
set macro_mags "digital_pll.mag lvlshiftdown.mag striVe2_soc.mag striVe_clkrst.mag striVe_spi.mag"

gds readonly yes
gds rescale no
gds read ../gds/sram_1rw1r_32_256_8_sky130.gds
lef read ../lef/sram.abs.lef
foreach ff $macro_mags { drc off; load $ff -dereference; after 1000; select top cell; property LEFview TRUE }
load striVe2 -dereference
select top cell
