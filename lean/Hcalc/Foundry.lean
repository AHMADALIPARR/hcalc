/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

Foundry instantiation layer (L1–L4): DISTINCT from HCALC nested pipeline.
FoundryAdditive (prop 39) remains separate from InstanceBridge (PRODUCTION.md §6).
Cite: FOUNDRY_J_CROSSLINKS, foundry-j PROPERTIES 23, 33–34, 39, 42–43.
-/

import Hcalc.RealStub
import Hcalc.Carrier

namespace Hcalc.Foundry

open Hcalc

/-! ## L1: P64 — first 64 primes (PROPERTIES 23) — definition (data) -/

/-- The first 64 primes, PROPERTIES **23** / `types.h:24–30`. -/
def p64List : List Nat :=
  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71,
   73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151,
   157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233,
   239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311]

theorem p64List_length : p64List.length = 64 := by native_decide

/-- `P64 : Fin 64 → ℕ` (Lean L1). -/
def P64 (i : Fin 64) : Nat :=
  p64List.get ⟨i.val, by
    have h := p64List_length
    omega⟩

theorem P64_zero : P64 ⟨0, by omega⟩ = 2 := by native_decide
theorem P64_one : P64 ⟨1, by omega⟩ = 3 := by native_decide
theorem P64_last : P64 ⟨63, by omega⟩ = 311 := by native_decide

/-! ## Foundry carrier stubs (opaque; FoundryAdditive path — ≠ HCALC Carrier) -/

/-- GapId: Gap-Foundry-StateOps — Foundry recurrence carrier (not HCALC `Carrier`). -/
axiom State : Type
/-- GapId: Gap-Foundry-StateOps (infrastructure for L3/L4). -/
axiom State.add : State → State → State
/-- GapId: Gap-Foundry-StateOps -/
axiom State.smul : Scalar → State → State
/-- GapId: Gap-Foundry-StateOps -/
axiom State.zero : State

noncomputable instance : Add State := ⟨State.add⟩
noncomputable instance : Zero State := ⟨State.zero⟩

/-- Schedule weight (Foundry Ξ_t / Λ_t abstracted to Scalar). -/
abbrev Weight := Scalar

/-- Nonlinear hook `T` in Foundry recurrence (≠ HCALC `Tp`). -/
abbrev Nonlinear := State → State

/-! ## L2: Gershgorin bound / contractiveG (PROPERTIES 33–34) -/

/-- Square matrix as function of indices (no Mathlib Matrix). -/
def Mat (n : Nat) := Fin n → Fin n → Scalar

/-- Row radius excluding diagonal: Σ_{j≠i} |J_ij|. -/
noncomputable def rowRadius {n : Nat} (J : Mat n) (i : Fin n) : Scalar :=
  Fin.foldl n (fun acc j =>
    if j = i then acc else acc + ‖J i j‖ᵣ) (0 : Scalar)

/-- Disk max for row i: |J_ii| + rowRadius. -/
noncomputable def diskMax {n : Nat} (J : Mat n) (i : Fin n) : Scalar :=
  ‖J i i‖ᵣ + rowRadius J i

/-- Gershgorin disk bound = max over rows of diskMax (PROPERTIES **33**). -/
noncomputable def gershgorinBound {n : Nat} (J : Mat n) : Scalar :=
  finMax (fun i => diskMax J i)

/-- `contractiveG J ε ↔ gershgorinBound J < 1 - ε` (PROPERTIES **34**). -/
noncomputable def contractiveG {n : Nat} (J : Mat n) (ε : Scalar) : Prop :=
  gershgorinBound J <ᵣ ((1 : Scalar) - ε)

/-- Definitional unfolding: contractiveG is exactly the Gershgorin inequality. -/
theorem contractiveG_iff {n : Nat} (J : Mat n) (ε : Scalar) :
    contractiveG J ε ↔ gershgorinBound J <ᵣ ((1 : Scalar) - ε) :=
  Iff.rfl

/-! ## L3: FoundryStep — exact PROPERTIES 39; ≠ HCALC nested / InstanceBridge -/

/--
Foundry additive Banach step (PROPERTIES **39** / FoundryAdditive):
`x' = Ξ • x + Λ • T(x) + g`.

**Distinct** from HCALC `hcalcStep` and from InstanceBridge (PRODUCTION.md §6).
Do not identify with nested form.
-/
noncomputable def FoundryStep (Ξ Λ : Weight) (T : Nonlinear) (g x : State) : State :=
  State.smul Ξ x + State.smul Λ (T x) + g

/-! ## L4: qEstimate / softProject (PROPERTIES 42–43, abstracted) -/

/-- GapId: Gap-Foundry-Norm (infrastructure). -/
axiom weightNorm : Weight → Scalar
/-- GapId: Gap-Foundry-Norm -/
axiom nonlinearNorm : Nonlinear → State → Scalar

/-- Abstracted q-estimate (PROPERTIES **42**). -/
noncomputable def qEstimate (Ξ Λ : Weight) (T : Nonlinear) (x : State) : Scalar :=
  weightNorm Ξ + weightNorm Λ * nonlinearNorm T x

/-- Soft-project scales (PROPERTIES **43**). -/
structure SoftScales where
  xi : Weight
  lam : Weight

/-- GapId: Gap-Foundry-Div (infrastructure) — Real division alias. -/
noncomputable def realDiv (a b : Scalar) : Scalar := Hcalc.realDiv a b

/-- GapId: Gap-Foundry-SoftScale — Foundry schedule soft_project scale (props 42–43).
NOT identical to HCALC in-step `C` (which uses softScaleFactor as Spec wiring only). -/
noncomputable def softProjectScale (ε q : Scalar) : Scalar := softScaleFactor ε q

theorem softProjectScale_of_le (ε q : Scalar)
    (h : q <ᵣ ((1 : Scalar) - ε) ∨ q = ((1 : Scalar) - ε)) :
    softProjectScale ε q = (1 : Scalar) :=
  softScaleFactor_of_le ε q h

theorem softProjectScale_of_gt (ε q : Scalar)
    (h : ((1 : Scalar) - ε) <ᵣ q) :
    softProjectScale ε q = Hcalc.realDiv ((1 : Scalar) - ε) q :=
  softScaleFactor_of_gt ε q h

/-- Soft-project: scale Ξ, Λ by `softProjectScale ε q` (PROPERTIES **43**). -/
noncomputable def softProject (ε : Scalar) (Ξ Λ : Weight) (T : Nonlinear) (x : State) :
    SoftScales :=
  let q := qEstimate Ξ Λ T x
  let s := softProjectScale ε q
  ⟨Ξ * s, Λ * s⟩

/-- When q ≤ 1-ε, soft-project leaves Ξ unchanged (via scale=1). -/
theorem softProject_xi_of_le (ε : Scalar) (Ξ Λ : Weight) (T : Nonlinear) (x : State)
    (h : (qEstimate Ξ Λ T x) <ᵣ ((1 : Scalar) - ε) ∨
         (qEstimate Ξ Λ T x) = ((1 : Scalar) - ε)) :
    (softProject ε Ξ Λ T x).xi = Ξ * (1 : Scalar) := by
  simp [softProject, softProjectScale_of_le ε _ h]

end Hcalc.Foundry
