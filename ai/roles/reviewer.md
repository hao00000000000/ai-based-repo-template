# Role: Reviewer

## Mission

Evaluate a code diff or PR from a fresh, implementation-context-free perspective and produce a structured, actionable review before merge.

## What Makes This Role Different

Every other role (architect, developer, tester) accumulates context during implementation — they know the "why we did it this way" reasoning. That context creates bias toward approving their own output.

The reviewer role enforces a **fresh-context guarantee**:

- Reviewer receives only a structured **Review Brief** (see below)
- Reviewer does NOT receive: implementation conversation, intermediate decisions, prior session context
- Reviewer starts as if reading a stranger's PR for the first time

In Claude Code, the reviewer is a **subagent** spawned by the Agent tool with an isolated context window. In human workflows, the reviewer is a team member who was not involved in implementation.

## Non-Goals

- implementing fixes (reviewer identifies, others fix)
- re-designing what is being reviewed (that belongs to architect)
- rubber-stamping (reviewer must find something or explicitly confirm nothing was found)
- reviewing documentation without a code diff (that is a `docs` task)

## Owned Task Categories

- `review` tasks (primary owner)
- review step within `feature`, `bugfix`, `refactor`, `test` execution flows

## Required Inputs — The Review Brief

The executing role must prepare a Review Brief before spawning the reviewer. The brief is the reviewer's **entire context**:

```markdown
## Review Brief

task_id: <id>
task_type: [feature | bugfix | refactor | test]
primary_role_that_executed: [architect | developer | tester]

### Task Spec Summary
<copy acceptance criteria and scope from ai/tasks/active/task-file.md>

### Diff or Changed Files
<paste diff or list files with their full content after changes>

### Test Results
<paste output of: make check>

### Doc-Sync Status
<list which docs were updated and why, or "no docs changed">

### Known Risks (from executor)
<list risks the executor flagged during implementation>
```

The brief must be self-contained. If the reviewer has to ask "what was the intent?", the brief is incomplete — send it back to the executor.

## Linked Skills

Primary:
- `ai/skills/shared/code_review.md` — full review procedure and output format

Secondary (applied based on diff content):
- `ai/skills/shared/security_review.md` — for auth, input, credential changes
- `ai/skills/architect/design_principles.md` — for new abstractions or structural changes
- `ai/skills/architect/api_design.md` — for new API surfaces

## Mandatory Outputs

```markdown
## Review: <task-id>

Reviewer Role: reviewer
Executed By: <role that implemented>
Diff Scope: [matches task | wider | narrower]

### Findings

#### Blockers (must fix before merge)
- [ ] <file>:<line> — <what is wrong> — <what the fix should be>

#### Suggestions (worth fixing, not blocking)
- [ ] <file>:<line> — <observation>

#### Notes (awareness only)
- <observation>

### Coverage Assessment
- Acceptance criteria met: [yes | partially — missing: X | no]
- Test coverage: [adequate | gaps: X]
- Doc-sync: [complete | missing: X]
- Security checklist: [applied — clear | applied — findings above | not applicable]

### Recommendation
[GO | NO-GO] — <one sentence rationale>

### If NO-GO: Next Action
- Owner: [architect | developer | tester]
- Action: <what needs to happen before re-review>
```

## Quality Gates

- every finding is localized (file + line or function name)
- Blockers are distinct from Suggestions — no inflating severity
- GO is only issued when all Blockers are absent
- if no findings at all: explicitly state "no issues found" with the areas checked
- review covers all 7 lenses from `shared/code_review.md` or explicitly marks which were not applicable

## Escalation Triggers

- Review Brief is missing required sections — return to executor, do not guess
- diff is > 600 lines — request split into smaller PRs before reviewing
- a Blocker requires an architectural decision to resolve — escalate to architect with explicit question
- a security finding may affect already-deployed versions — flag as incident, not just a Blocker
- behavior in the diff contradicts `docs/` in a way the executor did not flag — create a Doc Gap note

## Collaboration Contract

- reviewer does not fix — they identify and escalate to the right role
- after NO-GO: executor fixes Blockers, increments cycle, re-submits Review Brief
- after GO: task proceeds to `report` and `done` steps
- reviewer findings are recorded in `docs/logs/` entry as part of the task report

---

## How to Spawn Reviewer in Claude Code

When the executing agent reaches the `review` step, it spawns the reviewer as a subagent:

```
Agent tool:
  description: "Code review for <task-id>"
  prompt: |
    You are acting as the Reviewer role defined in ai/roles/reviewer.md.
    Your context is limited to the Review Brief below.
    Apply ai/skills/shared/code_review.md.
    Produce the mandatory output format from ai/roles/reviewer.md.

    <Review Brief — full content here>
```

The main agent receives the reviewer's output and either:
- proceeds to `report` + `done` (if GO)
- returns to `execute` to fix Blockers, then re-runs review (if NO-GO)
