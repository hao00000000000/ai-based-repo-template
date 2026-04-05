# ARCHITECTURE.md

## Document Purpose

This document defines the target architecture, component boundaries, runtime flow, and constraints.
If code structure conflicts with this document, this document wins until explicitly updated.

---

## System Context

<!-- What does this system do at a high level? What are its boundaries? -->

[PRODUCT_NAME] is a [type of system] that [high-level responsibility].

High-level responsibility:

- [responsibility 1]
- [responsibility 2]
- [responsibility 3]

---

## Architecture Drivers

<!-- What principles shape architectural decisions in this system? -->

- [driver 1] (e.g. correctness over speed)
- [driver 2] (e.g. explicit module boundaries)
- [driver 3] (e.g. simple, readable code)
- [driver 4] (e.g. safe retries and deterministic re-entry)

---

## Component View

### 1) [Component Name]

- [responsibility]
- [responsibility]

### 2) [Component Name]

- [responsibility]
- [responsibility]

### 3) [Component Name]

- [responsibility]
- [responsibility]

### 4) [Component Name]

- [responsibility]
- [responsibility]

---

## Key Interface Contracts

<!-- Define the primary interfaces between components. -->

```
[Interface or protocol definition]
```

Contract semantics:

- [semantic 1]
- [semantic 2]
- [semantic 3]

---

## Runtime Cycle / Flow

<!-- How does a typical operation flow through the system? -->

For each [operation unit]:

1. [step]
2. [step]
3. [step]
4. [step]

Execution policy:

- [policy 1]
- [policy 2]
- [policy 3]

---

## Concurrency Model

<!-- How does this system handle concurrent work? -->

- [concurrency rule 1]
- [concurrency rule 2]
- [concurrency rule 3]

---

## Error Handling Strategy

- [error handling rule 1]
- [error handling rule 2]
- [error handling rule 3]

Recovery model:

- [recovery rule 1]
- [recovery rule 2]

---

## Security and Safety Constraints

- never expose secrets in logs or docs
- [constraint 2]
- [constraint 3]

---

## Diagrams

<!-- Add diagram references here as the project evolves. -->

- [Diagram name]: `docs/diagrams/[filename]`

---

## ADR Policy

Architecture-impacting changes require ADR.

Current governing ADRs:

- `docs/adr/` — see ADR index

---

## Open Questions

- [question 1]
- [question 2]

---

## Change Log

- YYYY-MM-DD: Initial architecture document created.
