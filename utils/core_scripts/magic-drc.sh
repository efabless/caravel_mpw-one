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

# To call: ./magic-drc.sh <target_path> <design_name> <pdk-root> <target-type> <pdk-name> <output_path>

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
    $TCL_CALL_PATH/magic-drc.tcl \
    </dev/null \
    |& tee $OUT_DIR/magic_drc.log

TEST=$OUT_DIR/$DESIGN_NAME.magic.drc

crashSignal=$(find $TEST)
if ! [[ $crashSignal ]]; then echo "DRC Check FAILED"; exit -1; fi


Test_Magic_violations=$(grep "COUNT: " $TEST -s | tail -1 | sed -r 's/[^0-9]*//g')
if ! [[ $Test_Magic_violations ]]; then Test_Magic_violations=-1; fi
if [ $Test_Magic_violations -ne -1 ]; then Test_Magic_violations=$(((Test_Magic_violations+3)/4)); fi

echo "Test # of DRC Violations:"
echo $Test_Magic_violations

if [ 0 -ne $Test_Magic_violations ]; then echo "DRC Check FAILED"; exit -1; fi

echo "DRC Check Passed"
exit 0
