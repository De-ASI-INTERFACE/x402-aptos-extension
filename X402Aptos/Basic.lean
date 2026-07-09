-- x402-Aptos Basic | Author: Richard Patterson (@De-ASI-INTERFACE)
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Nat.Basic

namespace X402Aptos

structure PaymentAuth where
  sequence_number : Nat
  amount          : Nat
  expiration_ts   : Nat
  deriving Repr, DecidableEq

structure AccountState where
  current_sequence : Nat
  block_time       : Nat
  deriving Repr

def verify (a : PaymentAuth) (s : AccountState) : Prop :=
  a.sequence_number = s.current_sequence ∧ s.block_time ≤ a.expiration_ts

theorem aptos_seq_valid (a : PaymentAuth) (s : AccountState) (h : verify a s)
    : a.sequence_number = s.current_sequence := h.1

theorem aptos_not_expired (a : PaymentAuth) (s : AccountState) (h : verify a s)
    : s.block_time ≤ a.expiration_ts := h.2

end X402Aptos
