# Skill: Tester / Test Design

## Purpose

Design risk-based test strategy for state-machine behavior and release confidence.

## When to Use

- task changes state transitions, retries, or integration contracts
- release decision requires explicit risk coverage

## Required Inputs

- `docs/PRODUCT.md`, `docs/DOMAIN.md`, `docs/ARCHITECTURE.md`, `docs/TECH.md`
- code diff
- known incident patterns and TODO/NotImplemented areas

## Procedure

1. Map changed paths to state transitions.
2. Build scenario matrix:
   - happy path
   - boundary conditions
   - negative/failure paths
   - out-of-band manual state changes
3. Assign severity to each uncovered risk.
4. Define minimum evidence required for go/no-go.
5. Execute or request targeted tests.
6. Publish findings in priority order.

## Validation Checklist

- transition coverage is explicit
- high-severity risks have direct evidence
- unresolved gaps include impact and mitigation
- release recommendation is justified

## Output Format

- `Scope Under Test`
- `Scenario Matrix`
- `Findings (P0-P3)`
- `Go/No-Go`
- `Required Follow-ups`

## Escalation Conditions

- no reliable evidence for high-risk transition
- environment instability invalidates conclusions
- required tests are missing and block merge policy
