"""Remember the calculations that were made."""

_entries = []


def record(op, a, b, result):
    _entries.append(f"{a} {op} {b} = {result}")


def show():
    return "\n".join(_entries)
