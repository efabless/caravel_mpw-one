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

# We must flatten these because the ports are disconnected
flatten class {-circuit1 dummy_cell_6t}
flatten class {-circuit1 dummy_cell_1rw_1r}
flatten class {-circuit1 dummy_cell_1w_1r}
flatten class {-circuit1 bitcell_array_0}
flatten class {-circuit1 pbitcell_0}
flatten class {-circuit1 pbitcell_1}
property {-circuit1 nshort} remove as ad ps pd
property {-circuit1 pshort} remove as ad ps pd
property {-circuit2 nshort} remove as ad ps pd
property {-circuit2 pshort} remove as ad ps pd
permute transistors
