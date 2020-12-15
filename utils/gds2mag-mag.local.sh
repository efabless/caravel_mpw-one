#!/bin/sh
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

export PDK_ROOT=~/foss/pdks/open_pdks/sky130;
export MAGTYPE=mag ; 
export PDKPATH=$PDK_ROOT/sky130A ;
export MAGIC=magic


$MAGIC  -dnull -noconsole << EOF
#------------------------------------------------------
drc off
#---------------------------------gds polygon subcell true
gds warning default
gds readonly true
gds rescale false
#---------------------------------tech unlock *
gds read $1
load ${1%.gds}
#---------------------------------readspice ${1%.gds}.sp
cellname delete "(UNNAMED)"
save ${1%.gds}.mag
quit -noprompt
EOF
