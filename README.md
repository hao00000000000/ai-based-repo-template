# ai-based-repo-template

A repository template for AI-driven development. Provides a structured setup for orchestrating AI agents to work systematically on complex software projects.

## What's Included

```
CLAUDE.md          — Claude Code entry point (loads context, enforces global rules)
AGENTS.md          — Full orchestration model for AI agents

ai/
  roles/           — Three agent roles with explicit responsibility boundaries
    architect.md   — System design, research, documentation
    developer.md   — Feature, bugfix, refactor implementation
    tester.md      — Verification, test strategy, quality gates
  skills/          — Reusable skill procedures per role
    architect/     — system_design, clean_architecture, design_principles
    developer/     — python, external_api, clean_architecture, design_principles
    tester/        — unit_testing, test_design
  tasks/           — Task playbook examples (feature, bugfix, refactor, docs, research)

docs/
  PRODUCT.md       — Product definition template (fill in for your project)
  DOMAIN.md        — Domain concepts, states, invariants template
  ARCHITECTURE.md  — System architecture template
  TECH.md          — Technical stack and standards template
  adr/             — Architecture Decision Records (template + index)
  diagrams/        — Place architecture diagrams here
  prompts/         — Place phase-specific implementation prompts here
```

## How to Use

1. Fill in the four source-of-truth docs in `docs/`:
   - `PRODUCT.md` — what it is, who it serves, what it must deliver
   - `DOMAIN.md` — domain entities, states, invariants
   - `ARCHITECTURE.md` — component design and constraints
   - `TECH.md` — stack, tooling, local dev workflow

2. Add domain-specific skills to `ai/skills/` as needed (e.g. `developer/web3.md`, `developer/sql.md`).

3. Use `ai/tasks/` examples as templates when writing task specs for agents.

4. Claude Code reads `CLAUDE.md` automatically on startup. All other docs are loaded on demand per the rules in `AGENTS.md`.

## Core Principles

- Documentation is source of truth — docs win over code when they conflict
- Minimal, testable changes — no speculative abstractions
- Escalate over guess — agents escalate when docs are missing or contradictory
- Explicit handoffs — role boundaries are enforced with structured handoff payloads
