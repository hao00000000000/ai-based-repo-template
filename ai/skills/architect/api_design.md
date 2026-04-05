# Skill: Architect / API Design

## Purpose

Design clear, consistent, and evolvable APIs (REST, GraphQL, gRPC, or event-based) that respect domain boundaries and are safe to version.

## When to Use

- introducing a new public or internal API surface
- changing an existing API contract (adding fields, removing endpoints, changing semantics)
- reviewing an API proposal from the developer role
- evaluating API consistency across services

## Required Inputs

- `docs/PRODUCT.md`
- `docs/DOMAIN.md`
- `docs/ARCHITECTURE.md`
- `docs/TECH.md`
- consumer use cases (who calls this API and why)
- existing API contracts or OpenAPI/proto definitions (if any)

## Procedure

1. Identify the resource or operation being exposed. Map it to domain entities in `docs/DOMAIN.md`.
2. Choose the API style (REST/GraphQL/gRPC/events) based on:
   - consumer needs (query flexibility, streaming, latency)
   - existing conventions in `docs/TECH.md`
   - YAGNI: pick the simplest style that satisfies documented needs
3. Define resource naming and hierarchy:
   - REST: nouns, not verbs; consistent pluralization; nested resources only when ownership is clear
   - GraphQL: types map to domain entities; mutations are named after domain actions
   - gRPC: service and method names reflect domain language
4. Define request and response shapes:
   - all fields named after domain concepts, not implementation details
   - never leak internal IDs or DB schema structure unless explicitly intended
   - required vs optional fields must be explicit
5. Define error contract:
   - standard error shape (code, message, details)
   - use domain-meaningful error codes, not generic HTTP 400/500 only
6. Define versioning strategy before the first consumer exists:
   - prefer additive changes (new fields, new endpoints) over breaking changes
   - document deprecation policy (timeline, migration path)
7. Check security surface:
   - authentication and authorization at the endpoint level
   - no sensitive data in query strings or logs
   - input validation boundary explicit
8. Write or update API spec (OpenAPI / proto / schema) as the source of truth.
9. Create or update ADR if the API pattern changes architecture.

## Validation Checklist

- API shape maps cleanly to domain entities, not internal implementation
- error contract is consistent and actionable
- versioning strategy is declared before the first external consumer
- authentication and authorization requirements are documented
- no sensitive fields exposed without explicit intent
- spec file (OpenAPI / proto / schema) is updated or created

## Output Format

- `API Contract Summary` — resource, operations, shapes
- `Design Decisions` — style choice rationale, versioning policy
- `Error Contract` — error codes and meanings
- `Security Surface` — auth model, input validation boundary
- `Breaking Change Risk` — what could break existing consumers
- `ADR Link or Draft` (if architecture-impacting)

## Escalation Conditions

- consumer requirements are undocumented or contradictory
- breaking change is required but deprecation timeline is unclear
- API spans ownership boundaries across teams or services without clear governance
- security requirements for the endpoint are unspecified
