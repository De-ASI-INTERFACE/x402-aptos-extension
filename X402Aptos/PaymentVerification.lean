-- ============================================================
-- x402-Aptos: Payment Verification Formal Proofs
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09
-- Chain: Aptos / Fungible Asset / Liquidswap v1
-- ============================================================
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Nat.Basic
import Mathlib.Logic.Basic

namespace X402Aptos

structure PaymentAuth where
  sequence_number : Nat    -- account sequence (Move)
  amount          : Nat    -- FA base units
  expiration_ts   : Nat    -- transaction expiry
  asset_type      : Nat    -- fungible asset metadata
  deriving Repr, DecidableEq

structure FacilitatorState where
  current_sequence : Nat
  block_time       : Nat
  deriving Repr

def not_expired (a : PaymentAuth) (s : FacilitatorState) : Prop := s.block_time ≤ a.expiration_ts
def nonce_fresh (a : PaymentAuth) (s : FacilitatorState) : Prop := a.sequence_number = s.current_sequence
def amount_positive (a : PaymentAuth) : Prop := 0 < a.amount
def verify (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  not_expired a s ∧ nonce_fresh a s ∧ amount_positive a

theorem replay_prevented (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    a.sequence_number = s.current_sequence := h.2.1
theorem within_expiry (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) : s.block_time ≤ a.expiration_ts := h.1
theorem positive_amount (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) : 0 < a.amount := h.2.2

def settle (a : PaymentAuth) (s : FacilitatorState) : FacilitatorState :=
  { s with current_sequence := s.current_sequence + 1 }

theorem settled_nonce_used (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    (settle a s).current_sequence = s.current_sequence + 1 := by simp [settle]

theorem post_settlement_replay_blocked (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    (settle a s).current_sequence ≠ s.current_sequence := by simp [settle]

end X402Aptos
