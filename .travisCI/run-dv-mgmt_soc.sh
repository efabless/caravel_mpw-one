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

MGMT_SOC_PATTERNS_1=(gpio perf hkspi sysctrl mem uart)
MGMT_SOC_PATTERNS_2=(mprj_ctrl pass_thru timer timer2 pll storage)

bash $TARGET_PATH/.travisCI/run-dv_mgmt_soc_set.sh $PDK_PATH "${MGMT_SOC_PATTERNS_1[@]}" 1 $TARGET_PATH &
bash $TARGET_PATH/.travisCI/run-dv_mgmt_soc_set.sh $PDK_PATH "${MGMT_SOC_PATTERNS_2[@]}" 2 $TARGET_PATH &
wait

VERDICT_FILE_1=$TARGET_PATH/mgmt_soc_verdict.1.out
VERDICT_FILE_2=$TARGET_PATH/mgmt_soc_verdict.2.out
VERDICT_FILE=$TARGET_PATH/mgmt_soc_verdict.out

cat $VERDICT_FILE_1 > $VERDICT_FILE
cat $VERDICT_FILE_2 >> $VERDICT_FILE
