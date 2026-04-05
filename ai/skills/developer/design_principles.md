# Skill: Developer / Design Principles (KISS, DRY, SOLID)

## Purpose

Use KISS/DRY/SOLID as practical implementation checks, only when they improve current task outcomes.

## When to Use

- coding decisions involve abstraction trade-offs
- duplicate logic appears in touched scope

## Required Inputs

- `docs/PRODUCT.md`
- `docs/DOMAIN.md`
- `docs/ARCHITECTURE.md`
- `docs/TECH.md`
- implementation options
- current constraints
- expected future change pressure (if known)

## Procedure

1. KISS: choose the simplest correct implementation first.
2. DRY: extract only stable duplicated logic.
3. SOLID: apply where it improves testability/clarity in current scope.
4. Re-check YAGNI: remove speculative hooks.

## Validation Checklist

- no unnecessary abstraction introduced
- duplicate logic removed only when safe and meaningful
- class/function structure remains easy to reason about

## Output Format

- `Decision Notes`
- `Principle Applied`
- `Trade-off`

## Escalation Conditions

- principle-driven change conflicts with correctness/safety requirements
