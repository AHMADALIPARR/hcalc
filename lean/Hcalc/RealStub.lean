/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

Minimal Real stub (no Mathlib). First-cut choice: skip Mathlib download;
axiomatize only what L2/L4/L5 need. Spec may later require Mathlib Real.
-/

namespace Hcalc

/-- GapId: Gap-Real-arith — opaque real line (Mathlib `Real` deferred). -/
axiom Real : Type

/-- GapId: Gap-Real-arith -/
axiom realZero : Real
/-- GapId: Gap-Real-arith -/
axiom realOne : Real
/-- GapId: Gap-Real-arith -/
axiom realAdd : Real → Real → Real
/-- GapId: Gap-Real-arith -/
axiom realMul : Real → Real → Real
/-- GapId: Gap-Real-arith -/
axiom realNeg : Real → Real
/-- GapId: Gap-Real-arith -/
axiom realAbs : Real → Real
/-- GapId: Gap-Real-arith -/
axiom realLt : Real → Real → Prop
/-- GapId: Gap-Real-arith -/
axiom realDiv : Real → Real → Real

noncomputable instance : Zero Real := ⟨realZero⟩
noncomputable instance : One Real := ⟨realOne⟩
noncomputable instance : Add Real := ⟨realAdd⟩
noncomputable instance : Mul Real := ⟨realMul⟩
noncomputable instance : Neg Real := ⟨realNeg⟩

noncomputable def realSub (a b : Real) : Real := realAdd a (realNeg b)
noncomputable instance : Sub Real := ⟨realSub⟩

/-- Notation for comparison. -/
infix:50 " <ᵣ " => realLt

/-- Absolute value sugar. -/
notation "‖" x "‖ᵣ" => realAbs x

/-- Non-strict order from lt. -/
def realLe (a b : Real) : Prop := realLt a b ∨ a = b
infix:50 " ≤ᵣ " => realLe

/-! ### Gap-Real-arith — basic Real facts absent Mathlib -/

/-- GapId: Gap-Real-arith (infrastructure). -/
axiom real_add_comm (a b : Real) : a + b = b + a
/-- GapId: Gap-Real-arith -/
axiom real_add_assoc (a b c : Real) : (a + b) + c = a + (b + c)
/-- GapId: Gap-Real-arith -/
axiom real_mul_comm (a b : Real) : a * b = b * a
/-- GapId: Gap-Real-arith -/
axiom real_zero_add (a : Real) : (0 : Real) + a = a
/-- GapId: Gap-Real-arith -/
axiom real_one_mul (a : Real) : (1 : Real) * a = a
/-- GapId: Gap-Real-arith -/
axiom real_abs_nonneg (a : Real) : (0 : Real) ≤ᵣ ‖a‖ᵣ
/-- GapId: Gap-Real-arith -/
axiom real_lt_irrefl (a : Real) : ¬ (a <ᵣ a)

/-- Scalar synonym used by HCALC / Foundry schedules. -/
abbrev Scalar := Real

end Hcalc
