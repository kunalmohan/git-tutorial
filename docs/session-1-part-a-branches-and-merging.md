# Session 1 · Part A — How Git really works: commits, branches, merging

🧪 Exercise 1 (Python) · Prerequisite: [setup](00-setup.md)

**By the end you can:**
explain what a commit and a branch *really are* · create, switch and delete branches ·
predict whether a merge will fast-forward or create a merge commit · read `git log --graph`.

**Agenda**

- Welcome, goals, setup check
- Mental model: commits, branches, HEAD
- Branch commands
- Merging: fast-forward vs merge commit
- 🧪 **Exercise 1**
- Recap and questions

---

## 0. Welcome

- You already know `add`, `commit`, `push`. Today we look *under* those commands, because every advanced
  topic (rebase, conflicts, undo) is easy once the model in your head is right.
- Quick check: `tools/doctor.sh` should be all green.

## 1. The mental model

Three ideas. Everything else is built from them.

### Idea 1: a commit is a snapshot that points to its parent

A commit is **not** a diff. It is a snapshot of the whole project, plus an author, a message, and a link to the commit
that came before it (its *parent*). Each commit has an ID (a hash such as `3f2a9c1`).

```
A---B---C---D        (time flows left → right; each commit points back at its parent)
```

### Idea 2: a branch is just a movable label on a commit

A branch is a tiny file containing one commit ID. Nothing is copied when you create one, so branches are free.
When you commit, the *current* branch's label moves forward to the new commit.

```
A---B---C   main
```

```
git branch feature          git switch feature, then commit twice

A---B---C   main, feature   A---B---C   main
                                     \
                                      D---E   feature
```

### Idea 3: HEAD is "you are here"

`HEAD` says which branch you're on. A commit goes to whatever HEAD points at.

```
A---B---C   main
         \
          D---E   feature  ← HEAD (you are here)
```

### 👀 See it for yourself (live demo)

```bash
git switch ex1/main && ./setup.sh

cat .git/HEAD                     # ref: refs/heads/ex1/main
cat .git/refs/heads/ex1/main      # one commit ID. That is all a branch is.
git cat-file -p HEAD              # the commit itself: tree (snapshot), parent, author, message
git log --oneline --graph         # the history
```

## 2. Branch commands

| I want to… | Command |
|---|---|
| see my branches | `git branch` (`-vv` adds the commit and upstream) |
| create a branch and move to it | `git switch -c my-feature` |
| move to an existing branch | `git switch my-feature` (`git switch -` = back to the previous one) |
| delete a merged branch | `git branch -d my-feature` |
| see the shape of history | `git log --oneline --graph --decorate` |

> `git switch` is the modern replacement for the overloaded `git checkout` (you'll still see `checkout` in
> older tutorials). In this course, whenever we say `git graph` we mean the `log --graph` line above, limited to the
> current exercise. `setup.sh` creates that shortcut for you.

## 3. Merging

`git merge X` means: **"bring the commits of X into the branch I'm standing on."**
You merge *into* the current branch: `git switch main` then `git merge feature`.

There are exactly two shapes it can take. Which one you get depends on one question:
**has the branch you're merging *into* moved since the other branch split off?**

### Case 1 — Fast-forward (no, it hasn't moved)

```
before:
          D---E   feature
         /
A---B---C         main  ← HEAD

after `git merge feature`:
A---B---C---D---E   main, feature
```

Nothing to combine, so Git just slides the `main` label forward. No new commit.

### Case 2 — Merge commit (yes, both have moved)

```
before:
          D---E       feature
         /
A---B---C---F         main  ← HEAD

after `git merge feature`:
          D---E
         /     \
A---B---C---F---M     main  (M = merge commit with two parents)
```

Git finds the **merge base** (the last shared commit, `C`), compares each side against it, combines both sets of
changes, and records the result as a new commit `M` with **two parents**. If both sides changed *the same lines*,
Git can't decide for you. That's a **conflict**, and it's the main topic of Session 2.

### Handy extras

| Command | Meaning |
|---|---|
| `git merge --no-ff feature` | always create a merge commit, even if a fast-forward was possible (keeps the "this was a feature branch" shape) |
| `git merge --ff-only feature` | only merge if it's a fast-forward, otherwise refuse |
| `git merge --abort` | I changed my mind (only while a merge is in progress) |

## 4. 🧪 Exercise 1

```bash
git switch ex1/main && ./setup.sh
cat EXERCISE.md
```

You merge two feature branches into `ex1/main`, one will fast-forward, the other won't. The habit to build:
**predict first, then run, then compare** with `git graph`.

## 5. Recap

- A **commit** = snapshot + parent link. A **branch** = a label that moves when you commit. **HEAD** = where you are.
- **Fast-forward** when the target hasn't moved; **merge commit** when both sides moved.
- Deleting a merged branch only removes the label; the commits stay.

**Quick questions to check understanding** (answers hidden):

<details><summary>1. I'm on <code>main</code>, run <code>git switch -c fix</code>, make 2 commits. Where is <code>main</code>?</summary>
Still on the commit it was on. Only <code>fix</code> moved.
</details>

<details><summary>2. When is a merge a fast-forward?</summary>
When the branch you merge <em>into</em> has no commits that the other branch doesn't have, i.e. it is a direct ancestor.
</details>

<details><summary>3. Does <code>git branch -d</code> delete commits?</summary>
No. It removes the label. Commits not reachable from any label are only cleaned up much later (this is why recovery
is possible. We'll use it in Session 2).
</details>

➡️ **Next:** Part B: *rebase*, the other way to combine work, and how to tidy your commits before sharing them.
