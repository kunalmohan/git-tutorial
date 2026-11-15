#!/usr/bin/env bash
# Builds (or rebuilds) the exercise branches in THIS repo.
#
#   tools/build-exercises.sh            # build every exercise that has a tools/exN.sh
#   tools/build-exercises.sh ex1 ex3    # only these
#
# Each exercise is built in a temporary repo and then force-fetched into this
# one as branches named exN/<role>. Output is deterministic (fixed author and
# timestamps), so rebuilding an unchanged exercise changes nothing.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
source "$HERE/lib.sh"

current="$(git -C "$ROOT" symbolic-ref --short -q HEAD || true)"
case "$current" in
  ex[0-9]*/*) echo "You are on $current. Switch to main first: git switch main"; exit 1 ;;
esac

if [ "$#" -gt 0 ]; then list=("$@"); else list=(); for f in "$HERE"/ex[0-9]*.sh; do list+=("$(basename "$f" .sh)"); done; fi

for ex in "${list[@]}"; do
  tmp="$(mktemp -d)"
  (
    cd "$tmp"
    git init -q -b main .
    git config core.autocrlf false
    start_exercise "$ex"
    source "$HERE/$ex.sh"
    build
  )
  git -C "$ROOT" fetch -q --force --no-tags "$tmp" "refs/heads/$ex/*:refs/heads/$ex/*"
  rm -rf "$tmp"
  echo "built $ex: $(git -C "$ROOT" branch --list "$ex/*" | tr -d ' *' | tr '\n' ' ')"
done
