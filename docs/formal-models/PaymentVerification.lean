-- x402-Aptos Payment Verification Formal Model
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09

import Mathlib.Data.Finset.Basic

namespace X402Aptos

structure PaymentAuth where
  nonce       : Nat
  amount      : Nat
  expiration  : Nat
  seq_number  : Nat
  deriving Repr

structure FacilitatorState where
  used_nonces    : Finset Nat
  used_seqs      : Finset Nat
  current_time   : Nat
  deriving Repr

def not_expired (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  s.current_time ≤ a.expiration

def nonce_fresh (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  a.nonce ∉ s.used_nonces

def seq_unused (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  a.seq_number ∉ s.used_seqs

def verify (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  not_expired a s ∧ nonce_fresh a s ∧ seq_unused a s

theorem block_stm_safe (a : PaymentAuth) (s : FacilitatorState)
    (h : verify a s) : a.nonce ∉ s.used_nonces ∧ a.seq_number ∉ s.used_seqs :=
  ⟨h.2.1, h.2.2⟩

end X402Aptos
