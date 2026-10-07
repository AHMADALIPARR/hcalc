/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

Minimal Real stub (no Mathlib). Infrastructure Gap-Real-arith only.
Production domain symbols are defs in other modules (PRODUCTION.md).
-/

namespace Hcalc

axiom Real : Type
axiom realZero : Real
axiom realOne : Real
axiom realAdd : Real → Real → Real
axiom realMul : Real → Real → Real
axiom realNeg : Real → Real
axiom realAbs : Real → Real
axiom realLt : Real → Real → Prop
axiom realDiv : Real → Real → Real
axiom natToReal : Nat → Real
axiom realLog : Real → Real
axiom realMin : Real → Real → Real
axiom finMax : {n : Nat} → (Fin n → Real) → Real

noncomputable instance : Zero Real := ⟨realZero⟩
noncomputable instance : One Real := ⟨realOne⟩
noncomputable instance : Add Real := ⟨realAdd⟩
noncomputable instance : Mul Real := ⟨realMul⟩
noncomputable instance : Neg Real := ⟨realNeg⟩

noncomputable def realSub (a b : Real) : Real := realAdd a (realNeg b)
noncomputable instance : Sub Real := ⟨realSub⟩

infix:50 " <ᵣ " => realLt
notation "‖" x "‖ᵣ" => realAbs x
def realLe (a b : Real) : Prop := realLt a b ∨ a = b
infix:50 " ≤ᵣ " => realLe

axiom real_add_comm (a b : Real) : a + b = b + a
axiom real_add_assoc (a b c : Real) : (a + b) + c = a + (b + c)
axiom real_mul_comm (a b : Real) : a * b = b * a
axiom real_mul_assoc (a b c : Real) : (a * b) * c = a * (b * c)
axiom real_zero_add (a : Real) : (0 : Real) + a = a
axiom real_add_zero (a : Real) : a + (0 : Real) = a
axiom real_one_mul (a : Real) : (1 : Real) * a = a
axiom real_mul_one (a : Real) : a * (1 : Real) = a
axiom real_zero_mul (a : Real) : (0 : Real) * a = (0 : Real)
axiom real_mul_zero (a : Real) : a * (0 : Real) = (0 : Real)
axiom real_neg_add_cancel (a : Real) : a + (-a) = (0 : Real)
axiom real_abs_nonneg (a : Real) : (0 : Real) ≤ᵣ ‖a‖ᵣ
axiom real_abs_zero : ‖(0 : Real)‖ᵣ = (0 : Real)
axiom real_abs_abs (a : Real) : ‖‖a‖ᵣ‖ᵣ = ‖a‖ᵣ
axiom real_lt_irrefl (a : Real) : ¬ (a <ᵣ a)
axiom real_lt_asymm {a b : Real} : a <ᵣ b → ¬ b <ᵣ a
axiom real_abs_eq_zero_iff (a : Real) : ‖a‖ᵣ = (0 : Real) ↔ a = (0 : Real)
axiom real_mul_add (a b c : Real) : a * (b + c) = a * b + a * c
axiom real_abs_mul (a b : Real) : ‖a * b‖ᵣ = ‖a‖ᵣ * ‖b‖ᵣ
axiom natToReal_pos {n : Nat} (h : 0 < n) : (0 : Real) <ᵣ natToReal n
axiom natToReal_zero : natToReal 0 = (0 : Real)
axiom natToReal_one : natToReal 1 = (1 : Real)
axiom softScaleFactor : Real → Real → Real
axiom softScaleFactor_of_le (ε q : Real)
    (_h : q <ᵣ ((1 : Real) - ε) ∨ q = ((1 : Real) - ε)) :
    softScaleFactor ε q = (1 : Real)
axiom softScaleFactor_of_gt (ε q : Real)
    (_h : ((1 : Real) - ε) <ᵣ q) :
    softScaleFactor ε q = realDiv ((1 : Real) - ε) q
axiom realMin_le_left (a b : Real) : realMin a b ≤ᵣ a
axiom realMin_le_right (a b : Real) : realMin a b ≤ᵣ b
axiom finMax_abs_eq_zero_of {n : Nat} (x : Fin n → Real)
    (h : finMax (fun j => ‖x j‖ᵣ) = (0 : Real)) : ∀ j, x j = (0 : Real)
axiom real_contract_force_zero (a q : Real)
    (hnn : (0 : Real) ≤ᵣ a) (hq : q <ᵣ (1 : Real)) (hle : a ≤ᵣ q * a) : a = (0 : Real)
axiom real_le_of_eq (a b : Real) (h : a = b) : a ≤ᵣ b
axiom deltaGuard : Real
axiom deltaGuard_pos : (0 : Real) <ᵣ deltaGuard
axiom tolDefault : Real
axiom tolDefault_pos : (0 : Real) <ᵣ tolDefault
noncomputable def epsDefault : Real := realDiv realOne (natToReal 20)
noncomputable def oneSub (ε : Real) : Real := (1 : Real) - ε

theorem real_sub_self (a : Real) : a - a = (0 : Real) := by
  change a + (-a) = (0 : Real)
  exact real_neg_add_cancel a

abbrev Scalar := Real

end Hcalc
