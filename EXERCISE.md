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
