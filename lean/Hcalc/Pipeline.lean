/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

HCALC nested one-step map using L6 axioms only.
X_{t+1} = Ξ(t, Λm · C[T_p(X_t)]).
DISTINCT from Foundry.FoundryStep (Gap-ShapeMap / L7 omitted).
-/

import Hcalc.Axioms

namespace Hcalc.Pipeline

open Hcalc
open Foundry

/--
One-step nested HCALC evolution:
`step t x p Λm = Xi t (scalarMul Λm (C (Tp p x)))`.
-/
noncomputable def step (t : Time) (x : State) (p : Nat) (Λm : Scalar) : State :=
  Xi t (scalarMul Λm (C (Tp p x)))

/-- Same with the global opaque `Lambda_m` parameter. -/
noncomputable def stepΛ (t : Time) (x : State) (p : Nat) : State :=
  step t x p Lambda_m

/-- Definitional: step unfolds to the nested composition. -/
theorem step_eq (t : Time) (x : State) (p : Nat) (Λm : Scalar) :
    step t x p Λm = Xi t (scalarMul Λm (C (Tp p x))) :=
  rfl

/-- Definitional: stepΛ uses the opaque `Lambda_m`. -/
theorem stepΛ_eq (t : Time) (x : State) (p : Nat) :
    stepΛ t x p = step t x p Lambda_m :=
  rfl

/-- Intermediate after contraction, before evolution. -/
noncomputable def contracted (x : State) (p : Nat) (Λm : Scalar) : Intermediate :=
  scalarMul Λm (C (Tp p x))

theorem step_eq_Xi_contracted (t : Time) (x : State) (p : Nat) (Λm : Scalar) :
    step t x p Λm = Xi t (contracted x p Λm) :=
  rfl

/--
Prime-index integrity hypothesis (structural): `p` is drawn from P64.
Not proved here — callers discharge via `Hcalc.Foundry.P64`.
-/
def primeIndexFromP64 (p : Nat) : Prop :=
  ∃ i : Fin 64, Hcalc.Foundry.P64 i = p

/-- Step under an explicit P64-index hypothesis (composition identity only). -/
theorem step_of_P64 (t : Time) (x : State) (i : Fin 64) (Λm : Scalar) :
    step t x (Hcalc.Foundry.P64 i) Λm = Xi t (scalarMul Λm (C (Tp (Hcalc.Foundry.P64 i) x))) :=
  rfl

end Hcalc.Pipeline
