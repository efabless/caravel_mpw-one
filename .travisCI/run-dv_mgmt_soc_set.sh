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

PDK_PATH=$1; shift
MGMT_SOC_PATTERNS=( "$@" )
last_idx=$(( ${#MGMT_SOC_PATTERNS[@]} - 1 ))
TARGET_PATH=${MGMT_SOC_PATTERNS[$last_idx]}
unset MGMT_SOC_PATTERNS[$last_idx]
last_idx=$(( ${#MGMT_SOC_PATTERNS[@]} - 1 ))
ID=${MGMT_SOC_PATTERNS[$last_idx]}
unset MGMT_SOC_PATTERNS[$last_idx]

echo "arg1=$PDK_PATH"
echo "arg3=$ID"
echo "arg2=$TARGET_PATH"
echo "MGMT_SOC_PATTERNS contains:"
printf "%s\n" "${MGMT_SOC_PATTERNS[@]}"

export RUN_WRAPPER=$TARGET_PATH/.travisCI/run_wrapper.sh

OUT_FILE=$TARGET_PATH/mgmt_soc_dv.$ID.out
VERDICT_FILE=$TARGET_PATH/mgmt_soc_verdict.$ID.out
cd $TARGET_PATH/verilog/dv/caravel/mgmt_soc;
touch $OUT_FILE
for PATTERN in ${MGMT_SOC_PATTERNS[*]}
do
    echo "Executing DV on $PATTERN";
    cd $PATTERN;
    for x in RTL GL
    do
        export SIM=$x
        echo "Running $SIM.."
        logFile=$TARGET_PATH/mgmt_soc_$PATTERN.$SIM.dv.out
        bash $RUN_WRAPPER "make" 2>&1 | tee $logFile
        grep "Monitor" $logFile >> $OUT_FILE
        make clean
    done
    cd ..;
done

cat $OUT_FILE

cnt=$(grep "Passed" $OUT_FILE | wc -l)

len=${#MGMT_SOC_PATTERNS[@]}
tot=$(( 2*len ))
echo "array length: $len"
echo "total passed expected: $tot"
echo "passed found: $cnt"
if [[ $cnt -gt $tot ]]; then echo "PASS" > $VERDICT_FILE; exit 0 fi

echo "FAIL" > $VERDICT_FILE

exit 0
