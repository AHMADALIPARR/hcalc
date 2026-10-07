/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

Foundry instantiation layer (L1–L4): DISTINCT from HCALC nested pipeline.
Do not equate FoundryStep with Hcalc.Pipeline.step (Gap-ShapeMap / L7 blocked).
Cite: FOUNDRY_J_CROSSLINKS, foundry-j PROPERTIES 23, 33–34, 39, 42–43.
-/

import Hcalc.RealStub

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

/-! ## Foundry carrier stubs (opaque; distinct from Gap-Carrier HCALC state) -/

/-- GapId: Gap-Foundry-StateOps — Foundry recurrence carrier (not HCALC `State`). -/
axiom State : Type
/-- GapId: Gap-Foundry-StateOps (infrastructure for L3/L4) — additive/smul structure on Foundry state. -/
axiom State.add : State → State → State
/-- GapId: Gap-Foundry-StateOps -/
axiom State.smul : Scalar → State → State
/-- GapId: Gap-Foundry-StateOps -/
axiom State.zero : State

noncomputable instance : Add State := ⟨State.add⟩
noncomputable instance : Zero State := ⟨State.zero⟩

/-- Schedule weight (Foundry Ξ_t / Λ_t length-2 vectors abstracted to Scalar max-abs). -/
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

/-- GapId: Gap-Foundry-FinMax (infrastructure) — max over Fin for Gershgorin bound. -/
axiom finMax : {n : Nat} → (Fin n → Scalar) → Scalar

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

/-! ## L3: FoundryStep — exact PROPERTIES 39; ≠ HCALC nested form -/

/--
Foundry additive Banach step (PROPERTIES **39**):
`x' = Ξ • x + Λ • T(x) + g`.

**Distinct** from HCALC `X_{t+1} = Ξ(t, Λm · C[T_p(X_t)])`.
Gap-ShapeMap / L7 bridge is **blocked** — do not identify.
-/
noncomputable def FoundryStep (Ξ Λ : Weight) (T : Nonlinear) (g x : State) : State :=
  State.smul Ξ x + State.smul Λ (T x) + g

/-! ## L4: qEstimate / softProject (PROPERTIES 42–43, abstracted) -/

/-- GapId: Gap-Foundry-Norm (infrastructure) — opaque max-abs style norms used in coded q-estimate. -/
axiom weightNorm : Weight → Scalar
/-- GapId: Gap-Foundry-Norm -/
axiom nonlinearNorm : Nonlinear → State → Scalar

/--
Abstracted q-estimate (PROPERTIES **42** narrative form):
`q = ‖Ξ‖ + ‖Λ‖ · ‖T‖` (Foundry coded max-abs details left to Core).
-/
noncomputable def qEstimate (Ξ Λ : Weight) (T : Nonlinear) (x : State) : Scalar :=
  weightNorm Ξ + weightNorm Λ * nonlinearNorm T x

/-- Soft-project scales (PROPERTIES **43**): if `q > 1-ε`, scale by `(1-ε)/q`. -/
structure SoftScales where
  xi : Weight
  lam : Weight

/-- GapId: Gap-Foundry-Div (infrastructure) — Real division for soft-project scale factor. -/
axiom realDiv : Scalar → Scalar → Scalar

/--
GapId: Gap-Foundry-SoftScale (infrastructure) —
Scale factor for PROPERTIES **43**: 1 when q ≤ 1-ε, else (1-ε)/q.
Opaque on undecidable Real order; branch laws are axioms.
-/
axiom softProjectScale : Scalar → Scalar → Scalar

/-- GapId: Gap-Foundry-SoftScale -/
axiom softProjectScale_of_le (ε q : Scalar)
    (_h : q <ᵣ ((1 : Scalar) - ε) ∨ q = ((1 : Scalar) - ε)) :
    softProjectScale ε q = (1 : Scalar)

/-- GapId: Gap-Foundry-SoftScale -/
axiom softProjectScale_of_gt (ε q : Scalar)
    (_h : ((1 : Scalar) - ε) <ᵣ q) :
    softProjectScale ε q = realDiv ((1 : Scalar) - ε) q

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
