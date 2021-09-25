#!/usr/bin/env python3
#
import sys
import re

if len(sys.argv) < 2:
    print('Usage:  translate.py file_in.sim file_out.sim')
    sys.exit(1)

print('Input:  ' + sys.argv[1])
print('Output: ' + sys.argv[2])

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
                    for i in range(1, lt):
                        if '=' in tokens[i]:
                            break
                        elif len(tokens[i]) > 5:
                            if tokens[i][-4:] == '/VPB':
                                tokens[i] = 'VPWR'
                            elif tokens[i][-4:] == '/VNB':
                                tokens[i] = 'VGND'
                            elif tokens[i][-5:] == '/VPWR':
                                tokens[i] = 'VPWR'
                            elif tokens[i][-5:] == '/VGND':
                                tokens[i] = 'VGND'
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
                # Test:  Check for possible over-calculation of parasitics.
                # by removing all parasitics.
                cval = float(tokens[-1]) * 0.50;
                tokens[-1] = str(cval)
                newline = ' '.join(tokens)
                print(newline, file=ofile)
            else:
                print(line, file=ofile, end='')
