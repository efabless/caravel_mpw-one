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

PDK_PATH=$1
TARGET_PATH=$2
OUT_FILE=$TARGET_PATH/mgmt_soc_dv.out
VERDICT_FILE=$TARGET_PATH/mgmt_soc_verdict.out
MGMT_SOC_PATTERNS=(gpio mem uart perf hkspi sysctrl mprj_ctrl pass_thru timer timer2 pll storage)


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
        make 2>&1 | tee $logFile
        grep "Monitor" $logFile >> $OUT_FILE
        make clean
    done
    cd ..;
done

cat $OUT_FILE

cnt=$(grep "Passed" $OUT_FILE | wc -l)

len=${#MGMT_SOC_PATTERNS[@]}
if [[ $cnt -gt $len ]]; then echo "PASS" > $VERDICT_FILE; exit 0 fi

echo "FAIL" > $VERDICT_FILE
