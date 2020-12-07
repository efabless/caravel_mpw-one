#!/bin/env python3
#
# generate_fill.py ---
#
#    Run the fill generation on the caravel top level.
#

import sys
import os
import re
import subprocess

def usage():
    print("generate_fill.py [layout_name] [-keep]")
    return 0

if __name__ == '__main__':

    if len(sys.argv) == 1:
        usage()
        sys.exit(0)

    optionlist = []
    arguments = []

    debugmode = False
    keepmode = False

    for option in sys.argv[1:]:
        if option.find('-', 0) == 0:
            optionlist.append(option)
        else:
            arguments.append(option)

    if len(arguments) > 1:
        print("Wrong number of arguments given to generate_fill.py.")
        usage()
        sys.exit(0)

    if len(arguments) == 1:
        project = arguments[0]
    else:
        project = 'caravel'

    if '-debug' in optionlist:
        debugmode = True
    if '-keep' in optionlist:
        keepmode = True

    magdir = '../mag'
    rcfile = magdir + '/.magicrc'

    with open(magdir + '/generate_fill.tcl', 'w') as ofile:
        print('#!/bin/env wish', file=ofile)
        print('drc off', file=ofile)
        print('load ' + project + ' -dereference', file=ofile)
        print('select top cell', file=ofile)
        print('expand', file=ofile)

        # Flatten into a cell with a new name
        print('puts stdout "Flattening layout. . . "', file=ofile)
        print('flatten -nolabels ' + project + '_fill_pattern', file=ofile)
        print('load ' + project + '_fill_pattern', file=ofile)

        # Remove any GDS_FILE reference
        print('property GDS_FILE ""', file=ofile)
        print('cif ostyle wafflefill', file=ofile)
        print('puts stdout "Writing GDS. . . "', file=ofile)
        print('gds write ../gds/' + project + '_fill_pattern.gds', file=ofile)
        print('quit -noprompt', file=ofile)

    myenv = os.environ.copy()
    myenv['MAGTYPE'] = 'mag'

    mproc = subprocess.run(['magic', '-dnull', '-noconsole',
		'-rcfile', rcfile, magdir + '/generate_fill.tcl'],
		stdin = subprocess.DEVNULL,
		stdout = subprocess.PIPE,
		stderr = subprocess.PIPE,
		cwd = magdir,
		env = myenv,
		universal_newlines = True)
    if mproc.stdout:
        for line in mproc.stdout.splitlines():
            print(line)
    if mproc.stderr:
        print('Error message output from magic:')
        for line in mproc.stderr.splitlines():
            print(line)
        if mproc.returncode != 0:
            print('ERROR:  Magic exited with status ' + str(mproc.returncode))

    if not keepmode:
        os.remove(magdir + '/generate_fill.tcl')

    exit(0)
