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

#
# Run netgen on striVe (top level)
#

NETGEN_SETUP=$PDK_ROOT/EFS8A/libs.tech/netgen/EFS8A_setup.tcl

netgen -batch lvs "../spi/openram_tc_1kb.spice openram_tc_1kb" "../verilog/gl/openram_tc_1kb.synthesis.v openram_tc_1kb" ${NETGEN_SETUP} openram_tc_1kb_comp.out -json | tee openram_tc_1kb_comp_lvs.log
