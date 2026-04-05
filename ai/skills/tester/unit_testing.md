# Skill: Tester / Unit Testing

## Purpose

Create and evaluate deterministic unit tests for core logic and regression safety.

## When to Use

- feature/bugfix/refactor touches deterministic logic paths
- transaction/state decisions can be validated with mocks/stubs

## Required Inputs

- `docs/PRODUCT.md`
- `docs/DOMAIN.md`
- `docs/ARCHITECTURE.md`
- `docs/TECH.md`
- acceptance criteria
- changed code paths
- expected edge cases and failure modes

## Procedure

1. Identify behavior contract for each changed function.
2. Build positive-path tests first.
3. Add edge and negative tests (exceptions, empty values, stale state).
4. Mock external boundaries (RPC, HTTP, DB, Slack) where required.
5. Assert both outputs and critical side effects.
6. Verify tests fail before fix when reproducing bugfix.

## Validation Checklist

- tests are deterministic and isolated
- critical branches in changed code are covered
- regressions related to fixed bug are locked with tests

## Output Format

- `Test Matrix`
- `New/Updated Tests`
- `Coverage Notes`
- `Residual Gaps`

## Escalation Conditions

- critical behavior cannot be unit-tested with reasonable seams
- required fixtures/mocks are missing and block reliable tests
