/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

HCALC nested one-step map (PRODUCTION.md):
  X_{t+1} = Ξ(t, Λm · C(Tp(X_t))).
DISTINCT from Foundry.FoundryStep / toFoundryStep (InstanceBridge ≠ identity).
-/

import Hcalc.Axioms

namespace Hcalc.Pipeline

open Hcalc

/--
One-step nested HCALC evolution (production verb `hcalcStep`):
`step ε δ t x = Xi t (Λm • C(Tp x))` with default zero kick.
-/
noncomputable def step {n : Nat} (ε δ : Scalar) (t : Time) (x : Carrier n) : Carrier n :=
  hcalcStepCore (n := n) ε δ t x (gDefault n)

/-- Production defaults ε=T2, δ=guard. -/
noncomputable def stepProd {n : Nat} (t : Time) (x : Carrier n) : Carrier n :=
  step (n := n) epsProd deltaProd t x

/-- Definitional: step unfolds to nested composition. -/
theorem step_eq {n : Nat} (ε δ : Scalar) (t : Time) (x : Carrier n) :
    step (n := n) ε δ t x =
      Xi (n := n) t (vsmul (LambdaM n ε δ) (C (n := n) ε (Tp x))) (gDefault n) :=
  rfl

/-- Under Uniform ξ=1 and g=0, step = stabilized branch. -/
theorem step_eq_stabilized {n : Nat} (ε δ : Scalar) (t : Time) (x : Carrier n) :
    step (n := n) ε δ t x = stabilized (n := n) ε δ x := by
  funext j
  simp only [step, hcalcStepCore, Xi_uniform_zero_kick, stabilized, C_circ_Tp]

/-- Intermediate after contraction, before evolution. -/
noncomputable def contracted {n : Nat} (ε δ : Scalar) (x : Carrier n) : Carrier n :=
  stabilized (n := n) ε δ x

theorem step_eq_Xi_contracted {n : Nat} (ε δ : Scalar) (t : Time) (x : Carrier n) :
    step (n := n) ε δ t x = Xi (n := n) t (contracted (n := n) ε δ x) (gDefault n) :=
  rfl

/-- OptObj residual for the nested step at time t. -/
noncomputable def J {n : Nat} (ε δ : Scalar) (t : Time) (x : Carrier n) : Scalar :=
  evalOptObj (step (n := n) ε δ t) x

/-- Optimize: iterate nested step `k` times. -/
noncomputable def optimize {n : Nat} (ε δ : Scalar) (t : Time) (k : Nat) (x : Carrier n) :
    Carrier n :=
  iterate (step (n := n) ε δ t) k x

/-- Stop when residual below production tol. -/
noncomputable def done {n : Nat} (ε δ : Scalar) (t : Time) (x : Carrier n) : Prop :=
  residualBelowTol (step (n := n) ε δ t) tolProd x

end Hcalc.Pipeline
