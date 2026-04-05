# Skill: Developer / Web3 and EVM Interaction

## Purpose

Implement safe, correct, and observable interactions with EVM-compatible blockchains: transaction lifecycle, smart contract calls, nonce management, receipt validation, multicall batching, and cross-chain patterns.

## When to Use

- any change that sends, signs, or reads transactions on an EVM chain
- changes to contract ABI interaction, event log parsing, or state reading
- implementing or modifying nonce management, gas estimation, or retry logic
- adding multicall batching or cross-chain message flows
- reading on-chain state for orchestration decisions

## Required Inputs

- `docs/PRODUCT.md`
- `docs/DOMAIN.md` — domain entities that map to on-chain state
- `docs/ARCHITECTURE.md` — chain interaction layer boundaries
- `docs/TECH.md` — Web3 library, RPC configuration, chain targets
- contract ABI or interface definition for the target contract
- target chain assumptions (chain ID, finality model, mempool behavior)

---

## Procedure

### RPC and Client Setup

1. Never hardcode RPC URLs. Load from config (`RPC_BY_CHAIN_ID` or equivalent env-based map).
2. Validate that the chain ID in config matches the chain ID returned by `eth_chainId` at startup.
3. Use async clients where available. Do not block the event loop on RPC calls.
4. Configure explicit timeouts on all RPC requests. Never rely on default infinite timeout.
5. Log RPC errors with: chain ID, method name, error type. Never log raw RPC responses that may contain sensitive data.

### Reading On-Chain State

6. Always specify `block_identifier` explicitly when reading state:
   - use `"latest"` for current state
   - use a specific block number for historical or deterministic reads
7. Batch independent reads with multicall where supported. Do not make N sequential calls when one multicall covers them.
8. Validate that returned values match expected types and ranges before using them in domain logic.
9. Treat on-chain state as the source of truth — never assume in-memory state is consistent with chain state across cycles.

### Transaction Lifecycle

10. Build transaction parameters explicitly:
    - `to`, `data`, `value`, `chainId`, `gas`, `maxFeePerGas` / `maxPriorityFeePerGas` (EIP-1559) or `gasPrice`
    - Never leave gas fields unset — always estimate then apply a safety multiplier (e.g. ×1.2)
11. Sign transactions with the operator key. Never log the private key or expose it in error messages.
12. Before sending: verify preconditions from on-chain state (correct status, sufficient balance, correct nonce).

### Nonce Management

13. Maintain a per-account nonce cache. Do not call `eth_getTransactionCount` on every send — use cached value incremented after each successful send.
14. On send failure (RPC error, timeout, rejection): **reset nonce cache** and re-fetch from chain before retrying. Never retry with a stale incremented nonce.
15. Serialize transaction sends per account. Do not send two transactions from the same account concurrently without explicit nonce coordination.
16. On process restart: always re-fetch nonce from chain, never resume from in-memory cache.

### Receipt Validation and Retries

17. After sending, poll for receipt until:
    - receipt is found with `status == 1` (success) → proceed
    - receipt is found with `status == 0` (revert) → decode revert reason, log, escalate
    - timeout reached → treat as dropped, reset nonce, retry with fresh gas estimate
18. Confirm with at least 1 block (or N blocks per chain finality requirements in `docs/TECH.md`).
19. Decode revert reasons from `eth_call` simulation before sending when possible — fail early without spending gas.
20. Bounded retries: define a maximum retry count per transaction. After max retries, alert and stop — do not loop indefinitely.

### Event Log Parsing

21. Filter events by contract address and topic hash — never parse unfiltered logs.
22. Validate that log data shape matches the ABI before decoding.
23. Handle missing or reorganized logs defensively: re-read state from chain rather than assuming the log represents final truth.
24. Do not use events as the primary state source for orchestration — use contract state reads. Events are for observability and indexing.

### Gas Estimation

25. Use `eth_estimateGas` before every new transaction type. Do not reuse gas estimates across different input sizes.
26. Apply a gas multiplier (1.1–1.3×) to the estimate. Document the chosen multiplier in `docs/TECH.md`.
27. For EIP-1559: set `maxFeePerGas` = baseFee × 2 + `maxPriorityFeePerGas`. Adjust per chain conventions.
28. On persistent `out of gas` failures: log the estimate vs actual and escalate — do not silently increase multiplier without review.

### Multicall Batching

29. Group independent read calls into a single multicall to reduce latency and RPC load.
30. Multicall registry must be keyed by chain ID. Do not reuse a multicall instance across chains.
31. Validate that all calls in a multicall batch succeeded before using results — partial failures must not silently pass.
32. Log multicall batch size and outcome for observability.

### Cross-Chain Patterns

33. Never assume that a transaction confirmed on chain A has a corresponding effect on chain B without explicit bridge confirmation.
34. Track cross-chain message state explicitly (sent, received, confirmed) — do not rely on timing assumptions.
35. For bridge interactions: validate the bridge contract address from config, never from a dynamic source.

### Security

36. Never include the operator private key in logs, error messages, transaction data, or configuration files.
37. Validate all contract addresses from configuration — never accept contract addresses from external API responses without explicit whitelist check.
38. Do not execute transactions based on unvalidated external data (e.g. quote service response). Validate shape and bounds before building tx.
39. Simulate transactions with `eth_call` before sending where possible. Catch reverts without spending gas.

---

## Validation Checklist

- RPC URL loaded from config, not hardcoded
- chain ID verified at startup
- nonce cache reset on send failure before retry
- sends serialized per account (no concurrent nonce collision)
- receipt polling has explicit timeout and max retry bound
- revert reasons decoded and logged
- gas estimated with explicit multiplier, documented in `docs/TECH.md`
- multicall results validated (no silent partial failure)
- private key never logged or exposed
- external data validated before tx build
- on-chain state read fresh each cycle — no cross-cycle memory state assumed

## Output Format

- `Tx Path Summary` — what transactions are sent and in what order
- `Nonce Strategy` — how nonce is managed per account
- `Gas Strategy` — estimation method and multiplier used
- `Receipt Handling` — polling timeout, retry count, revert handling
- `Read Strategy` — which state is read, block identifier, multicall usage
- `Safety Checks` — pre-conditions verified before send
- `Test Evidence` — how the tx path is tested (mock chain, forked chain, unit)
- `Operational Notes` — what operators should monitor

## Escalation Conditions

- contract behavior is undocumented or contradicts `docs/DOMAIN.md`
- cannot guarantee safe retry/idempotency for a critical transaction
- revert reason is unknown and cannot be reproduced with `eth_call`
- cross-chain path requires bridge or swap scenario not covered in docs
- gas costs exceed expected bounds and the root cause is unknown
- chain exhibits unusual finality behavior not covered by `docs/TECH.md`
