# Bugfix Task Example

## Task Type

`bugfix`

## Context

Retry logic in the external service client does not correctly reset state after a failed request, causing subsequent retries to fail with stale context.

## Goal

Fix retry state reset behavior to keep retries safe and deterministic.

## In Scope

- inspect state updates on the exception path in the retry handler
- add regression test for failure + retry sequence

## Out of Scope

- replacing the overall retry architecture
- introducing a new external retry service

## Acceptance Criteria

1. Failed request resets client state correctly.
2. Next retry uses fresh state and can proceed.
3. Regression test reproduces prior failure mode and passes after fix.

## Required Checks

- deterministic test for retry handler
- lint/type checks for touched files

## Expected Artifacts

- bugfix patch
- before/after behavior explanation
- test output summary

## Final Report Format (Mandatory)

- `Summary`
- `Validation`
- `Risks`
- `Follow-ups`

## Risks and Escalation

- If issue depends on undocumented external service behavior, capture assumptions and escalate.
