/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

L5 / Gap-Converge CLOSED under HypContractive (PRODUCTION.md §8).
Unique fixed point for nested step; residual lemmas. Freehand calc proofs; Mathlib ℝ.
-/

import Hcalc.Axioms
import Hcalc.Foundry
import Hcalc.Pipeline

namespace Hcalc.Convergence

open Hcalc Pipeline Foundry

/-! ## Hypothesis bundles -/

/--
HypContractive (PRODUCTION.md §8):
  |ξ| · ‖Λm · (C ∘ Tp)‖_op < 1 - ε
Packaged as an explicit Lipschitz bound with `q < 1` (strict contraction).
-/
structure HypContractive {n : Nat} (ε : Scalar) (F : Carrier n → Carrier n) where
  q : Scalar
  /-- Production margin form: q < 1 - ε. -/
  q_lt_margin : q <ᵣ ((1 : Scalar) - ε)
  /-- Strict contraction modulus: q < 1. -/
  q_lt_one : q <ᵣ (1 : Scalar)
  /-- Lipschitz: ‖F x - F y‖_∞ ≤ q · ‖x - y‖_∞. -/
  lip : ∀ x y : Carrier n, ‖vsub (F x) (F y)‖∞ ≤ᵣ q * ‖vsub x y‖∞

/-- Fixed-point predicate. -/
def IsFixedPoint {n : Nat} (F : Carrier n → Carrier n) (x : Carrier n) : Prop :=
  F x = x

/-- Structural: HypContractive packs `q < 1 - ε`. -/
theorem HypContractive.q_lt_one_sub_eps {n : Nat} {ε : Scalar} {F : Carrier n → Carrier n}
    (h : HypContractive (n := n) ε F) :
    h.q <ᵣ ((1 : Scalar) - ε) :=
  h.q_lt_margin

-- ℓ∞ nonneg: see `Hcalc.linf_nonneg` (Carrier).

/-! ## L5 — uniqueness of fixed point under HypContractive -/

/--
L5 uniqueness (PRODUCTION.md §8): a strict ℓ∞ contraction has at most one fixed point.
-/
theorem unique_fixed_point {n : Nat} {ε : Scalar} {F : Carrier n → Carrier n}
    (h : HypContractive (n := n) ε F)
    (x y : Carrier n)
    (hx : IsFixedPoint F x) (hy : IsFixedPoint F y) : x = y := by
  unfold IsFixedPoint at hx hy
  have hlip := h.lip x y
  have hrew : vsub (F x) (F y) = vsub x y := by
    rw [hx, hy]
  rw [hrew] at hlip
  have hnn : (0 : Real) ≤ᵣ ‖vsub x y‖∞ := linf_nonneg (vsub x y)
  have hzero : ‖vsub x y‖∞ = (0 : Real) :=
    real_contract_force_zero ‖vsub x y‖∞ h.q hnn h.q_lt_one hlip
  exact carrier_ext_of_linf_sub_eq_zero x y hzero

/-! ## Residual lemmas -/

/-- At a fixed point, residual is zero. -/
theorem residual_at_fixed_point {n : Nat} (F : Carrier n → Carrier n) (x : Carrier n)
    (hx : IsFixedPoint F x) : evalOptObj F x = (0 : Real) := by
  unfold evalOptObj residualNorm IsFixedPoint at *
  have : vsub x (F x) = vzero n := by
    funext j
    change x j - (F x) j = (0 : Real)
    rw [hx]
    exact real_sub_self (x j)
  rw [this, linf_vzero]

/-- Existence under zero kick: stabilized (linear through origin) fixes 0. -/
theorem stabilized_fixes_zero {n : Nat} (ε δ : Scalar) :
    IsFixedPoint (stabilized (n := n) ε δ) (vzero n) := by
  unfold IsFixedPoint stabilized C_circ_Tp C Tp vsmul vzero
  funext j
  -- (Λm * (cScale * (α * 0))) = 0
  simp only [real_mul_zero]

/-- L5 existence+uniqueness for stabilized under Hyp: unique FP is 0. -/
theorem unique_fp_stabilized_of_hyp {n : Nat} {ε δ : Scalar}
    (h : HypContractive (n := n) ε (stabilized (n := n) ε δ)) :
    IsFixedPoint (stabilized (n := n) ε δ) (vzero n) ∧
      ∀ y : Carrier n, IsFixedPoint (stabilized (n := n) ε δ) y → y = vzero n := by
  refine ⟨stabilized_fixes_zero (n := n) ε δ, ?_⟩
  intro y hy
  exact unique_fixed_point h y (vzero n) hy (stabilized_fixes_zero (n := n) ε δ)

/-- Nested step under Uniform+zero kick equals stabilized; zero is a fixed point. -/
theorem step_fixes_zero {n : Nat} (ε δ : Scalar) (t : Time) :
    IsFixedPoint (step (n := n) ε δ t) (vzero n) := by
  unfold IsFixedPoint
  rw [step_eq_stabilized]
  exact stabilized_fixes_zero (n := n) ε δ

/-- L5 for nested `step` under HypContractive. -/
theorem unique_fp_step_of_hyp {n : Nat} {ε δ : Scalar} (t : Time)
    (h : HypContractive (n := n) ε (step (n := n) ε δ t)) :
    IsFixedPoint (step (n := n) ε δ t) (vzero n) ∧
      ∀ y : Carrier n, IsFixedPoint (step (n := n) ε δ t) y → y = vzero n := by
  refine ⟨step_fixes_zero (n := n) ε δ t, ?_⟩
  intro y hy
  exact unique_fixed_point h y (vzero n) hy (step_fixes_zero (n := n) ε δ t)

/-- Residual of step at 0 is 0. -/
theorem J_at_zero {n : Nat} (ε δ : Scalar) (t : Time) :
    J (n := n) ε δ t (vzero n) = (0 : Real) :=
  residual_at_fixed_point (step (n := n) ε δ t) (vzero n) (step_fixes_zero (n := n) ε δ t)

/-- Foundry `contractiveG` matches L2 definitional form under hyps. -/
theorem contractiveG_from_bound {n : Nat} (Jmat : Mat n) (ε : Scalar)
    (h : gershgorinBound Jmat <ᵣ ((1 : Scalar) - ε)) :
    contractiveG Jmat ε :=
  (contractiveG_iff Jmat ε).mpr h

end Hcalc.Convergence
