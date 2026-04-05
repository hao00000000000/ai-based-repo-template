# Playbook: Multi-Agent Coordination

## Purpose

Define how multiple AI agent roles collaborate on a single task, including pipeline setup, handoff mechanics, context sharing, and failure handling.

---

## Roles in Multi-Agent Pipelines

| Role | Produces | Context model |
|---|---|---|
| architect | design, ADR, slices | reads docs + prior handoff |
| developer | code diff, tests | reads handoff + docs |
| tester | test results, findings | reads diff + docs |
| **reviewer** | review findings, GO/NO-GO | **fresh context only** — Review Brief, no implementation history |

The reviewer role is always a separate agent with an isolated context window. It is never the same agent that implemented the task.

---

## When to Use Multi-Agent

Use a multi-agent pipeline when a task requires decisions that belong to different roles:

| Trigger | Suggested Pipeline |
|---|---|
| New feature with non-trivial design | architect → developer → tester → **reviewer** |
| Bugfix with unclear root cause | tester (repro) → developer (fix) → tester (verify) → **reviewer** |
| Refactor affecting architecture | architect (design) → developer (impl) → tester (regression) → **reviewer** |
| Research informing next feature | architect (research) → architect (spec) → developer |
| Adding test coverage after delivery | tester → **reviewer** |
| Stand-alone PR review | **reviewer** only |

Single-role tasks with no code output do not need a reviewer.

---

## Task Spec for Multi-Agent Tasks

Add a `pipeline` block to the task spec:

```markdown
## Pipeline

primary_role: architect
stages:
  - role: architect
    goal: produce design decision and ADR
    output: ADR draft, implementation slices, risk register
  - role: developer
    goal: implement per architect spec
    output: code diff, test evidence
  - role: tester
    goal: verify acceptance criteria and produce go/no-go
    output: test matrix, findings, recommendation
```

Each stage must complete and produce its handoff payload before the next stage starts.

---

## Context Header in Multi-Agent Tasks

Each agent response must declare both its role and the pipeline stage it belongs to:

```
---
role: developer
stage: execute
task: feature_health-check
pipeline_stage: 2/3
cycle: 1
---
```

`pipeline_stage: 2/3` means "this is stage 2 of a 3-stage pipeline".

---

## Handoff Payload (Required Between Stages)

Every stage must produce a handoff payload before passing to the next role.

```markdown
## Handoff: architect → developer

- task: feature_health-check
- scope: implement /health-check endpoint returning 200/500 based on runtime freshness
- out-of-scope: metrics pipeline, service discovery
- assumptions:
  - runtime timestamp updated by orchestration loop on each cycle
  - threshold is configurable via env var
- files reviewed: docs/ARCHITECTURE.md, docs/TECH.md
- decisions made: ADR-NNN created, freshness threshold = 60s default
- risks: stale timestamp on first boot may return false 500
- next action: developer executes implementation per ADR-NNN
- owner: developer
```

---

## Pattern A: Sequential Pipeline with Review (Standard)

```
architect → developer → tester → reviewer
```

Steps:

1. **architect** (`intake` → `plan`):
   - loads all docs
   - produces design spec, ADR if needed, implementation slices
   - declares assumptions explicitly
   - produces handoff payload → developer

2. **developer** (`context-load` → `execute` → `doc-sync`):
   - reads handoff payload + all docs
   - implements minimal diff per architect spec
   - runs `make check`
   - **prepares Review Brief** (diff + test results + doc-sync status + known risks)
   - produces handoff payload → tester

3. **tester** (`context-load` → `validate`):
   - reads handoff payload + code diff
   - runs tests, checks acceptance criteria
   - appends test matrix to Review Brief
   - produces handoff → reviewer

4. **reviewer** (`review` — fresh context, spawned via Agent tool):
   - receives only the Review Brief — no implementation conversation
   - applies `shared/code_review.md` across all 7 lenses
   - produces: Blockers / Suggestions / Notes + GO / NO-GO
   - if NO-GO → returns to developer with Blockers; developer fixes and re-submits Review Brief
   - if GO → task proceeds to `report` + `done`

5. Main agent writes `docs/logs/` entry including review findings.

---

## Pattern B: Parallel Review Before Implementation

Used when risk is high or the design has multiple valid options.

```
architect + tester → developer
```

Steps:

1. **architect** produces design options (not a final decision yet)
2. **tester** reviews options for testability and risk surface
3. **architect** finalizes design incorporating tester feedback
4. **developer** implements

In task spec:

```markdown
stages:
  - role: architect
    goal: produce 2+ design options with trade-offs
  - role: tester
    goal: review options for testability
  - role: architect
    goal: finalize design, produce ADR
  - role: developer
    goal: implement
  - role: tester
    goal: verify
```

---

## Pattern C: Tester-Led Repro (Bugfix)

```
tester (repro) → developer (fix) → tester (verify)
```

Steps:

1. **tester**: reproduce the bug, write a failing test, document exact failure
2. **developer**: fix the bug, make the failing test pass
3. **tester**: verify fix, run regression suite, produce go/no-go

Handoff from tester stage 1 must include:
- exact repro steps
- failing test file and command
- suspected root cause (hypothesis only)

---

## Failure and Recovery in Pipelines

If a stage fails or produces an incomplete handoff:

- do not proceed to the next stage
- mark the stage as `blocked` in the task spec
- produce an escalation payload (see `AGENTS.md` Escalation Rules)
- the next session picks up from the blocked stage, not from scratch

Each stage is restartable independently, provided the handoff payload from the prior stage is available.

---

## Pattern D: Reviewer as Standalone Subagent

For any existing PR or completed task that needs a review without a full pipeline:

```python
# Main agent at review step:
Agent(
    description="Code review for <task-id>",
    prompt="""
You are acting as the Reviewer role defined in ai/roles/reviewer.md.
Your context is ONLY what is in the Review Brief below.
Do not reference any prior conversation.
Apply ai/skills/shared/code_review.md.
Produce the mandatory output format from ai/roles/reviewer.md.

## Review Brief

task_id: <id>
task_type: <type>
primary_role_that_executed: <role>

### Task Spec Summary
<acceptance criteria>

### Diff or Changed Files
<full diff>

### Test Results
<make check output>

### Doc-Sync Status
<what was updated>

### Known Risks (from executor)
<list>
"""
)
```

The reviewer subagent:
- has no access to the implementation session
- cannot ask clarifying questions (the Brief must be complete)
- produces its output which the main agent receives and acts on

---

## NO-GO Loop

When reviewer returns NO-GO:

```
developer (fix Blockers, cycle+1)
  → prepares new Review Brief
  → spawns reviewer again (fresh context, same role)
  → reviewer re-reviews full diff (not just the delta)
```

Re-review always covers the full diff, not just the changes since last review. This prevents Blockers being fixed while new issues are introduced elsewhere.

Maximum re-review cycles: 3. After 3 NO-GOs, escalate to architect.

---

## Idempotency in Multi-Agent Tasks

Each stage must be independently re-runnable:

- architect stage: re-reading docs + prior handoff produces the same design
- developer stage: re-reading handoff + code produces the same diff
- tester stage: re-running tests on same code produces the same results
- reviewer stage: same Review Brief → same findings (deterministic, no conversation dependency)

Do not introduce stage-local state that is not in the handoff payload or docs.
