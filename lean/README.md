# HCALC Lean 4 formalization (PRODUCTION)

**License:** AGPL-3.0-only (see [`LICENSE`](LICENSE))  
**Copyright (C) 2026 HCALC contributors**

Production formalization of the HCALC nested recurrence

\[
X_{t+1} = \Xi\bigl(t,\; \Lambda_m \cdot C(T_p(X_t))\bigr)
\]

frozen to Spec [`../spec/PRODUCTION.md`](../spec/PRODUCTION.md) (overrides provisional L6 axioms in COHERENCE/AXIOMS).

## Provenance

| Part | Source |
|------|--------|
| Carrier, Tp α-diag, C softScale-or-id, Λm min-formula, Ξ=ξy+g, J=residual, L5 Hyp, L7 InstanceBridge | **Spec-file** `PRODUCTION.md` |
| Option B InstanceBridge (not NestedFaithful / not rfl) | **Spec-file** PRODUCTION.md §6 (f5a08da) |
| Mathlib `ℝ` (thin bridge in `RealStub`) | Mathlib4 `v4.34.1` |
| Foundry L1–L4 (P64, Gershgorin, FoundryStep additive, softProject schedules) | Spec + Foundry PROPERTIES (FoundryAdditive **distinct**) |

## Mathlib

- **Toolchain:** `leanprover/lean4:v4.34.1` (matches Mathlib tag `v4.34.1` lean-toolchain — no bump needed).
- **Dependency:** `leanprover-community/mathlib` @ `v4.34.1`.
- **Imports used (minimal):**
  1. `Mathlib.Basic.Real.Basic` — `ℝ`, field/order/`abs`/`min`/`max`
  2. `Mathlib.Analysis.SpecialFunctions.Log.Basic` — `Real.log` (pulls Exp; Topology transitive only)
  - `finMax` uses core `Fin.foldl` only (no Finset / `Mathlib.Data.Fin`)
- No Topology / MeasureTheory / aesop / grind / large simp sets.
- Proofs are freehand `calc` / `rw` / `intro` / `apply` / elementary single-lemma `exact`.

### finMax / ℓ∞

`finMax` = `Fin.foldl` of `max` with init `0` (smallest surface; not `Finset.univ.sup'` / `iSup`).
Production sites pass nonnegative args (`|·|`, Gershgorin disks); `n = 0` yields `0`.

## Layout

| File | Role |
|------|------|
| `Hcalc/RealStub.lean` | Thin Mathlib `ℝ` re-exports + freehand Real lemmas (`finMax`, softScale, guards) |
| `Hcalc/Carrier.lean` | **Gap-Carrier CLOSED**: `Carrier n := Fin n → ℝ`, ℓ∞ |
| `Hcalc/Foundry.lean` | L1–L4 defs; FoundryAdditive `FoundryStep` (≠ nested); Gap-Foundry-* may remain |
| `Hcalc/Axioms.lean` | L6 **defs** Tp/C/Λm/Ξ/J/ContractAlg + **L7** `InstanceBridge` |
| `Hcalc/Pipeline.lean` | Nested `hcalcStep` / `step` / `J` / `optimize` |
| `Hcalc/Convergence.lean` | **L5** unique FP + residual under `HypContractive` |
| `Hcalc/Invariants.lean` | Structural invariants |
| `Hcalc/Production.lean` | Stable re-exports for Verify/docs |

## Rules

- Zero `sorry` / `admit`.
- Production Gap-* are **defs/theorems**, not opaque axioms.
- Gap-Real-arith for `Real` itself is **closed** (Mathlib `ℝ`). Gap-Foundry-* stubs OK if Foundry.State stays opaque.
- L7 = `InstanceBridge` Option B (parameter table + `toFoundryStep` diagnostic). **Not** `FoundryStep = hcalcStep`.
- C is state softScale-or-id; does **not** equal Foundry `softProject` on (Ξ,Λ) schedules.
- α (Tp weights) is Spec-only.
- No unconditional convergence — L5 under `HypContractive` only.

## Build

```bash
source ~/.elan/env
cd /workspace/hcalc/lean
lake update          # first time / after mathlib pin change
lake exe cache get    # download Mathlib oleans (recommended)
lake build 2>&1 | tee build.log
```

Toolchain: `leanprover/lean4:v4.34.1` + Mathlib `v4.34.1`.
