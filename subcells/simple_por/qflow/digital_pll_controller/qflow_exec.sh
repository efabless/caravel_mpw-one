#!/bin/tcsh -f
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

#-------------------------------------------
# qflow exec script for project ~/gits/caravel/qflow/digital_pll_controller
#-------------------------------------------

# /usr/local/share/qflow/scripts/yosys.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller ~/gits/caravel/qflow/digital_pll_controller/source/digital_pll_controller.v || exit 1
# /usr/local/share/qflow/scripts/graywolf.sh -d ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/opensta.sh  ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/qrouter.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/opensta.sh  -d ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/magic_db.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/magic_drc.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/netgen_lvs.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/magic_gds.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/cleanup.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
/usr/local/share/qflow/scripts/cleanup.sh -p ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
# /usr/local/share/qflow/scripts/magic_view.sh ~/gits/caravel/qflow/digital_pll_controller digital_pll_controller || exit 1
