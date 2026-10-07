/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

Structural invariants only. Domain-specific claims are axioms (Gap-*)
or theorems with those properties as hypotheses — no invented physics.
-/

import Hcalc.Pipeline

namespace Hcalc.Invariants

open Hcalc Pipeline

/-- A state predicate preserved by nested `step` for all times / primes / scalars. -/
def IsInvariant (P : State → Prop) : Prop :=
  ∀ (t : Time) (x : State) (p : Nat) (Λm : Scalar),
    P x → P (step t x p Λm)

/-- `True` (as a state predicate) is invariant. -/
theorem true_invariant : IsInvariant (fun _ => True) := by
  intro t x p Λm hx
  trivial

/-- Intersection (pointwise ∧) of invariants is invariant. -/
theorem invariant_and (P Q : State → Prop)
    (hP : IsInvariant P) (hQ : IsInvariant Q) :
    IsInvariant (fun x => P x ∧ Q x) := by
  intro t x p Λm hx
  exact ⟨hP t x p Λm hx.1, hQ t x p Λm hx.2⟩

/-- Invariance under a restricted prime set (structural weakening). -/
def IsInvariantOnPrimes (P : State → Prop) (Allowed : Nat → Prop) : Prop :=
  ∀ (t : Time) (x : State) (p : Nat) (Λm : Scalar),
    Allowed p → P x → P (step t x p Λm)

theorem invariant_implies_on_primes (P : State → Prop) (Allowed : Nat → Prop)
    (h : IsInvariant P) : IsInvariantOnPrimes P Allowed := by
  intro t x p Λm _ hx
  exact h t x p Λm hx

/-- P64-restricted invariant (ties to Inv-P64 structurally). -/
def IsInvariantOnP64 (P : State → Prop) : Prop :=
  IsInvariantOnPrimes P primeIndexFromP64

theorem invariant_implies_on_P64 (P : State → Prop) (h : IsInvariant P) :
    IsInvariantOnP64 P :=
  invariant_implies_on_primes P primeIndexFromP64 h

/-- False is not forced as invariant without hypotheses (witness: we do not claim it). -/
-- Structural: if a predicate never holds, invariance is vacuous on the antecedent.
theorem vacuous_invariant (P : State → Prop) (hNever : ∀ x, ¬ P x) :
    IsInvariant P := by
  intro t x p Λm hx
  exact (hNever x hx).elim

end Hcalc.Invariants
