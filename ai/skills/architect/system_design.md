# Skill: Architect / System Design

## Purpose

Design or evolve system behavior with explicit boundaries, data flow, and failure handling while preserving domain invariants.

## When to Use

- new feature crosses module boundaries
- behavior change affects core domain entities or lifecycle
- reliability/scaling constraints require architecture choices

## Required Inputs

- `docs/PRODUCT.md`
- `docs/DOMAIN.md`
- `docs/ARCHITECTURE.md`
- `docs/TECH.md`
- touched code paths

## Procedure

1. Define scope and non-goals in one short paragraph.
2. List domain invariants impacted by the change.
3. Produce component interaction map (who calls whom, sync/async boundaries).
4. Identify state ownership and persistence boundaries.
5. Enumerate failure modes and recovery strategy per mode.
6. Compare at least two design options (default + alternative).
7. Select recommended option with trade-offs.
8. Prepare implementation slices with dependency order.
9. Create or update ADR for architecture-impacting decision.

## Validation Checklist

- invariants are explicit and preserved
- failure handling is defined for critical paths
- external integration assumptions are documented
- operational impact (latency, retries, observability) is assessed
- ADR is provided when architecture is affected

## Output Format

- `Summary`
- `Invariants Impact`
- `Options Considered`
- `Decision`
- `Implementation Slices`
- `Risk Register`
- `ADR Link or Draft`

## Escalation Conditions

- contract semantics are unclear or conflicting
- safety-critical behavior cannot be validated from available specs
- design requires cross-team ownership decision
