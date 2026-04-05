# Skill: Developer / Python Implementation

## Purpose

Implement reliable Python changes with strong typing, clear async behavior, and minimal side effects.

## When to Use

- any feature/bugfix/refactor implemented in Python modules

## Required Inputs

- `docs/PRODUCT.md`
- `docs/DOMAIN.md`
- `docs/ARCHITECTURE.md`
- `docs/TECH.md`
- task acceptance criteria
- impacted modules and tests

## Procedure

1. Confirm behavior contract before editing.
2. Implement minimal diff with explicit control flow.
3. Keep async code non-blocking and lock usage intentional.
4. Maintain type hints and mypy compatibility.
5. Add/adjust tests for changed behavior.
6. Run required checks.
7. Document assumptions and residual risks.

## Validation Checklist

- code is readable and explicit
- async/concurrency behavior is safe
- typing remains strict enough for mypy
- tests pass for changed paths

## Output Format

- `Change Summary`
- `Files Touched`
- `Validation Results`
- `Assumptions`
- `Risks`

## Escalation Conditions

- requirements ambiguous for behavior-critical path
- deterministic test cannot be created for critical change
