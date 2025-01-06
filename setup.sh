#!/usr/bin/env bash
# Creates (or resets) every branch of this exercise to its starting state.
# Safe to run again whenever you want a fresh start.
set -e
PREFIX="ex1"
cd "$(git rev-parse --show-toplevel)"
GITDIR="$(git rev-parse --git-dir)"

if [ -f "$GITDIR/MERGE_HEAD" ] || [ -d "$GITDIR/rebase-merge" ] || [ -d "$GITDIR/rebase-apply" ] || [ -f "$GITDIR/CHERRY_PICK_HEAD" ]; then
  echo "A merge / rebase / cherry-pick is still in progress."
  echo "Finish it, or cancel it with: git merge --abort | git rebase --abort | git cherry-pick --abort"
  exit 1
fi
if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
  echo "You have uncommitted changes, and resetting would throw them away."
  echo "Discard them with 'git restore .' (or keep them with 'git stash'), then run ./setup.sh again."
  exit 1
fi

git fetch --quiet origin 2>/dev/null || echo "(couldn't reach 'origin' - using what is already downloaded)"
git checkout --detach --quiet

count=0
for ref in $(git for-each-ref --format='%(refname:short)' "refs/remotes/origin/$PREFIX/"); do
  branch="${ref#origin/}"
  git branch --quiet -f "$branch" "$ref"
  git branch --quiet --set-upstream-to="$ref" "$branch" >/dev/null 2>&1 || true
  count=$((count + 1))
done
git switch --quiet "$PREFIX/main"

# 'git graph' = the commit graph of just this exercise's branches (and HEAD)
git config alias.graph "log --graph --oneline --decorate --decorate-refs=refs/heads/$PREFIX/* --decorate-refs=HEAD --branches=$PREFIX/* HEAD"

echo "✔ $count branches ready ($PREFIX/*). You are on $PREFIX/main."
echo "  Try:  git graph      (and read EXERCISE.md)"
