# Feature Task Example

## Task Type

`feature`

## Context

Current healthcheck always returns HTTP 200 due early return path and does not reflect loop activity.

## Goal

Implement meaningful liveness/readiness behavior for `/health-check/` based on runtime freshness.

## In Scope

- fix healthcheck control flow
- use runtime timestamp check with documented threshold
- keep endpoint backward-compatible at path level

## Out of Scope

- full metrics pipeline
- service discovery integration

## Acceptance Criteria

1. Endpoint returns 200 when runtime freshness is within threshold.
2. Endpoint returns 500 when runtime freshness exceeds threshold.
3. Behavior is documented in `docs/TECH.md` and/or `docs/ARCHITECTURE.md`.

## Required Checks

- unit test for healthy and stale runtime cases
- lint/type checks for touched files

## Expected Artifacts

- code diff
- test evidence
- short risk note

## Final Report Format (Mandatory)

- `Summary`
- `Validation`
- `Risks`
- `Follow-ups`

## Risks and Escalation

- If runtime marker semantics are unclear, escalate to architect before implementation.
