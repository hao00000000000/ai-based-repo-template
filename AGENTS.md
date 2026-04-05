# AGENTS.md

## Purpose

This file defines the orchestration model for AI agents in this repository.

It establishes:

- global meta-rules and constraints
- decision-making model
- task routing
- execution flow
- multi-agent coordination
- project logging policy
- idempotency contract

Detailed behavior is delegated to:

- `ai/roles/` — role definitions and responsibility boundaries
- `ai/skills/` — reusable execution procedures (including design principles)
- `ai/tasks/` — task tracker and playbook examples
- `ai/playbooks/` — multi-agent and advanced orchestration patterns
- `docs/` — product/domain/architecture/tech source of truth
- `docs/logs/` — execution log archive

---

## Scope

This document defines mandatory rules for:

- all AI agents operating in this repository
- all tasks that change code, documentation, infrastructure, or runtime behavior

Out of scope:

- product-level decisions not represented in repository documentation
- organization-level policy outside this repository

---

## Global Meta-Rules

All agents must follow:

- Treat documentation as source of truth
- Never expose secrets in code, logs, or documentation
- Prefer minimal, testable changes over broad rewrites
- Escalate rather than guess when documentation is missing or contradictory
- Do not implement functionality not required by the current task

Design principles (KISS, DRY, YAGNI, SOLID) are enforced at the role and skill level:

- `ai/roles/architect.md` — owns design decisions and principle application
- `ai/skills/architect/design_principles.md` — procedure for applying principles
- `ai/skills/architect/clean_architecture.md` — boundary and layering rules
- `ai/skills/developer/design_principles.md` — developer-side principle application

---

## Documentation as Source of Truth (CRITICAL)

Before executing any task, agents MUST load:

- `docs/PRODUCT.md` → product goals and user context
- `docs/DOMAIN.md` → business logic and invariants
- `docs/ARCHITECTURE.md` → system design and constraints
- `docs/TECH.md` → stack and technical standards

Rules:

- Documentation defines intended behavior and architecture constraints.
- If two documents diverge on a behavior-critical point:
  - do not treat them as competing authorities
  - stop behavior-changing implementation
  - create a `Doc Gap` note in task output
  - propose explicit documentation sync/update
- Never silently ignore mismatches.
- If a required document is missing:
  - stop implementation changes
  - create a `Doc Gap` note in task output
  - request clarification before proceeding with behavior-changing work

---

## Decision Model

When making decisions, agents must prioritize:

1. Documentation over assumptions
2. Simplicity over flexibility
3. Correctness over speed
4. Explicitness over implicit behavior

Principle conflict resolution:

- KISS > DRY (avoid wrong abstractions)
- DRY > duplication only when abstraction is correct
- YAGNI > extensibility
- Readability > cleverness
- Explicit design > magic behavior

---

## Task Intake and Routing

Every task must be classified before execution.

Task categories:

- `feature` → implement user-visible or API-visible behavior
- `bugfix` → restore expected documented behavior
- `refactor` → improve structure without behavior change
- `docs` → update documentation only
- `research` → investigate and report, no behavior change
- `test` → add or verify test coverage for existing behavior without changing it
- `review` → evaluate a diff or PR across correctness, design, security, and doc-sync lenses

Routing rules:

- Route by primary outcome, not by implementation detail
- If multiple categories apply, split into subtasks with explicit boundaries
- If a task mixes behavior change and refactor, execute behavior change first
- If scope is ambiguous, treat as `research` and escalate
- `test` tasks are triggered after `feature`, `bugfix`, or `refactor` to verify correctness of prior changes
- `review` tasks are triggered by any PR before merge, or explicitly requested by a human or agent role

Task spec files live in `ai/tasks/`:

- `ai/tasks/active/` — in-progress tasks
- `ai/tasks/done/` — completed tasks (archived to `docs/logs/`)
- `ai/tasks/examples/` — reference templates per type

---

## Execution Flow

All tasks follow this lifecycle. The current stage must be declared in the agent's context header (see below).

1. `intake`:
   - restate goal, scope, constraints, and expected output
   - declare assigned role
2. `context-load`:
   - load required docs and relevant code paths
   - capture current state snapshot (file list, key content, test status)
3. `plan`:
   - define minimal change set and verification strategy
   - list all explicit assumptions
4. `execute`:
   - apply smallest safe set of changes
5. `doc-sync`:
   - if behavior changed: update affected docs to match
   - if docs changed: verify code still matches
   - flag any doc gaps found during execution
6. `validate`:
   - run required checks and tests (`make check`)
   - confirm acceptance criteria are met locally
7. `review`:
   - executor prepares Review Brief: diff + `make check` output + doc-sync status + known risks
   - spawn reviewer as a **separate subagent** (Agent tool) with Review Brief as sole context
   - reviewer applies `shared/code_review.md`, produces Blocker / Suggestion / Note findings
   - reviewer issues GO or NO-GO
   - if NO-GO: executor fixes Blockers (cycle+1), re-prepares Review Brief, re-spawns reviewer
   - if GO: proceed to `report`
   - max 3 NO-GO loops before escalating to architect
8. `report`:
   - summarize change, review findings, risks, and follow-ups
   - write execution log entry to `docs/logs/`
9. `done`:
   - all Blockers from review resolved
   - confirm acceptance criteria and handoff artifacts
   - move task spec from `ai/tasks/active/` to `ai/tasks/done/`

No step may be skipped for behavior-changing tasks.

`review` may be skipped only for `docs`-only and `research` tasks with no code changes.

---

## Context Window Header

Every agent response during task execution MUST begin with a status header:

```
---
role: [architect | developer | tester]
stage: [intake | context-load | plan | execute | doc-sync | validate | report | done]
task: <task-id or short name>
cycle: <N> (increment per response on same task)
---
```

Purpose: makes execution state transparent, enables seamless handoff between agents and sessions.

---

## Role Contracts

Each role in `ai/roles/` defines:

- mission and non-goals
- owned task categories
- required inputs
- mandatory outputs
- quality gates it must enforce
- escalation triggers

Role boundary rules:

- One role owns one decision at a time
- Advisory roles may propose, but not override owner decisions
- Ownership transfer requires explicit handoff payload

Roles:

- `architect` — research, docs, design decisions, feature decomposition
- `developer` — feature, bugfix, refactor, implementation
- `tester` — verification planning, test artifacts, validate step
- `reviewer` — fresh-context code review, GO/NO-GO gate before merge

The reviewer role is always a **separate agent** with an isolated context window. It receives only the Review Brief (diff + docs + test results) — never the implementation conversation. See `ai/roles/reviewer.md` for the Review Brief format and spawning instructions.

---

## Multi-Agent Coordination

For complex tasks that span multiple roles, use a declared pipeline.

Supported patterns:

- **Single-role**: one role owns the task end-to-end
- **Sequential pipeline**: `architect → developer → tester` with explicit handoffs
- **Parallel review**: architect and tester plan together before developer executes

Task spec must declare the pipeline when multi-role execution is needed:

```
primary_role: architect
pipeline:
  - architect: design + ADR
  - developer: implementation
  - tester: verification (validate step)
  - architect: code review (review step — different role from executor)
  - tester: go/no-go
```

Review step rule: the role that executes a stage must not be the sole reviewer of their own output. In single-agent sessions, the agent switches role context explicitly for the review step.

Each pipeline stage produces a handoff payload before the next stage starts.

Full patterns, examples, and coordination rules: `ai/playbooks/multi_agent.md`

---

## Handoff Protocol

Every handoff must include:

- task id or short name
- scope and out-of-scope
- assumptions (explicit list)
- files changed or reviewed
- checks executed and results
- open risks and blockers
- next expected action and owner

Handoffs without this payload are invalid.

---

## Escalation Rules

Escalate immediately when:

- documentation is missing or contradictory for behavior-changing work
- security, data integrity, or correctness invariants may be violated
- required secrets or credentials are unavailable
- test failures are unrelated but block delivery
- task requires destructive actions not explicitly requested

Escalation payload must include:

- what is blocked
- why local resolution is unsafe
- options with trade-offs
- recommended option

---

## Quality Gates and Definition of Done

A task is done only if all are true:

- behavior matches repository documentation
- scope remains minimal and explicit
- no new secrets are introduced or exposed
- for code-changing tasks: required tests/checks pass, or failures are documented with impact
- doc-sync step completed: docs reflect current behavior
- review step completed: no open Blockers, go/no-go produced
- diffs are readable and reviewable
- task report written to `docs/logs/`
- task spec moved from `active/` to `done/`

Minimum validation by category:

- `feature` / `bugfix`:
  - relevant tests pass
  - regression check on touched behavior
  - docs updated if behavior changed
- `refactor`:
  - proof of no behavior change
  - existing tests pass
- `docs`:
  - consistency check against code and other docs
- `test`:
  - new/updated tests pass
  - coverage gap addressed explicitly
- `review`:
  - all Blockers documented with location and fix
  - go/no-go recommendation produced
  - security checklist applied where relevant
- `research`:
  - findings documented with explicit assumptions and open questions

---

## Task Output Format

Final task output must contain:

- `Summary` → what changed and why
- `Validation` → checks run and outcomes
- `Risks` → known risks and mitigations
- `Follow-ups` → next tasks (if any)

This format is mandatory for all non-trivial tasks.

---

## Project Logs

Execution logs are stored in `docs/logs/`.

Policy:

- One log file per completed task or PR
- Log filename: `YYYY-MM-DD_<task-id>.md`
- Contents: task summary, roles involved, files changed, validation results, risks, follow-ups
- Maximum 10 uncompressed logs at any time
- When count exceeds 10: compress oldest 10 into one `YYYY-MM-DD_batch_summary.md` in `docs/logs/archive/`
- Log index is maintained in `docs/logs/README.md`

See `docs/logs/README.md` for full policy and log template.

---

## Idempotency Contract

The same task spec, applied to the same documentation state, must produce the same outcome regardless of which agent session executes it.

Rules:

1. **Task specs are self-contained**: no reliance on prior conversation context. All required context comes from docs and the task spec itself.
2. **State is read fresh**: agents must read current file content at task start, not assume it from memory or prior session.
3. **Assumptions are explicit**: every assumption made during planning must be listed in the task spec or output. If an assumption cannot be verified from docs or code, escalate.
4. **Desired-state operations**: express changes as target state ("file X should contain Y"), not as deltas from assumed state. This makes re-runs safe.
5. **No ambient context**: agents must not rely on implicit shared state between sessions. All context must be in docs or the task spec.
6. **Deterministic decision criteria**: when multiple valid options exist, pick based on the decision model priority order. Document the choice explicitly.

Idempotency applies to: task planning, code changes, doc updates, and log entries.
