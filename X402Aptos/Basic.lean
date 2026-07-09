-- ============================================================
-- x402-Aptos: Basic Re-export Shim
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09
-- Chain: Aptos / Fungible Asset / Liquidswap v1
--
-- Re-exports X402Aptos.PaymentVerification as the single
-- authoritative source of all shared types and definitions.
-- Chain-prefixed theorem aliases are provided for ergonomic use.
--
-- Note: Aptos uses a monotone account sequence_number for
-- replay protection (Move resource model), so replay_prevented
-- returns an equality: a.sequence_number = s.current_sequence.
-- ============================================================
import X402Aptos.PaymentVerification

namespace X402Aptos

/-- Alias: sequence freshness under the Aptos chain prefix.
    Aptos replay protection is enforced by Move account
    sequence_number equality: a.sequence_number = s.current_sequence. -/
theorem aptos_replay_prevented
    (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    a.sequence_number = s.current_sequence :=
  replay_prevented a s h

/-- Alias: expiry enforcement under the Aptos chain prefix.
    Delegates to within_expiry: s.block_time ≤ a.expiration_ts. -/
theorem aptos_not_expired
    (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    s.block_time ≤ a.expiration_ts :=
  within_expiry a s h

end X402Aptos
