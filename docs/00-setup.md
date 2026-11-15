# Setup (before Session 1)

You need **Git 2.23+** and a terminal. On Windows use **Git Bash** (installed with Git for Windows); see the [Windows notes](#windows-notes) below.
Python 3 is recommended (a few exercise checks use it) but nothing else is required, even though some exercises
contain C, C# and SQL: you only read that code, you never build it.

## 1. Tell Git who you are

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
```

## 2. Pick an editor Git can open

Git opens an editor for commit messages and for interactive rebase. Use one you're comfortable with:

```bash
git config --global core.editor "code --wait"      # VS Code
# git config --global core.editor "nano"           # simplest terminal editor
```

> Stuck in **vim**? Press `Esc`, then type `:wq` + Enter to save and quit, or `:q!` + Enter to quit without saving.

## 3. Get the course repository

```bash
git clone <TUTORIAL_REPO_URL> git-tutorial
cd git-tutorial
tools/doctor.sh          # checks everything above and tells you what to fix
```

## Windows notes

Everything in this course works in **Git Bash**, the terminal that comes with [Git for Windows](https://git-scm.com/download/win).
Open it from the Start menu, or right-click a folder → **Open Git Bash here**. (WSL works too; keep the repo in your Linux home
folder, not under `/mnt/c`.) Don't use PowerShell or cmd for the `./setup.sh` / `./check.sh` scripts.

- **Python:** install it from [python.org](https://www.python.org/downloads/) (tick *Add python.exe to PATH*). In Git Bash the
  command is `python` (or `py`), **not** `python3`. Wherever a lesson says `python3`, type `python`. The automatic checks find
  the right one by themselves.
- **Line endings:** nothing to do. The repo forces LF line endings on its scripts, so Git for Windows' default
  `core.autocrlf=true` is fine.
- **Editor:** `git config --global core.editor "code --wait"` (VS Code) or `git config --global core.editor notepad`.
- `tools/doctor.sh` recognises Git Bash and WSL and warns about the common problems.

## How this repo is organised

- **`main`** = the lessons (these Markdown files). Read them on GitHub or in your editor's Markdown preview.
- **`ex1/…`, `ex2/…`, …** = the exercises. Each exercise is a small project on its *own set of branches* with its own
  `EXERCISE.md`. When you `git switch` to one, the lesson files disappear from your folder and the exercise appears.
  Switch back with `git switch main`.

Start an exercise with:

```bash
git switch ex1/main      # Git creates the branch from the downloaded copy
./setup.sh               # creates/reset all branches of that exercise
cat EXERCISE.md          # the task
./check.sh               # tells you if you got it right
```
