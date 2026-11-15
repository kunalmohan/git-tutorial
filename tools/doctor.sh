#!/usr/bin/env bash
# Pre-flight check: is this computer ready for the course?   Run: tools/doctor.sh
cd "$(git rev-parse --show-toplevel 2>/dev/null || dirname "$0")" || exit 1
source "$(dirname "$0")/templates/check-lib.sh"
echo "Checking your setup"

ver="$(git --version | sed -E 's/[^0-9]*([0-9]+)\.([0-9]+).*/\1 \2/')"
set -- $ver
if [ "$1" -gt 2 ] || { [ "$1" -eq 2 ] && [ "$2" -ge 23 ]; }; then
  ok "git $(git --version | awk '{print $3}') (need 2.23 or newer)"
else
  bad "git is too old ($(git --version))" "install a current Git: https://git-scm.com/downloads"
fi

[ -n "$(git config --global user.name)" ]  && ok "user.name = $(git config --global user.name)" \
  || bad "user.name is not set" 'git config --global user.name "Your Name"'
[ -n "$(git config --global user.email)" ] && ok "user.email is set" \
  || bad "user.email is not set" 'git config --global user.email "you@example.com"'

if [ -n "$(git config --global core.editor)$GIT_EDITOR$VISUAL$EDITOR" ]; then
  ok "an editor is configured ($(git config --global core.editor || echo "${GIT_EDITOR:-${VISUAL:-$EDITOR}}"))"
else
  note "no editor configured - Git will use its default (often vim). Recommended: git config --global core.editor \"code --wait\""
fi

[ -n "$PY" ] && ok "Python found: '$PY' (used by some exercise checks)" \
  || note "no working Python found (python3 / python / py) - the exercises still work, a few automatic checks are skipped"

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) ok "running in Git Bash on Windows" ;;
  Linux)
    if grep -qi microsoft /proc/version 2>/dev/null; then
      case "$PWD" in
        /mnt/*) bad "WSL: this folder is on the Windows drive ($PWD)" "move it into your Linux home (cd ~ and clone there): it's faster and avoids line-ending problems" ;;
        *)      ok "running in WSL, folder is in the Linux filesystem" ;;
      esac
    fi ;;
esac

git remote get-url origin >/dev/null 2>&1 && ok "this clone has a remote called 'origin'" \
  || bad "no 'origin' remote" "clone the repo with git clone <url> instead of downloading a zip"
n="$(git branch -r | grep -c 'origin/ex')"
[ "$n" -gt 0 ] && ok "exercise branches downloaded ($n)" \
  || bad "no exercise branches found" "run: git fetch origin"
finish tools/doctor.sh
