# Skills Matrix (Active)

Language policy:

- All skill files are maintained in English.

Decision policy:

- Architecture-impacting changes require ADR.
- If code changes are present, merge is not allowed without passing required tests.

Manual operations policy:

- Manual operations may happen in separate external processes.
- Skills must assume out-of-band state changes are possible.

---

## Role → Skills

### Architect

Core:
- `architect/system_design.md` — cross-boundary feature design, failure handling, ADR
- `architect/clean_architecture.md` — layer boundaries, dependency direction
- `architect/design_principles.md` — KISS/DRY/YAGNI/SOLID as decision filters

Extended:
- `architect/api_design.md` — REST/GraphQL/gRPC contract design, versioning
- `architect/adr_writing.md` — how to write effective Architecture Decision Records

### Developer

Core:
- `developer/python.md` — typed, async-safe Python implementation
- `developer/external_api.md` — external service integration, retries, validation
- `developer/clean_architecture.md` — module boundaries, dependency rules
- `developer/design_principles.md` — developer-side principle application

Extended:
- `developer/git_workflow.md` — branching, commit discipline, PR preparation
- `developer/database.md` — schema design, migrations, query safety
- `developer/ci_cd.md` — pipeline setup, quality gates, safe deployment
- `developer/web3.md` — EVM tx lifecycle, nonce management, multicall, cross-chain (load for Web3 projects)

### Tester

Core:
- `tester/unit_testing.md` — isolated unit test strategy
- `tester/test_design.md` — test matrix, edge cases, failure paths

Extended:
- `tester/integration_testing.md` — cross-component, contract, and E2E testing

### Reviewer

The reviewer role always runs as a separate subagent with isolated context. It uses only shared skills:

- `shared/code_review.md` — primary skill: 7-lens review, Blocker/Suggestion/Note, GO/NO-GO
- `shared/security_review.md` — applied automatically for auth/input/credential changes

### Shared (Any Role)

- `shared/security_review.md` — threat modeling, injection checks, secret safety, auth review
- `shared/code_review.md` — multi-lens PR review: correctness, design, coverage, doc-sync, security

---

## Skill Execution Contract

Each skill must provide:

- Purpose
- When to Use
- Required Inputs
- Procedure
- Validation Checklist
- Output Format
- Escalation Conditions

---

## Priority Order

P0 — always load for relevant tasks:

1. `architect/system_design.md`
2. `tester/test_design.md`
3. `developer/python.md` *(or language equivalent)*

P1 — load when the task touches these areas:

4. `shared/code_review.md` — every PR before merge (review step)
5. `architect/api_design.md` — any new API surface
6. `developer/external_api.md` — any external service call
7. `architect/clean_architecture.md` — any cross-module change
8. `tester/unit_testing.md` — any behavior-changing task
9. `developer/git_workflow.md` — any task going to PR
10. `shared/security_review.md` — any auth, input, or secret change

P2 — load on demand:

11. `developer/database.md` — schema or query changes
12. `developer/ci_cd.md` — pipeline changes
13. `tester/integration_testing.md` — cross-boundary features
14. `architect/adr_writing.md` — architecture-impacting decisions
15. `architect/design_principles.md` — design option trade-off analysis
16. `developer/clean_architecture.md` — refactor or boundary cleanup
17. `developer/design_principles.md` — developer-side principle review

Domain-specific (load when project requires):

- `developer/web3.md` — EVM chains, smart contract interaction, tx lifecycle

---

## Notes

- Core skills are loaded by default for all relevant tasks.
- Extended skills are loaded when the task scope requires them.
- Add domain-specific skills (e.g. `developer/web3.md`, `developer/sql.md`, `architect/event_sourcing.md`) to the appropriate role folder as the project grows.
- `shared/` skills apply to any role — declare which role is running the review in the context header.
