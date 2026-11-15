# Exercise 1 - merging (Python). Sourced by build-exercises.sh.
build() {
  # ---- ex1/main: initial commit -------------------------------------------
  git switch -q -c ex1/main
  scaffold ex1
  put EXERCISE.md <<'EOF'
# Exercise 1 — Merge two feature branches

Language: Python (you will **not** write any code, only run git)

The project is a tiny calculator. Two teammates built features on separate branches:

| Branch | What it adds |
|---|---|
| `ex1/main` | the calculator as it is today (`add`, `sub`) |
| `ex1/more-operations` | `mul` and `div` (2 commits) |
| `ex1/history` | a history log + README note (2 commits) |

Your job: get both features into `ex1/main`.

## 0. Setup

```bash
git switch ex1/main     # first time only: Git creates the branch for you
./setup.sh              # creates local copies of all ex1/* branches
git graph               # our shortcut for a tidy commit graph
```

> **Look before you leap.** In `git graph`, where do the two feature branches
> start? Has `ex1/main` moved since they branched off?

## 1. Merge `ex1/more-operations`

**Predict first:** will this be a fast-forward or will Git create a merge commit?

```bash
git merge ex1/more-operations
git graph
```

Read Git's output. Were you right? Did a new commit appear?

## 2. Merge `ex1/history`

**Predict again.** Has `ex1/main` moved since `ex1/history` branched off?

```bash
git merge ex1/history
```

Git opens your editor for the merge-commit message. Accept the default
(save and close; in vim: `:wq`). Then:

```bash
git graph
python3 cli.py mul 6 7     # a feature from step 1
ls                          # history.py from step 2
```

> 🪟 **Windows:** type `python` (or `py`) instead of `python3`.

## 3. Clean up

Merged branches are just labels you no longer need:

```bash
git branch --merged         # which branches are fully merged into this one?
git branch -d ex1/more-operations ex1/history
git graph                   # the commits are all still here — only the labels went
```

## Check your work

```bash
./check.sh
```

## Stuck? Want to redo it?

`./setup.sh` resets everything. If you're mid-merge: `git merge --abort`.

## Stretch (if time)

Reset with `./setup.sh`, then merge `ex1/history` **first** and
`ex1/more-operations` second. Which one is the fast-forward now? Then reset
again and try `git merge --no-ff ex1/more-operations`. What changed in the graph?
EOF
  put check.sh <<'EOF'
#!/usr/bin/env bash
cd "$(git rev-parse --show-toplevel)"; source ./.lib.sh
echo "Exercise 1 — checking your work"
on_main() { [ "$(git branch --show-current)" = "ex1/main" ]; }
has() { git merge-base --is-ancestor "origin/$1" ex1/main; }
merges() { [ "$(git rev-list --merges --count ex1/main)" -ge 1 ]; }
mul_works() { [ "$("$PY" cli.py mul 6 7 | tr -d '\r')" = "42.0" ]; }
history_there() { git cat-file -e ex1/main:history.py; }

check "you are on ex1/main" "git switch ex1/main" on_main
check "ex1/more-operations is merged into ex1/main" "git merge ex1/more-operations" has ex1/more-operations
check "ex1/history is merged into ex1/main" "git merge ex1/history" has ex1/history
check "there is a real merge commit in the history" "one of your merges should have created a merge commit" merges
if [ -n "$PY" ]; then
  check "the calculator really multiplies (cli.py mul 6 7 prints 42.0)" "are you on ex1/main with the merge done?" mul_works
fi
check "history.py is in ex1/main" "merge ex1/history" history_there
if [ "$(git rev-list --merges --count ex1/main)" = "1" ]; then
  note "exactly one merge commit: one fast-forward + one 3-way merge. That is the expected result."
fi
if [ -z "$(git branch --list 'ex1/more-operations' 'ex1/history')" ]; then
  note "bonus: merged branches cleaned up"
else
  note "bonus (optional): delete the merged branches with git branch -d"
fi
finish
EOF
  finish_check
  put calc.py <<'EOF'
"""A tiny calculator library."""


def add(a, b):
    return a + b


def sub(a, b):
    return a - b
EOF
  put cli.py <<'EOF'
"""Usage: python3 cli.py <op> <a> <b>"""
import sys

import calc

OPS = {
    "add": calc.add,
    "sub": calc.sub,
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
EOF
  put README.md <<'EOF'
# calc

A tiny calculator.

```bash
python3 cli.py add 2 3
```
EOF
  commit "Initial commit: add and sub"

  put .gitignore <<'EOF'
__pycache__/
*.pyc
EOF
  commit "Add .gitignore"

  # ---- ex1/more-operations: 2 commits, touches calc.py + cli.py -----------
  git switch -q -c ex1/more-operations
  put calc.py <<'EOF'
"""A tiny calculator library."""


def add(a, b):
    return a + b


def sub(a, b):
    return a - b


def mul(a, b):
    return a * b
EOF
  put cli.py <<'EOF'
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
EOF
  commit "Add multiplication"
  put calc.py <<'EOF'
"""A tiny calculator library."""


def add(a, b):
    return a + b


def sub(a, b):
    return a - b


def mul(a, b):
    return a * b


def div(a, b):
    if b == 0:
        raise ValueError("cannot divide by zero")
    return a / b
EOF
  put cli.py <<'EOF'
"""Usage: python3 cli.py <op> <a> <b>"""
import sys

import calc

OPS = {
    "add": calc.add,
    "sub": calc.sub,
    "mul": calc.mul,
    "div": calc.div,
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
EOF
  commit "Add division with a zero check"

  # ---- ex1/history: branches from ex1/main, touches history.py + README ---
  git switch -q ex1/main
  git switch -q -c ex1/history
  put history.py <<'EOF'
"""Remember the calculations that were made."""

_entries = []


def record(op, a, b, result):
    _entries.append(f"{a} {op} {b} = {result}")


def show():
    return "\n".join(_entries)
EOF
  commit "Add history module"
  put README.md <<'EOF'
# calc

A tiny calculator.

```bash
python3 cli.py add 2 3
```

## History

`history.py` keeps a log of calculations (wired into the CLI soon).
EOF
  commit "Mention history in README"

  git switch -q ex1/main
}
