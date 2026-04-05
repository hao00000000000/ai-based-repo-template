# Task Management

This folder is the project task tracker — a lightweight Jira-equivalent in the repository.

---

## Directory Structure

```
ai/tasks/
  examples/     — reference task spec templates (one per task type)
  active/       — in-progress task specs (one file per active task)
  done/         — completed task specs (source for docs/logs entries)
```

---

## Task Lifecycle

```
[create spec in active/]
        ↓
[assign role, execute via AGENTS.md flow]
        ↓
[move to done/ on completion]
        ↓
[create entry in docs/logs/]
```

---

## Task Types

| Type       | Description                                                    |
|------------|----------------------------------------------------------------|
| `feature`  | Implement new user-visible or API-visible behavior             |
| `bugfix`   | Restore expected documented behavior                           |
| `refactor` | Improve structure without behavior change                      |
| `docs`     | Update documentation only                                      |
| `research` | Investigate and report, no behavior change                     |
| `test`     | Add or verify test coverage for existing behavior              |

See `examples/` for a reference spec per type.

---

## Task Spec Format

Every task spec must include:

- **Task Type** — one of the types above
- **Primary Role** — `architect` / `developer` / `tester`
- **Context** — why this task exists
- **Goal** — what done looks like
- **In Scope / Out of Scope**
- **Acceptance Criteria** — numbered, verifiable
- **Required Checks** — commands that must pass
- **Expected Artifacts** — files and outputs
- **Risks and Escalation Conditions**
- **Handoff Payload** — required for multi-role tasks

Final report (mandatory for non-trivial tasks):

- `Summary`
- `Validation`
- `Risks`
- `Follow-ups`

---

## Naming Convention

```
active/<YYYY-MM-DD>_<type>_<short-name>.md
done/<YYYY-MM-DD>_<type>_<short-name>.md
```

Example: `active/2026-04-06_feature_health-check.md`

---

## Files

**Examples:**

- `examples/feature_example.md`
- `examples/bugfix_example.md`
- `examples/refactor_example.md`
- `examples/docs_example.md`
- `examples/research_example.md`
- `examples/test_example.md`
