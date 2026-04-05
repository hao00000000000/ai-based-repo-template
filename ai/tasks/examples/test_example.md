# Test Task Example

## Task Type

`test`

## Primary Role

`tester`

## Context

A recent `feature` or `bugfix` task was completed but test coverage for the changed behavior is absent or insufficient. This task adds or verifies tests without changing production behavior.

## Goal

Add deterministic tests that verify the correctness of existing behavior and protect against regression.

## In Scope

- write or extend tests covering the behavior added/fixed in the prior task
- assert expected outputs for happy path, edge cases, and failure paths
- verify tests are deterministic (no flakiness)

## Out of Scope

- changing production code behavior
- refactoring test infrastructure beyond what is needed
- adding tests for unrelated code paths

## Acceptance Criteria

1. New or updated tests cover the primary behavior change from the prior task.
2. Edge cases and at least one failure path are tested.
3. All tests pass deterministically on repeated runs.
4. Test names clearly describe the scenario being validated.

## Required Checks

- run full test suite and confirm new tests pass
- confirm no existing tests were broken
- lint/type checks for test files

## Expected Artifacts

- test file diff
- test run output summary
- list of scenarios covered (happy path, edge cases, failure paths)

## Final Report Format (Mandatory)

- `Summary`
- `Validation`
- `Risks`
- `Follow-ups`

## Risks and Escalation

- If behavior is ambiguous and cannot be tested deterministically, escalate to architect before writing tests.
- If the prior task did not produce clear acceptance criteria, request clarification before proceeding.
- If critical paths are untestable without significant infrastructure changes, document as a risk and escalate.
