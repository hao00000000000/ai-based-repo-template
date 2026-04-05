# DOMAIN.md

## Document Purpose

This document defines domain concepts, states, invariants, and transition rules for the product.
If code behavior conflicts with this document, this document wins until explicitly updated.

---

## Domain Overview

<!-- Describe the domain in 2-4 sentences. What is the core problem being modeled? -->

[PRODUCT_NAME] operates in the [domain name] domain. At runtime, the system:

- [core runtime behavior 1]
- [core runtime behavior 2]
- [core runtime behavior 3]

---

## Core Entities

### [Entity 1]

<!-- What is this entity? How is it identified? What fields matter? -->

[Description of Entity 1.]

Key fields:

- `[field]` — [purpose]
- `[field]` — [purpose]

### [Entity 2]

[Description of Entity 2.]

Key fields:

- `[field]` — [purpose]
- `[field]` — [purpose]

### External Services

- `[service-name]`: [what it provides]
- `[service-name]`: [what it provides]

---

## State Models

### [Entity 1] Status

- `[State A]`
- `[State B]`
- `[State C]`

### [Entity 2] Status

- `[State A]`
- `[State B]`
- `[State C]`

---

## Domain Invariants

<!-- List invariants numbered. Each must be a falsifiable rule. -->

1. [Invariant name]:

- [description]

2. [Invariant name]:

- [description]

3. [Invariant name]:

- [description]

---

## Core Lifecycle (Simplified)

### [Lifecycle A name]

1. [step]
2. [step]
3. [step]

### [Lifecycle B name]

1. [step]
2. [step]
3. [step]

---

## Runtime Context Model

<!-- How is runtime state held? What is ephemeral vs persistent? -->

Execution context is [ephemeral/persistent] and [scope description].

Includes:

- [context item 1]
- [context item 2]

Rules:

- [rule 1]
- [rule 2]

---

## Failure Semantics

<!-- How does the system handle failures? What is the recovery model? -->

- [failure handling rule 1]
- [failure handling rule 2]
- [failure handling rule 3]

---

## Domain Examples

Example A: [name]:

- [step]
- [step]

Example B: [name]:

- [step]
- [step]

---

## Open Questions

- [question 1]
- [question 2]

---

## Change Log

- YYYY-MM-DD: Initial domain document created.
