#!/usr/bin/env bash
# Replays the model solution of every exercise in a fresh clone and verifies
# that each exercise's check.sh fails BEFORE and passes AFTER.
# Doubles as the tutor's answer key.   Usage: tools/selftest.sh [ex1 ex2 ...]
# Windows-style run (CRLF checkout):  CLONE_ARGS='-c core.autocrlf=true' tools/selftest.sh
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
export GIT_EDITOR=true GIT_MERGE_AUTOEDIT=no
export GIT_AUTHOR_NAME=Student GIT_AUTHOR_EMAIL=student@example.com GIT_COMMITTER_NAME=Student GIT_COMMITTER_EMAIL=student@example.com

git clone -q ${CLONE_ARGS:-} "$ROOT" "$WORK/clone" 2>/dev/null
cd "$WORK/clone"
failures=0

step() { printf '\n== %s\n' "$*"; }
fails_now()  { if ./check.sh >/dev/null 2>&1; then echo "  SELFTEST FAIL: check.sh already passes before solving"; failures=$((failures+1)); else echo "  ok: check fails before solving"; fi; }
passes_now() { if ./check.sh >"$WORK/out" 2>&1; then echo "  ok: check passes after solving"; else cat "$WORK/out"; echo "  SELFTEST FAIL: check.sh fails after solving"; failures=$((failures+1)); fi; }
begin() { git switch -q "$1/main" && ./setup.sh >/dev/null && fails_now; }

solve_ex1() {
  step ex1; begin ex1
  out="$(git merge ex1/more-operations 2>&1)"; case "$out" in *Fast-forward*) ;; *)  echo "  SELFTEST FAIL: first merge not a fast-forward"; failures=$((failures+1)) ;; esac
  git merge ex1/history >/dev/null
  git branch -d ex1/more-operations ex1/history >/dev/null
  passes_now
}

only=("$@"); [ ${#only[@]} -eq 0 ] && only=(ex1 ex2 ex3 ex4 ex5)
for ex in "${only[@]}"; do
  if declare -F "solve_$ex" >/dev/null; then "solve_$ex"; fi
done
echo
if [ "$failures" -eq 0 ]; then echo "SELFTEST: all good"; else echo "SELFTEST: $failures problem(s)"; exit 1; fi
