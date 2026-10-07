/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

Convergence / stability ONLY with explicit hypotheses.
Do not assert that HCALC converges unconditionally (Gap-Converge).
L5 Foundry Banach: unfinished axiom labeled Gap-Converge — no silent PASS / no sorry.
L7 deferred (Gap-ShapeMap / G-SHAPE).
-/

import Hcalc.Axioms
import Hcalc.Foundry
import Hcalc.Pipeline

namespace Hcalc.Convergence

open Hcalc Pipeline Foundry

/-! ## Named hypothesis bundles (Gap-Converge) -/

/-- Explicit contractivity hypothesis on an opaque Lipschitz / q bound. -/
structure HypothesisContractive where
  q : Scalar
  ε : Scalar
  q_lt : q <ᵣ ((1 : Scalar) - ε)

/-- Explicit boundedness hypothesis (placeholder carrier bound). -/
structure HypothesisBounded where
  bound : Scalar
  /-- GapId: Gap-Converge — witness that states stay under `bound` (opaque Prop). -/
  bounded : Prop

/-- Residual tolerance hypothesis (Foundry residual **46** style). -/
structure HypothesisResidual where
  tol : Scalar
  /-- GapId: Gap-Converge -/
  tol_pos : (0 : Scalar) <ᵣ tol

/-! ## L5 — Foundry Banach unique FP (unfinished axiom; explicit hyps) -/

/-- Fixed-point predicate for a Foundry self-map. -/
def IsFoundryFixedPoint (F : Foundry.State → Foundry.State) (x : Foundry.State) : Prop :=
  F x = x

/-- GapId: Gap-Converge — L5 Foundry narrative (PROPERTIES **41**): unique fixed point
when `q < 1-ε`. Unfinished axiom with explicit hypotheses — NOT a silent theorem PASS.
Does **not** claim nested HCALC convergence. -/
axiom foundry_banach_unique_fixed_point
    (F : Foundry.State → Foundry.State)
    (h : HypothesisContractive)
    (hypothesis_complete : Prop)
    (hypothesis_F_uses_q : Prop) :
    ∃ x : Foundry.State, IsFoundryFixedPoint F x ∧
      ∀ y : Foundry.State, IsFoundryFixedPoint F y → y = x

/-! ## Nested HCALC: only conditional statements -/

/-- GapId: Gap-Converge — opaque "trajectory converges" predicate (no invented metric). -/
axiom Converges : (Nat → State) → Prop

/-- GapId: Gap-Converge — opaque "stable about fixed point" predicate. -/
axiom StableAbout : State → (Nat → State) → Prop

/-- GapId: Gap-Converge — IF nested contractive + complete + residual hyps THEN converges.
Not an unconditional claim. -/
axiom nested_converges_of_hypotheses
    (traj : Nat → State)
    (hC : hypothesis_nested_contractive)
    (hComplete : hypothesis_nested_complete)
    (hRes : HypothesisResidual)
    (_ : hypothesis_residual_tol hRes.tol) :
    Converges traj

/-- GapId: Gap-Converge — IF contractive + bounded THEN stable about a given point
(only under named hypotheses). -/
axiom nested_stable_of_hypotheses
    (xStar : State)
    (traj : Nat → State)
    (hC : HypothesisContractive)
    (hB : HypothesisBounded) :
    StableAbout xStar traj

/-- Structural: HypothesisContractive packs `q < 1-ε`. -/
theorem HypothesisContractive.q_lt_one_sub_eps (h : HypothesisContractive) :
    h.q <ᵣ ((1 : Scalar) - h.ε) :=
  h.q_lt

/-- Structural: Foundry `contractiveG` matches L2 definitional form under hyps. -/
theorem contractiveG_from_bound {n : Nat} (J : Mat n) (ε : Scalar)
    (h : gershgorinBound J <ᵣ ((1 : Scalar) - ε)) :
    contractiveG J ε :=
  (contractiveG_iff J ε).mpr h

end Hcalc.Convergence
