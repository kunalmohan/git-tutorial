# Tiny helpers for check.sh (sourced; not run directly).

# A working Python: python3 (macOS/Linux) or python / py (Windows). Empty if none works.
# Each candidate is really executed, which skips the Microsoft Store "python3" stub on Windows.
find_python() {
  local c
  for c in python3 python py; do
    if "$c" -c 'import sys' >/dev/null 2>&1; then echo "$c"; return 0; fi
  done
  return 1
}
PY="$(find_python)"
PASS=0; FAIL=0
ok()   { printf '  \033[32m✔\033[0m %s\n' "$1"; PASS=$((PASS + 1)); }
bad()  { printf '  \033[31m✘\033[0m %s\n' "$1"; [ -n "${2:-}" ] && printf '      hint: %s\n' "$2"; FAIL=$((FAIL + 1)); }
note() { printf '  \033[33m·\033[0m %s\n' "$1"; }

# check "what we verify" "hint if it fails" command [args...]
check() {
  local desc="$1" hint="$2"; shift 2
  if "$@" >/dev/null 2>&1; then ok "$desc"; else bad "$desc" "$hint"; fi
}

in_progress() {
  local g; g="$(git rev-parse --git-dir)"
  [ -f "$g/MERGE_HEAD" ] || [ -d "$g/rebase-merge" ] || [ -d "$g/rebase-apply" ] || [ -f "$g/CHERRY_PICK_HEAD" ]
}

finish() {
  local rerun="${1:-./check.sh}"
  echo
  if [ "$FAIL" -eq 0 ]; then
    printf '\033[32m🎉 All checks passed.\033[0m\n'
  else
    printf '\033[31mNot there yet:\033[0m %s check(s) failing. Read the hint(s), fix, and run %s again.\n' "$FAIL" "$rerun"
    exit 1
  fi
}
