import Lake
open Lake DSL

package «x402-aptos» where
  version := v!"0.1.0"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "v4.14.0"

lean_lib «X402Aptos» where
  roots := #[`X402Aptos]
