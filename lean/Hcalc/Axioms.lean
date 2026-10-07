/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

L6 uninterpreted symbols + named Gap-* axioms (COHERENCE.md / AXIOMS.md).
L7 Gap-ShapeMap bridge OMITTED (blocked until Spec defines HCALC LHS).
FoundryStep and HCALC nested step are DISTINCT theories — no identification.
-/

import Hcalc.RealStub
import Hcalc.Foundry

namespace Hcalc

/-! ## Gap-Carrier — state / time / intermediate carriers -/

/-- GapId: Gap-Carrier — explicit tensor / Banach / F_p carrier for X_t (undeclared). -/
axiom State : Type

/-- GapId: Gap-Carrier — discrete time index for Ξ(t, ·). -/
axiom Time : Type

/-- GapId: Gap-Carrier — intermediate carrier after C[T_p(·)] (before Ξ). -/
axiom Intermediate : Type

/-! ## L6 — opaque HCALC pipeline symbols (do not invent formulas) -/

/--
GapId: Gap-Tp-from-P64 —
Prime-indexed transform T_p. Construction from P_64 is opaque;
candidates (PrimeMask / PMAT / T_hook) ≠ definition. Index integrity:
callers may hypothesize `p = Foundry.P64 i` (A1/L1).
-/
axiom Tp : Nat → State → Intermediate

/--
GapId: Gap-C-wrapper —
In-step contraction wrapper C[·]. Spectral classify / gershgorin /
power_iteration / soft_project / q_estimate are post-hoc ≠ C.
-/
axiom C : Intermediate → Intermediate

/--
GapId: Gap-Λm-scalar —
Stabilizing scalar Λm (NOT Foundry lambda_schedule vector).
Role: candidate bound ‖Λm · (C ∘ T_p)‖ < 1-ε.
-/
axiom Lambda_m : Scalar

/-- GapId: Gap-Λm-scalar — scalar multiplication on Intermediate. -/
axiom scalarMul : Scalar → Intermediate → Intermediate

/--
GapId: Gap-Ξ —
HCALC evolution Ξ(t, ·) : Intermediate → State.
≠ Foundry xi_schedule weight vectors.
-/
axiom Xi : Time → Intermediate → State

/-! ## Norm bound placeholder for Λm role -/

/-- GapId: Gap-Λm-scalar — opaque operator norm of Intermediate → Intermediate maps. -/
axiom opNorm : (Intermediate → Intermediate) → Scalar

/-- Compose C after Tp at fixed prime index (as Intermediate→Intermediate on image). -/
noncomputable def C_circ_Tp (p : Nat) (x : State) : Intermediate :=
  C (Tp p x)

/--
GapId: Gap-Λm-scalar —
Candidate stability target: ‖Λm · (C ∘ T_p)‖ < 1-ε (hypothesis form, not theorem).
-/
noncomputable def hypothesis_Lambda_m_bound (_p : Nat) (ε : Scalar)
    (normOfScaled : Scalar) : Prop :=
  normOfScaled <ᵣ ((1 : Scalar) - ε)

/-! ## Remaining named gaps (uninterpreted / unfinished) -/

/--
GapId: Gap-ShapeMap —
Bridge nested HCALC ↔ additive Foundry39 is NOT identity.
L7 OMITTED: no axiom asserting HCALCStep = FoundryStep.
Theories remain distinct (separate types/defs in Pipeline vs Foundry).
-/
axiom shapeMap_exists_is_open : True

/--
GapId: Gap-ContractAlg —
Algorithm realizing C (not merely a contractive flag). Opaque until Spec closes.
-/
axiom ContractAlg : Type

/-- GapId: Gap-ContractAlg — witness that some algorithm implements C (uninterpreted). -/
axiom contractAlg_implements_C : ContractAlg → Prop

/--
GapId: Gap-OptObj —
Optimization objective J over traces / fixed points (uninterpreted).
-/
axiom OptObj : Type

/-- GapId: Gap-OptObj — evaluate objective on a state (opaque). -/
axiom evalOptObj : OptObj → State → Scalar

/--
GapId: Gap-Converge —
Nested-form convergence hypotheses (Banach unique FP, residual, monitor).
Foundry-side L5 narrative uses separate Foundry hypotheses; nested form stays open.
-/
axiom hypothesis_nested_contractive : Prop
/-- GapId: Gap-Converge -/
axiom hypothesis_nested_complete : Prop
/-- GapId: Gap-Converge -/
axiom hypothesis_residual_tol : Scalar → Prop

end Hcalc
