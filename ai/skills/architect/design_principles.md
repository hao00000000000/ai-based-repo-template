# Skill: Architect / Design Principles (KISS, DRY, SOLID)

## Purpose

Apply design principles as decision filters, not as mandatory abstractions.

## When to Use

- design options compete on complexity and maintainability
- refactor proposals introduce new abstractions
- reviews need clear rationale for structure choices

## Required Inputs

- `docs/PRODUCT.md`
- `docs/DOMAIN.md`
- `docs/ARCHITECTURE.md`
- `docs/TECH.md`
- design options
- current implementation constraints
- affected invariants

## Procedure

1. Apply KISS first: prefer the simplest correct option.
2. Apply DRY second: deduplicate only when true repetition is stable.
3. Apply SOLID third: enforce where it improves clarity/testability.
4. Reject abstractions that solve hypothetical future needs.
5. Record principle-based rationale in decision notes/ADR.

## Validation Checklist

- chosen design is simpler than alternatives
- abstractions are justified by real duplication or change pressure
- SOLID usage improves comprehension and tests, not just formality
- no YAGNI violations

## Output Format

- `Option Scorecard`
- `Principle-Based Rationale`
- `Final Choice`

## Escalation Conditions

- principles conflict in ways that affect correctness or invariants
- team needs explicit priority override for a business deadline
