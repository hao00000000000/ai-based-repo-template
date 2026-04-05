# Refactor Task Example

## Task Type

`refactor`

## Context

Multiple service handlers contain repeated patterns for error mapping and response normalization.

## Goal

Extract shared helpers to eliminate duplication without changing behavior.

## In Scope

- extract shared helper(s) where duplication is high and semantics are identical
- preserve existing branching behavior

## Out of Scope

- adding new behaviors or changing response contracts
- performance optimization unrelated to readability/maintainability

## Acceptance Criteria

1. No behavior change in supported flows.
2. Diff reduces duplication and improves readability.
3. Existing or added tests prove parity on touched branches.

## Required Checks

- regression tests for affected handlers
- lint/type checks for touched files

## Expected Artifacts

- refactor patch
- behavior-parity notes
- regression evidence

## Final Report Format (Mandatory)

- `Summary`
- `Validation`
- `Risks`
- `Follow-ups`

## Risks and Escalation

- If "no behavior change" cannot be proven, split task and escalate.
