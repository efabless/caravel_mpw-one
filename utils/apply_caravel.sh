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

# To use: sh apply_caravel.sh <target_project_path> <template_caravel_path>

target_project=$1
original_caravel=$2

find $original_caravel/def/* -type f ! -name "user_project_wrapper.def" ! -name "user_proj_example.def" -exec cp {} $target_project/def \;
find $original_caravel/lef/* -type f ! -name "user_project_wrapper.lef" ! -name "user_proj_example.lef" -exec cp {} $target_project/lef \;
find $original_caravel/gds/* -type f ! -name "user_project_wrapper.gds.gz" ! -name "user_proj_example.gds.gz" ! -name "user_project_wrapper.gds" ! -name "user_proj_example.gds" -exec cp {} $target_project/gds \;
find $original_caravel/mag/* -type f ! -name "user_project_wrapper.mag" ! -name "user_proj_example.mag" -exec cp {} $target_project/mag \;
cp $original_caravel/mag/.magicrc $target_project/mag/
mkdir -p $target_project/mag/hexdigits/
mv $target_project/mag/alpha_*.mag $target_project/mag/hexdigits/
cp $original_caravel/maglef/* $target_project/maglef
cp -r $original_caravel/ngspice/digital_pll $target_project/ngspice/digital_pll
cp -r $original_caravel/ngspice/simple_por $target_project/ngspice/simple_por
cp -r $original_caravel/scripts $target_project/scripts
find $original_caravel/spi/lvs/* -type f ! -name "user_project_wrapper.spice" ! -name "user_proj_example.spice" -exec cp {} $target_project/spi/lvs/ \;
cp -r $original_caravel/utils $target_project/utils
find $original_caravel/verilog/rtl/* -type f ! -name "user_project_wrapper.v" ! -name "user_proj_example.v" -exec cp {} $target_project/verilog/rtl/ \;
find $original_caravel/verilog/gl/* -type f ! -name "user_project_wrapper.v" ! -name "user_proj_example.v" -exec cp {} $target_project/verilog/gl/ \;
cp $original_caravel/verilog/stubs/*.v $target_project/verilog/stubs/
cp -r $original_caravel/verilog/dv/caravel $target_project/verilog/dv/caravel
cp -r $original_caravel/verilog/dv/wb_utests $target_project/verilog/dv/wb_utests
cp $original_caravel/verilog/dv/dummy_slave.v $target_project/verilog/dv/dummy_slave.v

echo "You'll have to manually copy the openlane/user_project_wrapper configs based on your preference."
echo "You'll have to manually copy the openlane/Makefile based on your preference."
echo "You'll have to manually copy the Makefile based on your preference."