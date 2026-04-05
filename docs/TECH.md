# TECH.md

## Document Purpose

This document defines the target technical stack, engineering standards, runtime configuration, and development workflow.
If technical decisions conflict with this document, this document wins until explicitly updated.

---

## Stack Summary (Target)

Language/runtime:

- [language and version, e.g. Python 3.11+]

Core runtime libraries:

- [framework, e.g. FastAPI + Uvicorn]
- [library 1]
- [library 2]

Developer tooling baseline:

- [dependency manager, e.g. Poetry]
- [linter, e.g. Ruff]
- [type checker, e.g. MyPy]
- [test runner, e.g. Pytest]
- [pre-commit hooks]

---

## Repository Layout (Target)

- `src/` or `app/` — production codebase
- `tests/` — unit and integration tests
- `docs/` — architecture, product, domain, tech, ADRs, diagrams

Target structure inside production package:

- `[package]/main.py` — process entrypoint
- `[package]/config/` — settings and environment model
- `[package]/[module]/` — [description]
- `[package]/[module]/` — [description]

---

## Runtime Configuration

Required environment variables (production):

- `[VAR_NAME]` — [description]
- `[VAR_NAME]` — [description]
- `[VAR_NAME]` — [description]

Target environments:

- `dev`
- `prod`

Notes:

- default config values in code are dev-only placeholders
- secrets must be provided via environment/secret manager

---

## Local Development Commands (Target)

Install:

```bash
[install command]
```

Run service:

```bash
[run command]
```

Run checks:

```bash
[lint command]
[format command]
[type check command]
[test command]
```

---

## Testing Strategy

Required coverage:

- unit tests for core business logic
- unit tests for boundary behavior
- integration tests with mocked external services
- failure-path tests for critical operations

Minimum quality gates:

- lint + format + type check + tests must pass in CI
- changed modules require direct test coverage or explicit rationale
- critical lifecycle transitions require regression tests

---

## Observability and Error Policy

- any runtime error must be logged with structured context
- [alert policy, e.g. critical errors alert to Slack/PagerDuty]
- base log format: `[format description]`
- health endpoint reflects process liveness/readiness

---

## Security Standards

- never commit private keys, tokens, or credentials
- validate all external responses before use
- keep execution paths bounded and auditable
- avoid logging sensitive payload details

---

## Open Questions

- [question 1]
- [question 2]

---

## Change Log

- YYYY-MM-DD: Initial technical standards document created.
