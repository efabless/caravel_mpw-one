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

lef read $::env(PDKPATH)/libs.ref/techLEF/scs8hd/scs8hd_tech.lef
set macro_mags "openram_tc_core.mag"

# lef read ../lef/sram_1rw1r_32_256_8_sky130_lp1.lef

foreach ff $macro_mags { drc off; after 500; load $ff -dereference; select top cell; property LEFview TRUE }

load openram_tc_1kb -dereference

select top cell
extract do local
extract
ext2spice lvs
ext2spice openram_tc_1kb.ext
feedback save extract.tcl.log
exit
