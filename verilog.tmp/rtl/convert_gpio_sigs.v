// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/* Convert the standard set of GPIO signals: input, output, output_enb,
 * pullup, and pulldown into the set needed by the s8 GPIO pads:
 * input, output, output_enb, input_enb, mode.  Note that dm[2] on
 * thepads is always equal to dm[1] in this setup, so mode is shown as
 * only a 2-bit signal.
 *
 * This module is bit-sliced.  Instantiate once for each GPIO pad.
 * (Caravel has only one GPIO pad, so bit-slicing is irrelevant.)
 */

module convert_gpio_sigs (
    input        gpio_out,
    input        gpio_outenb,
    input        gpio_pu,
    input        gpio_pd,
    output       gpio_out_pad,
    output       gpio_outenb_pad,
    output       gpio_inenb_pad,
    output       gpio_mode1_pad,
    output       gpio_mode0_pad
);

    assign gpio_out_pad = (gpio_pu == 1'b0 && gpio_pd == 1'b0) ? gpio_out :
            (gpio_pu == 1'b1) ? 1 : 0;

    assign gpio_outenb_pad = (gpio_outenb == 1'b0) ? 0 :
            (gpio_pu == 1'b1 || gpio_pd == 1'b1) ? 0 : 1;

    assign gpio_inenb_pad = ~gpio_outenb;

    assign gpio_mode1_pad = ~gpio_outenb_pad;
    assign gpio_mode0_pad = gpio_outenb;

endmodule
`default_nettype wire
