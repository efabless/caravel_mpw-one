#!/bin/bash
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


export PDKPATH=/home/mk/zooz/pdks/ef-skywater-s8/EFS8A
export MAGTYPE=mag 

padring \
-L $PDKPATH/libs.ref/lef/s8iom0s8/s8iom0s8.lef \
-L $PDKPATH/libs.ref/lef/s8iom0s8/power_pads_lib.lef \
--def padframe.def padframe.cfg 

magic -rcfile $PDKPATH/libs.tech/magic/current/EFS8A.magicrc -noc -dnull <<EOF
def read padframe.def
save padframe
select top cell
lef write padframe.lef
gds write padframe.gds
exit
EOF





