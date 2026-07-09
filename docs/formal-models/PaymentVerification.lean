-- x402-Aptos Payment Verification | Author: Richard Patterson
import X402Aptos.Basic

namespace X402Aptos.Verification

def settle (a : PaymentAuth) (s : AccountState) (h : verify a s) : AccountState :=
  { s with current_sequence := s.current_sequence + 1 }

theorem settled_sequence_incremented (a : PaymentAuth) (s : AccountState) (h : verify a s)
    : (settle a s h).current_sequence = s.current_sequence + 1 := by
  simp [settle]

end X402Aptos.Verification
