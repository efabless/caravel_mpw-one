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

docker pull efabless/dv_setup:latest

export PDK_PATH=$(pwd)/../pdks/sky130A

export TARGET_PATH=$(pwd)
docker run -it -v $TARGET_PATH:$TARGET_PATH -v $PDK_PATH:$PDK_PATH \
    -e TARGET_PATH=$TARGET_PATH -e PDK_PATH=$PDK_PATH \
    -u $(id -u $USER):$(id -g $USER) efabless/dv:latest \
    bash -c "cd $TARGET_PATH; export THREADS=2; make -j2 verify;"

exit 0
