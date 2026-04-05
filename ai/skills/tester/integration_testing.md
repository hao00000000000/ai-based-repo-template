# Skill: Tester / Integration and End-to-End Testing

## Purpose

Validate that system components work correctly together across real or realistic boundaries: service-to-service calls, database interactions, external adapters, and full user-facing flows.

## When to Use

- a feature crosses more than one module or process boundary
- a bugfix involves an interaction between layers (e.g. API handler → service → DB)
- a refactor changes how components are wired together
- unit tests pass but production behavior is in question
- smoke testing after a deploy

## Required Inputs

- `docs/PRODUCT.md` — product flows that must work end-to-end
- `docs/DOMAIN.md` — invariants that must hold across the full stack
- `docs/ARCHITECTURE.md` — component wiring, external service contracts
- `docs/TECH.md` — test runner, fixture/stub infrastructure, environment config
- task spec with acceptance criteria
- code diff and changed integration points

## Procedure

### Scope Definition

1. Identify integration boundary being tested: which components talk to which.
2. Define what is real vs stubbed:
   - real: the component being tested and its immediate neighbors
   - stubbed: external services, third-party APIs, message queues (use stubs/fakes, not mocks of internals)
3. Decide test level:
   - **Integration test**: two or more internal components working together (DB + service, service + adapter)
   - **Contract test**: verify that a service meets the interface a consumer expects
   - **E2E test**: full user-facing flow from entry point to final state

### Writing Integration Tests

4. Use a real database (in-memory or containerized) — do not mock the DB layer in integration tests.
5. Each test must:
   - start from a known, explicit state (seed data or fixtures)
   - exercise the full code path through real components
   - assert the final observable state (DB record, response body, emitted event)
   - clean up after itself (teardown or transaction rollback)
6. Do not share mutable state between tests. Each test is independent.
7. Name tests after the user-facing behavior or domain invariant being verified:
   - Bad: `test_create_user_endpoint`
   - Good: `test_new_user_receives_welcome_email_after_registration`
8. External service stubs must return realistic payloads (not empty objects).

### Contract Testing

9. For each external service the system calls, define the expected request/response contract.
10. Contract tests run against the stub and validate that the stub contract matches the real service's documented API.
11. If the real service provides a consumer-driven contract tool (e.g. Pact), use it.

### E2E Testing

12. E2E tests cover the critical paths listed in `docs/PRODUCT.md` (product flows).
13. E2E tests run against a deployed environment (dev or staging), not localhost.
14. E2E tests must be stable — flaky E2E tests are worse than no E2E tests.
15. Keep E2E suite small (< 20 scenarios) and focused on happy paths + one critical failure path.

### Failure Path Coverage

16. For each integration point, test at least one failure scenario:
    - external service returns error
    - database is unavailable (if relevant)
    - request times out
    - invalid/unexpected response shape

## Validation Checklist

- integration tests use real DB (not mocked DB layer)
- each test starts from explicit seed state
- tests are independent and clean up after themselves
- external stubs return realistic payloads
- at least one failure path per integration point is tested
- E2E tests cover all product flows in `docs/PRODUCT.md`
- no flaky tests in the suite (deterministic on repeated runs)

## Output Format

- `Test Scope` — which components are real vs stubbed
- `Test Matrix` — scenarios covered: happy path, edge cases, failure paths
- `Coverage Map` — which product flows and domain invariants are tested
- `Flakiness Risk` — tests that are timing-sensitive or environment-dependent
- `Go/No-Go` — whether integration quality is sufficient to proceed

## Escalation Conditions

- integration cannot be tested without access to a real external service with no stub available
- test environment is shared and mutated by other processes (non-deterministic state)
- E2E tests are consistently flaky but the root cause is in infrastructure, not code
- a critical product flow has no integration test and no feasible path to add one
