# Docs Task Example

## Task Type

`docs`

## Context

Core domain state transitions are implemented in code but not fully represented in domain docs.

## Goal

Update `docs/DOMAIN.md` with an explicit transition map for key entity statuses.

## In Scope

- add transition tables and examples
- include unsupported/NotImplemented branches as explicit gaps

## Out of Scope

- code behavior changes
- introducing new statuses

## Acceptance Criteria

1. Transition mapping is complete for currently implemented states.
2. Gaps are explicitly called out as open questions or TODO risks.
3. Docs align with current code paths.

## Required Checks

- cross-check docs against relevant implementation modules
- reviewer verification of consistency

## Expected Artifacts

- doc diff
- inconsistency list (if found)

## Final Report Format (Mandatory)

- `Summary`
- `Validation`
- `Risks`
- `Follow-ups`

## Risks and Escalation

- If code and docs conflict on a critical invariant, escalate immediately.
