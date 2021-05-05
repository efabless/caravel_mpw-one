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
: ${1?"Usage: $0 file.mag llx lly urx ury"}
: ${2?"Usage: $0 file.mag llx lly urx ury"}
: ${3?"Usage: $0 file.mag llx lly urx ury"}
: ${4?"Usage: $0 file.mag llx lly urx ury"}
: ${5?"Usage: $0 file.mag llx lly urx ury"}
: ${PDK_ROOT?"You need to export PDK_ROOT"}


export PDK=sky130A

export MAGIC_MAGICRC=$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc

MAGTYPE=mag magic -rcfile $MAGIC_MAGICRC -dnull -noconsole $1 <<EOF
echo $MAGTYPE
## Draw Top Boundary
box 0um $5um $4um 3520.5um
paint comment
## Draw Bottom Boundary
box 0um -0.5um $4um 0um
paint comment
## Draw Left Boundary
box -0.5um -0.5um 0um 3520.5um
paint comment
## Draw Right Boundary
box $4um -0.5um 2920.5um 3520.5um
paint comment
## Save mag file
save
EOF
ls $1
