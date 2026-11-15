# Git & GitHub, hands-on: from basics to team workflows

Three focused sessions for someone who already knows `add`, `commit`, `push` and wants to work like a professional:
branching, merging, rebasing, conflicts, undo/recovery, and pull requests.

## The plan

| Session | Topics | Exercises |
|---|---|---|
| **1 · Branching, merging & rebase** | How Git really works · branches · fast-forward vs merge commits · rebase vs merge · interactive rebase · the golden rule | 🧪 Ex 1 · merge (Python)<br>🧪 Ex 2 · rebase (C) |
| **2 · Conflicts, undo & recovery** | | |
| **3 · Pull requests & team workflow** | | |

Lessons (read in order):

1. [Setup, before Session 1](docs/00-setup.md)
2. Session 1 · Branching, merging & rebase: [Part A · How Git really works](docs/session-1-part-a-branches-and-merging.md)

## How this repository works

- **`main`** holds the lessons (the Markdown files in `docs/`).
- **Exercises live on their own branches** (`ex1/…`, `ex2/…`). Each exercise is a tiny self-contained project with its own
  `EXERCISE.md`, a `setup.sh`, and a `check.sh` that tells you whether you solved it. Think of `main` as the textbook and
  the `exN/` branches as separate lab repos that happen to share one clone.

```bash
git clone <TUTORIAL_REPO_URL> git-tutorial && cd git-tutorial
tools/doctor.sh                  # is my computer ready?

git switch ex1/main              # enter exercise 1
./setup.sh                       # (re)creates all the exercise's branches in their starting state
cat EXERCISE.md                  # the task
git graph                        # tidy commit graph of this exercise only
./check.sh                       # am I done?

git switch main                  # back to the lessons
```

Made a mess? `./setup.sh` resets the whole exercise (it refuses to run if you have uncommitted work, so it can't hurt you).

🪟 **Windows:** run everything in **Git Bash**; see the [Windows notes](docs/00-setup.md#windows-notes).
