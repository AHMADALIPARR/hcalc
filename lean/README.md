# HCALC Lean 4 formalization

**License:** AGPL-3.0-only (see [`LICENSE`](LICENSE))  
**Copyright (C) 2026 HCALC contributors**

First-cut Lean 4 formalization of the HCALC nested recurrence

\[
X_{t+1} = \Xi\bigl(t,\; \Lambda_m \cdot C[T_p(X_t)]\bigr)
\]

aligned with Spec [`../spec/COHERENCE.md`](../spec/COHERENCE.md), [`../spec/AXIOMS.md`](../spec/AXIOMS.md), [`../spec/INTERFACES.md`](../spec/INTERFACES.md).

## Layout

| File | Role |
|------|------|
| `Hcalc/RealStub.lean` | Minimal `Real` stub (**no Mathlib** — first-cut) |
| `Hcalc/Foundry.lean` | L1–L4 defs (P64, Gershgorin, FoundryStep, q/softProject); L5 unfinished |
| `Hcalc/Axioms.lean` | L6 opaque + named Gap-* (`Gap-Carrier`, `Gap-Λm-scalar`, …); **no L7** |
| `Hcalc/Pipeline.lean` | Nested HCALC `step` (≠ FoundryStep) |
| `Hcalc/Invariants.lean` | Structural invariants only |
| `Hcalc/Convergence.lean` | IF hypotheses THEN property; Gap-Converge explicit |

## Rules

- Zero `sorry` / `admit`. Gaps are **named axioms** (FAIL-open).
- Foundry additive step ≠ HCALC nested step (`Gap-ShapeMap` / L7 omitted).
- No unconditional convergence/stability claims.
- `Λm` is a **scalar** (not `lambda_schedule` vector); `C` ≠ spectral classify; `Tp` opaque given P64.

## Build

```bash
source ~/.elan/env   # or ensure ~/.elan/bin on PATH
cd /workspace/hcalc/lean
lake build
```

Toolchain: `leanprover/lean4:v4.34.1` (see `lean-toolchain`).

## Mathlib

**Not used** in this first cut (avoid long dependency fetch). `Real` and a few Fin/max/div helpers are axiomatized in `RealStub.lean` / `Foundry.lean`. Spec may later require Mathlib `Real` / `Nat.Prime`.
