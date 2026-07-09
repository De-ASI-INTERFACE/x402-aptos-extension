# x402-Aptos Extension

**HTTP 402 Payment-Gated Routing on Aptos**

**Author:** Richard Patterson (@De-ASI-INTERFACE)
**Version:** 1.0.0 | **Date:** 2026-07-09 | **License:** MIT

## Overview

The x402-Aptos Extension adapts the x402 HTTP 402 payment standard to the Aptos blockchain using the Move language, Aptos's Block-STM parallel execution engine, and TypeScript SDK v2. It defines `scheme: aptos-coin` for APT and `scheme: aptos-fa` for Fungible Asset (FA) standard payments, with Liquidswap v1 as the canonical AMM routing surface. Payment authorization uses Aptos Ed25519 or Keyless (ZK-based) account signatures. Lean 4 formal proofs verify sequence number replay prevention, expiry enforcement, and FA object ownership invariants.

**Reference ID:** RP-DEASI-APT-2026-0709-001
