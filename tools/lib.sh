#!/usr/bin/env bash
# Helpers shared by tools/ex*.sh. Source this file; don't run it.
#
# Exercise branches are built in a throw-away repo with a fixed identity and
# fake timestamps, so rebuilding them gives identical commit hashes.

TUTOR_NAME="Git Tutor"
TUTOR_EMAIL="tutor@example.com"
BASE_EPOCH=1736154000   # 2025-01-06 09:00:00 UTC
STEP=5400               # every commit is 90 minutes after the previous one
_n=0
TEMPLATES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/templates"

# who NAME  -> following commits are authored by NAME (default: the tutor)
who() {
  local name="${1:-$TUTOR_NAME}" email
  email="$(printf '%s' "$name" | tr 'A-Z ' 'a-z.')@example.com"
  export GIT_AUTHOR_NAME="$name" GIT_AUTHOR_EMAIL="$email"
  export GIT_COMMITTER_NAME="$name" GIT_COMMITTER_EMAIL="$email"
}

# put PATH < content   -> write a file (creating folders)
put() { mkdir -p "$(dirname "$1")"; cat > "$1"; }

# commit "message"  -> stage everything and commit with the next fake timestamp
commit() {
  _n=$((_n + 1))
  local ts=$((BASE_EPOCH + _n * STEP))
  git add -A
  GIT_AUTHOR_DATE="$ts +0000" GIT_COMMITTER_DATE="$ts +0000" git commit -q -m "$1"
}

# start_exercise PREFIX  -> reset the clock and author
start_exercise() { _n=0; who; }

# scaffold PREFIX  -> copy setup.sh / check.sh helpers into the working tree
# (the caller writes EXERCISE.md and check.sh itself)
scaffold() {
  local prefix="$1" extra="${2:+ $2}"
  sed -e "s|__PREFIX__|$prefix|g" -e "s|__GRAPH_EXTRA__|$extra|g" "$TEMPLATES/setup.sh" > setup.sh
  cp "$TEMPLATES/check-lib.sh" .lib.sh
  cp "$TEMPLATES/gitattributes" .gitattributes
  chmod +x setup.sh
}

# finish_check  -> make check.sh executable (call after writing it)
finish_check() { chmod +x check.sh; }
