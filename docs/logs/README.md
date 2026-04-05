# Project Execution Logs

This directory stores execution logs for completed tasks and pull requests.
Logs provide a persistent, reviewable record of what changed, who (which role) made the change, and what the outcome was.

---

## Policy

- One log file per completed task or PR
- Maximum **10 uncompressed logs** in `docs/logs/` at any time
- When the count exceeds 10: compress the **oldest 10** into a single batch summary in `docs/logs/archive/`
- Logs are linked to pull requests via the PR description or footer

---

## Naming Convention

```
docs/logs/YYYY-MM-DD_<task-id>.md
docs/logs/archive/YYYY-MM-DD_batch_summary.md
```

Examples:
- `docs/logs/2026-04-06_feature_health-check.md`
- `docs/logs/archive/2026-04-06_batch_summary.md`

---

## Log Template

Each log file must use this structure:

```markdown
# Log: <task-id>

- Date: YYYY-MM-DD
- Type: [feature | bugfix | refactor | docs | research | test]
- PR: <link or N/A>
- Roles Involved: [architect | developer | tester] (list all that participated)

## Summary

What changed and why. 2-5 sentences.

## Files Changed

- `path/to/file.ext` — what changed and why

## Validation

- [ ] Tests pass: <command and result>
- [ ] Lint/type checks: <command and result>
- [ ] Doc-sync completed: <what was updated>
- [ ] Acceptance criteria met: <list>

## Risks

- <risk and mitigation>

## Follow-ups

- <next task or open question>
```

---

## Compression Procedure

When `docs/logs/` contains more than 10 files (excluding `README.md` and `archive/`):

1. Sort all log files by date (oldest first)
2. Take the oldest 10
3. Create `docs/logs/archive/YYYY-MM-DD_batch_summary.md` with:
   - One row per compressed log: date, task-id, type, summary sentence, risks
4. Delete the 10 individual files from `docs/logs/`
5. Update this README's index

---

## Log Index

| Date | Task | Type | PR |
|------|------|------|----|
| — | — | — | — |
