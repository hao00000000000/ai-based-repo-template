# CLAUDE.md

## Purpose

This file is the primary entry point for Claude Code in this repository.
It establishes mandatory context, constraints, and workflow rules for all AI-assisted work.

---

## Before Any Task

Always load and read:

- `docs/PRODUCT.md` — what the product is, who it serves, what it must deliver
- `docs/DOMAIN.md` — business concepts, entities, states, invariants
- `docs/ARCHITECTURE.md` — system design, component boundaries, constraints
- `docs/TECH.md` — stack, standards, tooling, local development workflow

These four documents are the source of truth. If code conflicts with them, the docs win until explicitly updated.

---

## Orchestration Model

The full agent orchestration model is defined in `AGENTS.md`.

Repository structure:

- `ai/roles/` — responsibility boundaries per role (architect, developer, tester)
- `ai/skills/` — reusable execution procedures
- `ai/tasks/` — task tracker: `active/`, `done/`, `examples/`
- `ai/playbooks/` — multi-agent coordination patterns
- `docs/logs/` — execution log archive (max 10 uncompressed)

---

## Execution Flow

Every task follows this lifecycle (declare current stage in context header):

```
intake → context-load → plan → execute → doc-sync → validate → review → report → done
```

- **doc-sync**: after code changes update docs; after doc changes verify code
- **review**: apply `shared/code_review.md` — classify Blockers/Suggestions/Notes, produce go/no-go
  - skipped only for `docs`-only and `research` tasks with no code changes
  - in single-agent sessions: switch role context explicitly for the review step
- **context header** is mandatory in every response during task execution:

```
---
role: [architect | developer | tester]
stage: [intake | context-load | plan | execute | doc-sync | validate | review | report | done]
task: <task-id>
cycle: <N>
---
```

---

## Global Rules

- Never expose secrets in code, logs, or documentation.
- Treat documentation as source of truth.
- Prefer minimal, testable changes over broad rewrites.
- Escalate rather than guess when documentation is missing or contradictory.
- Do not implement functionality not required by the current task.
- Every completed task produces a log entry in `docs/logs/`.
- Task specs live in `ai/tasks/active/` during work, move to `ai/tasks/done/` on completion.
- Task types: `feature`, `bugfix`, `refactor`, `docs`, `research`, `test`, `review`.

---

## Quality Gates

A task is complete only when:

- behavior matches documentation
- doc-sync step completed
- review step completed: no open Blockers, go/no-go produced
- no new secrets are introduced or exposed
- for code changes: required tests and checks pass (`make check`)
- task spec moved from `active/` to `done/`
- task output written to `docs/logs/`
- output includes: Summary, Validation, Review Findings, Risks, Follow-ups
