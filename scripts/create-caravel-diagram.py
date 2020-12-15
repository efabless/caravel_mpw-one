import sys
import os
import subprocess
from pathlib import Path
import argparse
from tempfile import mkstemp
import re


def main(argv):
    parser = argparse.ArgumentParser(argv[0])
    parser.add_argument(
        'verilog_rtl_dir',
        help="Path to the project's verilog/rtl directory",
        type=Path)
    parser.add_argument(
        'output',
        help="Path to the output SVG file",
        type=Path)
    parser.add_argument(
        '--num-iopads',
        help='Number of iopads to render',
        type=int,
        default=38)
    parser.add_argument(
        '--yosys-executable',
        help='Path to yosys executable',
        type=Path,
        default='yosys')
    parser.add_argument(
        '--netlistsvg-executable',
        help='Path to netlistsvg executable',
        type=Path,
        default='netlistsvg')

    args = parser.parse_args(argv[1:])

    fd, jsonpath = mkstemp(suffix='-yosys.json')
    os.close(fd)

    yosyscommand = [
        f'{str(args.yosys_executable)}',
        '-p',
        'read_verilog pads.v defines.v; ' +
        'read_verilog -lib -overwrite *.v; ' +
        f'verilog_defines -DMPRJ_IO_PADS={args.num_iopads}; ' +
        'read_verilog -overwrite caravel.v; ' +
        'hierarchy -top caravel; ' +
        'proc; ' +
        'opt; ' +
        f'write_json {jsonpath}; '
    ]

    result = subprocess.run(
        yosyscommand,
        cwd=args.verilog_rtl_dir,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT
    )

    exitcode = 0
    if result.returncode != 0:
        print(f'Failed to run: {" ".join(yosyscommand)}', file=sys.stderr)
        print(result.stdout.decode())
        exitcode = result.returncode
    else:
        with open(jsonpath, 'r') as unclean:
            lines = unclean.readlines()
        with open(jsonpath, 'w') as cleaned:
            for line in lines:
                cleaned.write(re.sub('inout', 'input', line))
        command = f'{args.netlistsvg_executable} {jsonpath} -o {args.output}'
        result = subprocess.run(
            command.split(),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        )
        if result.returncode != 0:
            print(f'Failed to run: {command}', file=sys.stderr)
            print(result.stdout.decode())
            exitcode = result.returncode

    os.unlink(jsonpath)
    sys.exit(exitcode)

if __name__ == '__main__':
    sys.exit(main(sys.argv))
