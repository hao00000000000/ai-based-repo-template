# Skill: Shared / Code Review

## Purpose

Evaluate a code diff or PR from multiple lenses — correctness, design, security, testability, and documentation consistency — and produce actionable findings before merge.

## When to Use

- any PR before it is merged to main
- after `validate` step in the execution flow (formal review gate)
- when a human reviewer requests agent-assisted review
- when reviewing output from another agent role

## Who Runs This

Any role may execute a code review, but each focuses on their primary lens:

| Role | Primary Review Lens |
|---|---|
| Architect | design boundaries, ADR compliance, YAGNI, abstraction correctness |
| Developer | implementation correctness, readability, edge cases, error handling |
| Tester | test coverage, scenario completeness, failure path handling |

All roles apply security review checklist (`shared/security_review.md`) for sensitive changes.

## Required Inputs

- the code diff (PR or patch)
- task spec from `ai/tasks/` (what was the intent?)
- `docs/PRODUCT.md`, `docs/DOMAIN.md`, `docs/ARCHITECTURE.md`, `docs/TECH.md`
- existing tests that cover the touched paths
- handoff payload from the executing role (if multi-agent pipeline)

## Procedure

### 1. Orient (before reading the diff)

1. Read the task spec. Understand **what was supposed to change** and **why**.
2. Read the PR description. Confirm it matches the task spec.
3. Note the files changed. Before diving in, ask: does the scope of changed files match the task scope?
   - More files than expected → risk of unintended side effects
   - Fewer files than expected → risk of incomplete implementation

### 2. Correctness Review

4. For each changed function or method:
   - Does it do what the task spec says it should?
   - Are all acceptance criteria from the task spec satisfied?
   - Are edge cases handled (empty input, zero, nil, max values, concurrent calls)?
   - Are error paths explicit and handled (not silently swallowed)?
5. Verify control flow: trace the happy path and at least one failure path manually.
6. Check for off-by-one errors, type coercions, and implicit assumptions about input shape.

### 3. Design Review (Architect lens)

7. Does the diff respect existing module boundaries from `docs/ARCHITECTURE.md`?
8. Are new abstractions justified? (YAGNI — do they serve the current task or a hypothetical future?)
9. Do new interfaces match the domain language from `docs/DOMAIN.md`?
10. If the change is architecture-impacting: is there an ADR? Is the ADR referenced?
11. Does the change introduce coupling that wasn't there before? Is it necessary?

### 4. Readability and Maintainability

12. Can a developer unfamiliar with this code understand the change in < 5 minutes?
13. Are variable and function names meaningful and consistent with the codebase vocabulary?
14. Are comments present where intent is non-obvious? Are they accurate (not stale)?
15. Is there dead code, commented-out blocks, or debug statements left in?
16. Is duplication introduced? If yes, is it justified (KISS > DRY for non-stable patterns)?

### 5. Test Coverage Review (Tester lens)

17. Do new tests exist for the new behavior?
18. Do tests cover: happy path, at least one edge case, at least one failure path?
19. Are test names descriptive of the scenario being verified?
20. Are tests deterministic (no time-dependent, random, or environment-dependent assertions)?
21. Do existing tests still pass after the change?
22. Is there behavior that is not covered by any test? If yes, is the gap documented?

### 6. Security Review

23. Apply checklist from `shared/security_review.md` for any change that touches:
    - input handling, auth, credentials, external calls, DB queries, file paths

### 7. Documentation Consistency

24. If behavior changed: are `docs/PRODUCT.md`, `docs/DOMAIN.md`, `docs/ARCHITECTURE.md`, or `docs/TECH.md` updated?
25. If a new public API is added: is it documented?
26. If a domain invariant is affected: is `docs/DOMAIN.md` updated?
27. If a new environment variable is added: is it in `docs/TECH.md`?

### 8. Produce Findings

28. Classify each finding:
    - **Blocker** — must be fixed before merge (correctness bug, security issue, broken test, doc gap on behavior-critical change)
    - **Suggestion** — improvement worth making but not blocking
    - **Note** — observation for awareness, no action required
29. For each Blocker: describe the problem, where it is, and what the fix should be.
30. Produce a go/no-go recommendation.

## Validation Checklist

- task spec acceptance criteria verified against the diff
- edge cases and failure paths traced manually for critical paths
- no dead code, debug prints, or hardcoded secrets
- tests cover new behavior (happy path + failure path minimum)
- doc-sync completed: docs match the changed behavior
- security checklist applied if relevant
- all Blockers documented with location and fix description

## Output Format

```
## Review: <task-id>

Reviewer Role: [architect | developer | tester]
Diff: <PR link or file list>

### Orientation
- Task scope vs diff scope: [matches | wider | narrower]
- PR description vs task spec: [consistent | diverges on: ...]

### Findings

#### Blockers
- [ ] <file>:<line> — <description> — <suggested fix>

#### Suggestions
- [ ] <file>:<line> — <description>

#### Notes
- <observation>

### Coverage
- Acceptance criteria met: [yes | partially | no]
- Test coverage: [adequate | gaps: ...]
- Doc-sync: [complete | missing: ...]

### Recommendation
[GO | NO-GO] — <one sentence rationale>
```

## Escalation Conditions

- a Blocker cannot be resolved without architectural decision (escalate to architect)
- a security vulnerability is found that may affect deployed versions (incident response)
- the diff is too large to review meaningfully (> 600 lines) — request split into smaller PRs
- task spec is missing or does not match what was implemented — stop review, align task spec first
