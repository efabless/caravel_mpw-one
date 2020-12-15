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

# To call: ./ext-def-sky130A.sh <target_path> <design_name> <pdk-root> [<output_path> default is <target_path>/results/]

export TARGET_DIR=$1
export DESIGN_NAME=$2
export PDK_ROOT=$3
export OUT_DIR=${4:-$TARGET_DIR/results/}
export TCL_CALL_PATH=$(pwd)/core_scripts

if ! [[ -d "$OUT_DIR" ]]
then
    mkdir $OUT_DIR
fi

bash ./core_scripts/magic-ext.sh $TARGET_DIR $DESIGN_NAME $PDK_ROOT "def" "sky130A" $OUT_DIR $TCL_CALL_PATH
