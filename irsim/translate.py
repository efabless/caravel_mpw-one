#!/usr/bin/env python3
#
import sys
import re

if len(sys.argv) < 2:
    print('Usage:  translate.py file_in.sim file_out.sim')
    sys.exit(1)

print('Input:  ' + sys.argv[1])
print('Output:  ' + sys.argv[2])

with open(sys.argv[2], 'w') as ofile:
    with open(sys.argv[1], 'r') as ifile:
        for line in ifile:
            tokens = line.split()
            if tokens[0] == 'x':
                lt = len(tokens)
                if lt > 6:
                    if tokens[-1] == 'sky130_fd_pr__pfet_01v8_hvt':
                        tokens[0] = 'p'
                    elif tokens[-1] == 'sky130_fd_pr__nfet_01v8':
                        tokens[0] = 'n'
                    else:
                        print('Unrecognized device ' + tokens[-1])

                    # Strip parameter name off of the four tokens in front of
                    # the device name.
                    tokens[-2] = tokens[-2][2:]
                    tokens[-3] = tokens[-3][2:]
                    tokens[-4] = tokens[-4][2:]
                    tokens[-5] = tokens[-5][2:]
                    newline = ' '.join(tokens[:-6])
                    newline += ' ' + ' '.join(tokens[-5:-1])
                    print(newline, file=ofile)
            elif tokens[0] == 'r':
                # Resistors---value gets output as zero (need to check why).
                tokens[-1] = '515.0'
                newline = ' '.join(tokens)
                print(newline, file=ofile)
            elif tokens[0] == 'D':
                # Replace each diode with an equivalent diffusion capacitance
                tokens[0] = 'C'
                tokens.append('0.878')
                newline = ' '.join(tokens)
                print(newline, file=ofile)
            elif tokens[0] == 'C':
                # Test:  Check for possible over-calculation of parasitics
                cval = float(tokens[-1]) * 1.0;
                tokens[-1] = str(cval)
                # Fix broken "GND" reference (where does it come from?)
                if tokens[-2] == 'GND':
                    tokens[-2] = 'VGND'
                newline = ' '.join(tokens)
                print(newline, file=ofile)
            else:
                print(line, file=ofile, end='')
