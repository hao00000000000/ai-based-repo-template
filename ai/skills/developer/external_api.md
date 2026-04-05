# Skill: Developer / External API Integration

## Purpose

Implement and modify external service integrations safely: request/response handling, retry strategy, validation, and observability.

## When to Use

- changes touch HTTP clients, external API calls, or third-party service adapters
- adding or modifying retry, timeout, or circuit-breaker behavior
- integrating a new external dependency into the system

## Required Inputs

- `docs/PRODUCT.md`
- `docs/DOMAIN.md`
- `docs/ARCHITECTURE.md`
- `docs/TECH.md`
- external service contract or API spec
- failure/retry requirements

## Procedure

1. Confirm preconditions from docs before making external calls.
2. Build request with explicit parameters and headers.
3. Validate response schema and status before using data downstream.
4. Implement bounded retries with backoff and structured logging.
5. Keep side effects idempotent where possible.
6. Never pass raw external responses to sensitive operations without validation.
7. Emit actionable traces (service name, endpoint, status, duration).
8. Cover failure paths with tests/mocks.

## Validation Checklist

- no unvalidated external data reaches core domain logic
- retries are bounded and reasoned
- failed calls do not silently continue workflow
- logs and alerts are actionable for operators

## Output Format

- `Integration Summary`
- `Safety Checks Added`
- `Failure Handling`
- `Test Evidence`
- `Operational Notes`

## Escalation Conditions

- external API contract unclear or undocumented
- cannot guarantee safe retry/idempotency for critical step
- service response schema diverges from documented contract
