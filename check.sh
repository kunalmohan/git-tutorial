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
