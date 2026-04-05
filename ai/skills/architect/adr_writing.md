# Skill: Architect / ADR Writing

## Purpose

Capture architecture decisions as durable, reviewable records that explain context, trade-offs, and consequences — not just the choice made.

## When to Use

- any change that affects module boundaries, data flow, or runtime contract
- introducing or removing a dependency with system-wide impact
- choosing between two or more viable design options with meaningful trade-offs
- reversing or superseding a prior ADR
- team disagreement on a design that needs explicit resolution

## Required Inputs

- `docs/PRODUCT.md`
- `docs/DOMAIN.md`
- `docs/ARCHITECTURE.md`
- `docs/TECH.md`
- design options being considered (at least two)
- known constraints and non-negotiables
- existing ADRs in `docs/adr/` (check for conflicts or dependencies)

## Procedure

1. Assign ADR number: next sequential integer from `docs/adr/README.md` index.
2. Write the **Context** section first:
   - what problem or change triggered this decision
   - what constraints are non-negotiable
   - what happens if no decision is made (cost of delay)
   - keep it factual, not solution-oriented
3. Write **Alternatives Considered** before writing the Decision:
   - minimum two options (including "do nothing" if valid)
   - per option: brief description, pros, cons, why it was or wasn't chosen
   - avoid strawman alternatives — each option must be genuinely viable
4. Write the **Decision** section:
   - state the chosen option in one sentence
   - explain why this option over the alternatives (connect to context and constraints)
   - be explicit about what is NOT included in this decision
5. Write **Consequences**:
   - Positive: what gets better
   - Negative: what gets worse or harder
   - Neutral / Trade-offs: what changes without clear sign
6. Write **Rollout Plan**: concrete steps to implement this decision
7. Write **Validation Plan**: how will we know the decision was correct
8. Set status to `Proposed` until reviewed; update to `Accepted` after team sign-off
9. Add entry to `docs/adr/README.md` index
10. Reference this ADR from the relevant section of `docs/ARCHITECTURE.md`

## Good ADR Signals

- A new engineer can understand WHY this decision was made without asking anyone
- The trade-offs are honest, not just justification for a preferred choice
- The context section explains what would happen if we decided the other way
- Consequences list includes negative consequences, not just positives
- The ADR is short enough to read in 5 minutes

## Bad ADR Signals

- Decision section just says "we chose X" with no rationale
- Only one alternative is listed (or alternatives are clearly not viable)
- Context is missing or describes the solution instead of the problem
- Written after implementation to document what was already done
- ADR is > 3 pages of dense prose

## Output Format

Use the template at `docs/adr/template.md`.

Minimal required sections:
- `Context`
- `Decision`
- `Alternatives Considered`
- `Consequences`
- `Rollout Plan`
- `Validation Plan`
- `References`

## Escalation Conditions

- two options have equal trade-offs and no objective tiebreaker exists (escalate to product/stakeholders)
- decision reverses a prior `Accepted` ADR (requires explicit supersede + impact assessment)
- decision has cross-team or cross-service impact not covered by available docs
