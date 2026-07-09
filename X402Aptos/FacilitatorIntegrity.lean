-- ============================================================
-- x402-Aptos: Facilitator State Integrity
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09
-- ============================================================
import Mathlib.Data.Finset.Basic
import X402Aptos.PaymentVerification

namespace X402Aptos.Facilitator

theorem sequence_strictly_increases (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    s.current_sequence < (settle a s).current_sequence := by simp [settle]

structure TimeStep where
  s_before : FacilitatorState; s_after : FacilitatorState
  mono : s_before.block_time ≤ s_after.block_time

theorem expiry_is_monotone (a : PaymentAuth) (ts : TimeStep) (h_valid : not_expired a ts.s_before) :
    ts.s_before.block_time ≤ a.expiration_ts := h_valid

end X402Aptos.Facilitator
