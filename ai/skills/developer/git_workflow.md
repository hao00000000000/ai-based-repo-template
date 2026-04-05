# Skill: Developer / Git Workflow

## Purpose

Apply consistent, reviewable git practices: branching strategy, commit discipline, PR preparation, and merge hygiene.

## When to Use

- starting work on any task from `ai/tasks/active/`
- preparing a pull request for review
- resolving merge conflicts
- reviewing git history to understand prior decisions

## Required Inputs

- task spec from `ai/tasks/active/`
- current branch state (`git status`, `git log`)
- project branching conventions (check `docs/TECH.md`)

## Procedure

### Starting a Task

1. Start from the latest `main` (or `develop` if the project uses gitflow):
   ```
   git checkout main && git pull
   ```
2. Create a branch named after the task type and short name:
   ```
   <type>/<short-name>
   ```
   Examples: `feature/health-check`, `bugfix/nonce-drift`, `refactor/action-runner`
3. One branch = one task. Do not mix unrelated changes on a single branch.

### Commit Discipline

4. Commit at logical checkpoints — not after every file save, not one giant commit at the end.
5. Each commit must pass: lint + type check (at minimum). Never commit broken state.
6. Commit message format:
   ```
   <type>: <short imperative description>

   [optional body: why this change, not what — the diff shows what]
   [optional: refs task id]
   ```
   Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`
   Example: `feat: return 500 from health-check when loop is stale`

7. Do not commit:
   - secrets, tokens, `.env` files
   - generated files that belong in `.gitignore`
   - debug prints or commented-out code blocks
   - unrelated changes (even small cleanups — open a separate task)

### Preparing a Pull Request

8. Rebase on latest `main` before opening PR to keep history linear:
   ```
   git fetch origin && git rebase origin/main
   ```
9. Squash noisy WIP commits into logical units if needed.
10. PR title follows the same format as commit messages.
11. PR description must include:
    - **What**: one-paragraph summary of the change
    - **Why**: link to task spec in `ai/tasks/done/` or `active/`
    - **Testing**: what was run and what passed
    - **Risks**: anything the reviewer should watch
    - **Log entry**: link or inline the `docs/logs/` entry

12. Keep PRs small. If a PR touches > 400 lines, split it unless the change is atomic.

### Merge and Cleanup

13. Merge strategy follows `docs/TECH.md`. Default preference: squash merge for features, merge commit for long-lived branches.
14. Delete branch after merge.
15. Move task spec from `ai/tasks/active/` to `ai/tasks/done/`.

## Validation Checklist

- branch name matches task type and name
- no secrets or debug artifacts in commits
- each commit passes baseline checks
- PR description covers: what, why, testing, risks
- rebased on latest main before review request
- branch deleted after merge

## Output Format

- `Branch Name`
- `Commit Log` (list of commit messages)
- `PR Description Draft`
- `Merge Readiness` — what's blocking or cleared

## Escalation Conditions

- merge conflict involves behavior-critical files (`docs/`, core domain logic) — do not auto-resolve
- rebase produces unexpected divergence — stop and inspect before continuing
- prior commit history is missing context that affects current task decisions
