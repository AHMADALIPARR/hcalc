/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

Structural invariants for production nested `step`.
-/

import Hcalc.Pipeline

namespace Hcalc.Invariants

open Hcalc Pipeline

/-- Predicate preserved by nested `step` for all times / ε / δ. -/
def IsInvariant {n : Nat} (P : Carrier n → Prop) : Prop :=
  ∀ (ε δ : Scalar) (t : Time) (x : Carrier n),
    P x → P (step (n := n) ε δ t x)

theorem true_invariant {n : Nat} : IsInvariant (n := n) (fun _ => True) := by
  intro ε δ t x hx
  trivial

theorem invariant_and {n : Nat} (P Q : Carrier n → Prop)
    (hP : IsInvariant (n := n) P) (hQ : IsInvariant (n := n) Q) :
    IsInvariant (n := n) (fun x => P x ∧ Q x) := by
  intro ε δ t x hx
  exact ⟨hP ε δ t x hx.1, hQ ε δ t x hx.2⟩

/-- Invariance under production defaults. -/
def IsInvariantProd {n : Nat} (P : Carrier n → Prop) : Prop :=
  ∀ (t : Time) (x : Carrier n), P x → P (stepProd (n := n) t x)

theorem invariant_implies_prod {n : Nat} (P : Carrier n → Prop)
    (h : IsInvariant (n := n) P) : IsInvariantProd (n := n) P := by
  intro t x hx
  exact h epsProd deltaProd t x hx

end Hcalc.Invariants
