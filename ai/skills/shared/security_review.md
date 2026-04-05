# Skill: Shared / Security Review

## Purpose

Identify security risks in code, API design, data handling, and configuration before they reach production. Applicable by any role when security-sensitive changes are in scope.

## When to Use (Any Role)

- **Architect**: designing authentication, authorization, or data access patterns
- **Developer**: implementing endpoints that accept external input, handle credentials, or touch sensitive data
- **Tester**: verifying that security requirements are enforced and not bypassable

Trigger automatically when a change touches:
- authentication or session management
- authorization / permission checks
- input handling from external sources (HTTP body, query params, headers, files)
- secret or credential management
- database queries with user-supplied data
- file system or shell operations with user-supplied paths
- external service integrations (API keys, webhooks, tokens)
- logging (risk of sensitive data leakage)

## Required Inputs

- `docs/ARCHITECTURE.md` — trust boundaries, component map
- `docs/TECH.md` — security standards, secret management policy
- code diff or design proposal
- list of external input sources and trust levels

## Procedure

### Threat Modeling (Architect / design phase)

1. Identify trust boundaries: what crosses from untrusted (user, external service) to trusted (internal service, DB).
2. For each boundary crossing, ask:
   - Is the caller authenticated? How?
   - Is the caller authorized for this specific resource/action? How is that checked?
   - Is the input validated before use?
   - What is the worst-case impact if this check is bypassed?
3. Map each identified risk to a STRIDE category (optional but useful for communication):
   - **S**poofing — fake identity
   - **T**ampering — modifying data in transit or at rest
   - **R**epudiation — denying an action occurred
   - **I**nformation disclosure — exposing sensitive data
   - **D**enial of service — making the system unavailable
   - **E**levation of privilege — gaining more access than allowed

### Code Review (Developer / Tester)

4. Check for injection vulnerabilities:
   - SQL: parameterized queries everywhere? No string interpolation with user data?
   - Shell: user input never passed to shell commands?
   - Path traversal: file paths from user input sanitized?
5. Check authentication:
   - Is every protected endpoint actually behind auth middleware?
   - Are session tokens invalidated on logout/expiry?
   - Are credentials never logged, even in debug mode?
6. Check authorization:
   - Is ownership verified before returning or modifying a resource?
   - Are admin-only endpoints protected by role checks, not just auth?
7. Check input validation:
   - Is input validated at the boundary (before it reaches domain logic)?
   - Are size limits enforced (request body, file upload, string fields)?
8. Check secrets:
   - No hardcoded secrets, tokens, or passwords in code or config files?
   - Secrets loaded from environment/vault, not from committed files?
   - Secrets not logged in any format (masked or absent)?
9. Check error handling:
   - Do error responses reveal internal structure, stack traces, or file paths?
   - Are all unhandled exceptions caught at the boundary?
10. Check dependencies:
    - Are third-party dependencies pinned to a specific version?
    - Any known CVEs in current dependency versions?

### Logging Safety

11. Before any log statement with user-supplied data, confirm the data does not include:
    - passwords, tokens, API keys
    - PII (email, phone, address, SSN)
    - financial data
    - session identifiers
12. If logging is necessary for debugging, use field masking or redaction.

## Validation Checklist

- trust boundaries are mapped and all crossings are authenticated + authorized
- no string interpolation with user data in DB queries, shell commands, or file paths
- all protected endpoints verified to be behind auth middleware
- no secrets in code, config, or logs
- error responses do not reveal internal structure
- input size limits enforced at boundary
- dependency versions pinned and checked for known CVEs

## Output Format

- `Trust Boundary Map` — what crosses from untrusted to trusted
- `Risk Register` — per risk: description, STRIDE category, severity (High/Medium/Low), mitigation
- `Findings` — specific code locations with issues
- `Cleared` — items explicitly verified as safe
- `Recommendations` — changes required before merge

## Escalation Conditions

- authentication or authorization logic is missing entirely for a sensitive endpoint
- a secret is found committed to git history (requires immediate rotation, not just removal)
- a vulnerability is found that may affect already-deployed versions (requires incident response)
- security requirements for a feature are undocumented and cannot be inferred from existing docs
