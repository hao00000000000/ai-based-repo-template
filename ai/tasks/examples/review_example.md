# Review Task Example

## Task Type

`review`

## Primary Role

`reviewer`

## Context

The `feature/health-check` task was implemented by the developer role and passed local validation (`make check`). Before merging to main, a reviewer with fresh context must evaluate the diff for correctness, design, coverage, and doc-sync.

## Goal

Produce a structured review with classified findings (Blocker / Suggestion / Note) and a GO / NO-GO recommendation. Reviewer must not have had access to the implementation conversation.

## Review Brief (prepared by executor before spawning reviewer)

```markdown
task_id: feature_health-check
task_type: feature
primary_role_that_executed: developer

### Task Spec Summary

Goal: health-check endpoint returns 200 when loop is fresh, 500 when stale.
Acceptance criteria:
1. GET /health-check returns 200 when last loop timestamp < 60s ago
2. GET /health-check returns 500 when last loop timestamp >= 60s ago
3. Threshold is configurable via HEALTH_CHECK_THRESHOLD_SECONDS env var
4. Behavior documented in docs/TECH.md

### Diff or Changed Files

[paste full diff here]

### Test Results

make check output:
  ruff: passed
  mypy: passed
  pytest: 12 passed, 0 failed

### Doc-Sync Status

docs/TECH.md updated: added HEALTH_CHECK_THRESHOLD_SECONDS env var description

### Known Risks (from executor)

- On first boot, loop timestamp is None — returns 500 until first cycle completes
```

## In Scope

- correctness of the 200/500 logic against acceptance criteria
- test coverage (happy path, stale case, first-boot None case)
- security surface of the new endpoint (auth? rate limiting?)
- doc-sync completeness
- design (is the threshold in the right place? coupling to loop state?)

## Out of Scope

- re-implementing the feature
- reviewing unrelated files not in the diff
- style nitpicks not affecting correctness or maintainability

## Acceptance Criteria

1. All Blockers are identified with file + line and suggested fix.
2. GO is issued only if no Blockers remain.
3. NO-GO includes explicit next action and owner.
4. Security checklist applied (endpoint auth requirements checked).
5. Coverage assessment covers: happy path, stale path, first-boot None case.

## Required Checks

- reviewer reads `ai/skills/shared/code_review.md` before reviewing
- reviewer does not reference implementation conversation — only the Review Brief

## Expected Artifacts

- review output in mandatory format from `ai/roles/reviewer.md`
- findings recorded in `docs/logs/` entry

## Final Report Format (Mandatory)

- `Summary`
- `Validation`
- `Risks`
- `Follow-ups`

## Risks and Escalation

- If diff is incomplete or Review Brief is missing sections: return to executor, do not guess.
- If a Blocker requires architectural decision: escalate to architect with explicit question.
- If NO-GO: executor fixes Blockers, increments cycle, re-submits Review Brief.
