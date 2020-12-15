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


export MAGTYPE=mag ;
export BASE=/home/mk/zooz/ ;
export PDKPATH=$BASE/pdks/ef-skywater-s8/EFS8A ;

magic -dnull -noconsole -rcfile $PDKPATH/libs.tech/magic/current/EFS8A.magicrc <<EOF
gds polygon subcell true
gds warning default
gds read $1.gds
load $1
cellname delete \(UNNAMED\)
writeall force
select top cell
expand
drc on
drc euclidean on
drc check
drc catchup
drc listall 
drc listall why
drc count total
drc count
quit -noprompt
EOF
