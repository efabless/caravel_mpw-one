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

# To call: ./magic-ext.sh <target_path> <design_name> <pdk-root> <target-type> <pdk-name> <output_path>

export TARGET_DIR=$1
export DESIGN_NAME=$2
export PDK_ROOT=$3
export TARGET_TYPE=$4
export PDK=$5
export OUT_DIR=$6
export TCL_CALL_PATH=${7:-$(pwd)}

echo "Running Magic..."
export MAGIC_MAGICRC=$PDK_ROOT/$PDK/libs.tech/magic/sky130A.magicrc

magic \
    -noconsole \
    -dnull \
    -rcfile $MAGIC_MAGICRC \
    $TCL_CALL_PATH/magic-ext.tcl \
    </dev/null \
    |& tee $OUT_DIR/magic_ext.log
