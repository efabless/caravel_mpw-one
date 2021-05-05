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
: ${1?"Usage: $0 file.mag llx_top lly_top urx_top ury_top llx_bottom lly_bottom urx_bottom ury_bottom"}
: ${2?"Usage: $0 file.mag llx_top lly_top urx_top ury_top llx_bottom lly_bottom urx_bottom ury_bottom"}
: ${3?"Usage: $0 file.mag llx_top lly_top urx_top ury_top llx_bottom lly_bottom urx_bottom ury_bottom"}
: ${4?"Usage: $0 file.mag llx_top lly_top urx_top ury_top llx_bottom lly_bottom urx_bottom ury_bottom"}
: ${5?"Usage: $0 file.mag llx_top lly_top urx_top ury_top llx_bottom lly_bottom urx_bottom ury_bottom"}
: ${6?"Usage: $0 file.mag llx_top lly_top urx_top ury_top llx_bottom lly_bottom urx_bottom ury_bottom"}
: ${7?"Usage: $0 file.mag llx_top lly_top urx_top ury_top llx_bottom lly_bottom urx_bottom ury_bottom"}
: ${8?"Usage: $0 file.mag llx_top lly_top urx_top ury_top llx_bottom lly_bottom urx_bottom ury_bottom"}
: ${9?"Usage: $0 file.mag llx_top lly_top urx_top ury_top llx_bottom lly_bottom urx_bottom ury_bottom"}
: ${PDK_ROOT?"You need to export PDK_ROOT"}

export PDK=sky130A

export MAGIC_MAGICRC=$PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc
ls $1
echo $1
MAGTYPE=mag magic -rcfile $MAGIC_MAGICRC -dnull -noconsole $1  <<EOF
echo $MAGTYPE
select top cell 
select area label
setlabel font FreeSans
setlabel size 0.7um
setlabel justify c
### Rotate Top Labels
box $2um $3um $4um $5um
select area
setlabel size 1.2um
setlabel rotate 180
### Rotate Bottom Labels
box $6um $7um $8um $9um
select area
setlabel rotate 90
###
save
EOF
ls $1
