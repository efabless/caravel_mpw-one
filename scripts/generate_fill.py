#!/bin/env python3
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
# generate_fill.py ---
#
#    Run the fill generation on the caravel top level.
#

import sys
import os
import re
import subprocess

def usage():
    print("Usage:")
    print("generate_fill.py [<path_to_project>] [-keep]")
    print("")
    print("where:")
    print("    <path_to_project> is the path to the project top level directory.")
    print("")
    print("  If <path_to_project> is not given, then it is assumed to be the cwd.")
    print("  If '-keep' is specified, then keep the generation script.")
    return 0

if __name__ == '__main__':

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
        sys.exit(1)

    if len(arguments) == 1:
        user_project_path = arguments[0]
    else:
        user_project_path = os.getcwd()

    if not os.path.isdir(user_project_path):
        print('Error:  Project path "' + user_project_path + '" does not exist or is not readable.')
        sys.exit(1)

    # Check for valid user ID
    user_id_value = None
    if os.path.isfile(user_project_path + '/info.yaml'):
        with open(user_project_path + '/info.yaml', 'r') as ifile:
            infolines = ifile.read().splitlines()
            for line in infolines:
                kvpair = line.split(':')
                if len(kvpair) == 2:
                    key = kvpair[0].strip()
                    value = kvpair[1].strip()
                    if key == 'project_id':
                        user_id_value = value.strip('"\'')
                        break

    project = 'caravel'
    if user_id_value:
        project_with_id = project + '_' + user_id_value
    else:
        print('Error:  No project_id found in info.yaml file.')
        sys.exit(1)

    if '-debug' in optionlist:
        debugmode = True
    if '-keep' in optionlist:
        keepmode = True

    magpath = user_project_path + '/mag'
    rcfile = magpath + '/.magicrc'

    with open(magpath + '/generate_fill.tcl', 'w') as ofile:
        print('#!/bin/env wish', file=ofile)
        print('drc off', file=ofile)
        print('load ' + project + ' -dereference', file=ofile)
        print('select top cell', file=ofile)
        print('expand', file=ofile)

        # Flatten into a cell with a new name
        print('puts stdout "Flattening layout. . . "', file=ofile)
        print('flatten -nolabels ' + project_with_id + '_fill_pattern', file=ofile)
        print('load ' + project_with_id + '_fill_pattern', file=ofile)

        # Remove any GDS_FILE reference
        print('property GDS_FILE ""', file=ofile)
        print('cif ostyle wafflefill', file=ofile)
        print('puts stdout "Writing GDS. . . "', file=ofile)
        print('gds write ../gds/' + project_with_id + '_fill_pattern.gds', file=ofile)
        print('quit -noprompt', file=ofile)

    myenv = os.environ.copy()
    myenv['MAGTYPE'] = 'mag'

    # Diagnostic
    print('This script will generate file ' + project_with_id + '_fill_pattern.gds')
    print('Now generating fill patterns.  This may take. . . quite. . . a while.', flush=True)

    mproc = subprocess.run(['magic', '-dnull', '-noconsole',
		'-rcfile', rcfile, magpath + '/generate_fill.tcl'],
		stdin = subprocess.DEVNULL,
		stdout = subprocess.PIPE,
		stderr = subprocess.PIPE,
		cwd = magpath,
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
        os.remove(magpath + '/generate_fill.tcl')

    print('Done!')
    exit(0)
