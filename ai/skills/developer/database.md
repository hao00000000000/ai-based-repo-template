# Skill: Developer / Database and Data Modeling

## Purpose

Design safe, evolvable database schemas and write queries that respect domain invariants, support migrations, and avoid common data integrity pitfalls.

## When to Use

- adding or changing a database table, collection, or schema
- writing queries that touch more than one table or require transactions
- planning a data migration for production
- reviewing ORM models for correctness and safety

## Required Inputs

- `docs/PRODUCT.md`
- `docs/DOMAIN.md` — entities, states, and invariants that must be preserved in the schema
- `docs/ARCHITECTURE.md` — storage layer description and constraints
- `docs/TECH.md` — database engine, ORM, migration tooling
- existing schema or migration files

## Procedure

### Schema Design

1. Map domain entities from `docs/DOMAIN.md` to tables/collections one-to-one where possible. Do not invent DB concepts that have no domain equivalent.
2. Name tables and columns after domain concepts, not implementation details.
3. Every table must have:
   - a stable primary key (prefer surrogate keys for mutable entities)
   - `created_at` timestamp
   - `updated_at` timestamp if the row is mutable
4. Enforce domain invariants at the DB level where possible:
   - NOT NULL for required fields
   - UNIQUE constraints for natural keys
   - CHECK constraints for known enum values
   - Foreign keys for referential integrity (unless explicitly opted out with rationale)
5. Do not store computed values that can be derived from other columns, unless caching for performance with a documented invalidation strategy.
6. Do not store secrets, tokens, or PII in plain text.

### Migrations

7. Every schema change must be a migration file — never edit schema directly in production.
8. Migrations must be:
   - **forward-only** by default (no automatic rollback scripts unless explicitly required)
   - **idempotent** when the migration tooling supports it
   - **safe for zero-downtime deploy**: prefer additive changes (new columns, new tables) before removing old ones
9. Migration order: add column (nullable) → deploy → backfill → add NOT NULL constraint → deploy → drop old column.
10. Test migrations against a realistic data snapshot before production.

### Queries

11. Never build queries by string concatenation with user input — always use parameterized queries or ORM equivalents.
12. For reads that span multiple tables, verify that N+1 queries are not introduced (use joins or batch loading).
13. For writes that must be atomic, use explicit transactions.
14. Index only what is queried frequently. Over-indexing slows writes.
15. Avoid `SELECT *` in production code — select only columns the caller needs.

### ORM Usage

16. ORM models must reflect the domain model — not the other way around.
17. Keep business logic out of ORM models. Models are data holders; logic belongs in domain services.
18. If the ORM generates unexpected queries, inspect and override explicitly.

## Validation Checklist

- schema matches domain entities in `docs/DOMAIN.md`
- domain invariants are enforced at DB level (constraints, NOT NULL, FK)
- no plain-text secrets or PII without explicit encryption strategy
- all schema changes are in migration files, not applied ad-hoc
- migration is zero-downtime-safe or downtime window is documented
- no N+1 queries in changed paths
- parameterized queries used everywhere user input reaches DB

## Output Format

- `Schema Changes` — table/column additions, modifications, removals
- `Migration Plan` — step-by-step, zero-downtime notes
- `Query Safety Notes` — N+1 risks, index impact
- `Invariant Coverage` — which domain invariants are enforced at DB level vs application level
- `Risks` — data loss risk, rollback complexity, performance impact

## Escalation Conditions

- migration requires dropping or renaming a column with data that cannot be safely migrated
- schema change breaks documented domain invariants and no safe path is found
- production data volume makes migration timing unclear without load testing
- PII handling requirements are undocumented
