# Skill: Developer / Clean Architecture (If Needed)

## Purpose

Apply small structural improvements that reduce coupling and improve testability without over-refactoring.

## When to Use

- implementation task reveals repeated coupling pain
- local refactor can reduce risk in future edits

## Required Inputs

- `docs/PRODUCT.md`
- `docs/DOMAIN.md`
- `docs/ARCHITECTURE.md`
- `docs/TECH.md`
- current code section
- scope limits from task
- architecture guidance from docs/architect

## Procedure

1. Identify one concrete coupling problem.
2. Propose smallest boundary improvement.
3. Keep behavior unchanged unless task requires change.
4. Add tests proving parity for touched branch.
5. Document why refactor is needed now.

## Validation Checklist

- refactor remains within task scope
- behavior parity is demonstrated
- abstraction is minimal and justified

## Output Format

- `Problem`
- `Refactor Applied`
- `Behavior Parity Evidence`
- `Why Now`

## Escalation Conditions

- refactor scope expands beyond safe minimal change
- architecture-level decision is required
