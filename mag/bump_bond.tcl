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

namespace path {::tcl::mathop ::tcl::mathfunc}

# Bump bond is a circle (approximated by a 20-sided polygon) of
# diameter nominally 250um

set rbump 125
set coords []
for {set i 0} {$i < 20} {incr i} {
    set angle [* $i 18]
    set arad [/ [* 3.1415926 $angle] 180.0]
    lappend coords [int [* $rbump [cos $arad]]]um
    lappend coords [int [* $rbump [sin $arad]]]um
}

eval [subst {polygon metalrdl $coords}]
