# x402-Aptos: HTTP 402 Payment-Gated Routing Specification

**Author:** Richard Patterson (@De-ASI-INTERFACE)
**Version:** 1.0.0 | **Date:** 2026-07-09
**Reference ID:** RP-DEASI-APT-2026-0709-001

## 1. Overview

Aptos uses Move's resource model where APT is `aptos_framework::coin::Coin<AptosCoin>` and newer tokens follow `aptos_framework::fungible_asset::FungibleAsset`. The payment gate is enforced inside a Move entry function that validates authorization before routing through Liquidswap v1 pools.

## 2. APT Coin Payment Schema (`scheme: aptos-coin`)

```json
{
  "scheme": "aptos-coin",
  "network": "mainnet",
  "chainId": 1,
  "sender": "0x<aptos-address>",
  "facilitator": "0x<facilitator-address>",
  "amount": "<u64-octas>",
  "sequenceNumber": "<u64>",
  "expirationTimestampSecs": "<u64>",
  "signature": "<ed25519-or-keyless-sig>"
}
```

## 3. Fungible Asset Payment Schema (`scheme: aptos-fa`)

```json
{
  "scheme": "aptos-fa",
  "network": "mainnet",
  "faMetadataAddress": "0x<fa-metadata-object>",
  "amount": "<u64>",
  "sender": "0x<aptos-address>",
  "facilitator": "0x<facilitator-address>",
  "nonce": "<u64>",
  "expirationTimestampSecs": "<u64>",
  "signature": "<ed25519-or-keyless-sig>"
}
```

## 4. Move Payment Gate (Pseudocode)

```move
public entry fun pay_and_route(
    sender: &signer,
    amount: u64,
    nonce: u64,
    expiration: u64,
    facilitator: address
) acquires FacilitatorState {
    let now = timestamp::now_seconds();
    assert!(now <= expiration, EPAYMENT_EXPIRED);
    let state = borrow_global_mut<FacilitatorState>(@facilitator);
    assert!(!table::contains(&state.used_nonces, nonce), ENONCE_REPLAYED);
    table::add(&mut state.used_nonces, nonce, true);
    coin::transfer<AptosCoin>(sender, facilitator, amount);
}
```

## 5. Aptos-Specific Invariants

1. **Block-STM Parallelism Safety:** Payment gate uses global resource lock to prevent parallel double-spend
2. **Sequence Number Enforcement:** Account-level `sequence_number` increments prevent transaction replay
3. **Keyless Authorization:** ZK-SNARK Keyless accounts (Google/Apple OAuth) can authorize payments
4. **FA Object Ownership:** Fungible Asset dispatchable hooks enforce payment before resource transfer
5. **Expiration Timestamp:** `timestamp::now_seconds() <= expirationTimestampSecs` enforced in VM

## 6. Attribution
Originated and authored by Richard Patterson (@De-ASI-INTERFACE), 2026-07-09.
