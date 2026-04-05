# Skill: Architect / Clean Architecture

## Purpose

Keep system structure maintainable by enforcing clear dependency direction and role boundaries.

## When to Use

- modules are tightly coupled
- logic leaks across domain, infra, and integration layers
- changes repeatedly touch many unrelated files

## Required Inputs

- `docs/PRODUCT.md`
- `docs/DOMAIN.md`
- `docs/ARCHITECTURE.md`
- `docs/TECH.md`
- current module graph
- task scope and constraints

## Procedure

1. Identify core domain decisions vs infrastructure concerns.
2. Define target layers (domain, orchestration, adapters, infra).
3. Detect dependency-rule violations.
4. Propose minimal boundary corrections.
5. Specify interfaces/contracts for boundary crossing.
6. Stage refactor into safe incremental slices.
7. Add ADR when structural change impacts architecture.

## Validation Checklist

- domain logic does not depend on transport/infra details
- side effects are isolated behind adapters
- ownership and module responsibilities are explicit
- refactor plan avoids behavior change unless explicitly requested

## Output Format

- `Current Issues`
- `Target Boundaries`
- `Minimal Refactor Plan`
- `Compatibility Notes`
- `ADR Link or Draft`

## Escalation Conditions

- boundary refactor requires broad rewrite outside task scope
- behavior parity cannot be demonstrated for critical branches
