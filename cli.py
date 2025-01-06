"""Usage: python3 cli.py <op> <a> <b>"""
import sys

import calc

OPS = {
    "add": calc.add,
    "sub": calc.sub,
    "mul": calc.mul,
}


def main(argv):
    if len(argv) != 4 or argv[1] not in OPS:
        print(__doc__)
        return 1
    op, a, b = argv[1], float(argv[2]), float(argv[3])
    print(OPS[op](a, b))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
