# Skill: Developer / CI/CD Pipeline

## Purpose

Configure and maintain CI/CD pipelines that enforce quality gates automatically, produce reliable artifacts, and deploy safely.

## When to Use

- setting up CI for a new repository or service
- adding or changing quality gate steps (lint, test, type check, security scan)
- configuring deployment to a new environment
- debugging a failing pipeline
- reviewing pipeline changes proposed by another contributor

## Required Inputs

- `docs/TECH.md` — stack, test commands, quality gate requirements
- `docs/ARCHITECTURE.md` — deployment targets, environment model
- existing pipeline config files (`.github/workflows/`, `.gitlab-ci.yml`, `Makefile`, etc.)
- `Makefile` targets as the canonical command source

## Procedure

### CI Pipeline Structure

1. Every PR must run the full quality gate before merge. Minimum gates (from `Makefile`):
   - `make lint`
   - `make format-check`
   - `make type-check`
   - `make test`
   - `make docs-check` (verify source-of-truth docs are non-empty)
2. Steps must be ordered: lint → type check → test. Fail fast.
3. Test step must run in isolation — no shared state between test runs.
4. Never commit secrets to pipeline config. Use CI secret variables / vault references.
5. Cache dependency installs (e.g. pip, npm, poetry) keyed on lockfile hash — not on branch name.

### Build and Artifact

6. Build produces a single versioned artifact (Docker image, binary, package).
7. Artifact version = git tag or `<branch>-<short-sha>` for non-tagged builds.
8. Never build from a dirty working tree (untracked or modified files).
9. Build step must be reproducible: same inputs → same artifact.

### Deployment

10. Environments: `dev` → `staging` → `prod`. No direct deploy to prod from local.
11. Deploy to `dev` on every merge to `main` (automatic).
12. Deploy to `staging` on tag or manual trigger (with approval if required).
13. Deploy to `prod` requires:
    - staging verification passing
    - explicit approval (human or automated gate)
    - rollback plan documented
14. Deployment must be zero-downtime by default (rolling update, blue-green, or canary).
15. Health check endpoint must pass after deploy before old instances are removed.

### Observability of Pipeline

16. Pipeline failures must produce actionable error messages — not just "step failed".
17. Test reports (JUnit XML, coverage HTML) should be published as pipeline artifacts.
18. Flaky tests must be tracked and fixed — do not mark them as `allow_failure` without a follow-up task.

### Pipeline as Code

19. Pipeline config lives in version control alongside the code it builds.
20. Pipeline changes go through the same PR review as code changes.
21. `Makefile` targets are the source of truth for commands — pipeline calls `make <target>`, not inline commands.
22. Do not duplicate logic between `Makefile` and pipeline config.

## Validation Checklist

- all `make check` targets run in CI before merge
- no secrets in pipeline config files
- dependencies cached correctly (keyed on lockfile)
- build is reproducible
- deploy targets follow `dev → staging → prod` flow
- zero-downtime deploy verified
- health check passes after deploy
- flaky tests tracked with follow-up task, not silenced

## Output Format

- `Pipeline Map` — stages and what each does
- `Quality Gates` — commands, pass/fail criteria
- `Deploy Flow` — trigger, target, approval, rollback
- `Secret Management` — how secrets are injected (not what they are)
- `Known Risks` — flaky tests, long runtimes, single point of failure

## Escalation Conditions

- pipeline requires access to production secrets that should not be in CI
- deploy strategy requires downtime and no maintenance window is scheduled
- test suite runtime exceeds the acceptable PR feedback loop (>10 min)
- pipeline config contains hardcoded environment-specific values that diverge from `docs/TECH.md`
