<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# Remaining Lean work after L1–L6 axioms

What is left **after** accepting L6 opaque symbols. No fake proof claims.

## Deferred / blocked

| Item | Why blocked |
|------|-------------|
| **L7** bridge `HCALCStep ≃ FoundryStep` | Requires Spec discharge of **G-SHAPE / Gap-ShapeMap**; additive ≠ nested |
| Unique Banach fixed point (**L5** full) | Narrative PROPERTIES **41**; needs discharged `q &lt; 1-ε` + complete metric structure |
| ℝ-valued Λm / spectral radius theorems | No Mathlib in first cut; Nat proxies only |
| Matrix Gershgorin proof of **A2** | Needs Jacobian carrier + Mathlib analysis |
| PMAT conservation (**A5**) in Lean | Optional Foundry surface; not HCALC-core |
| Guardian (**A6**) in Lean | Prop 55; Core verb may be absent |

## Open research (Spec must define before Lean can prove)

1. Explicit scalar Λm and stabilizing range (**G-Lm**).
2. Formal Ξ(t,·) operator laws (**Gap-Ξ**).
3. Tensor / Banach / F_p carrier for X_t (**Gap-Carrier**).
4. Convergence conditions for **nested** form (**Gap-Converge**).
5. In-step contraction algorithm realizing C (**G-C**, **Gap-ContractAlg**).
6. Optimization objective J (**Gap-OptObj**).
7. Construction of T_p from P64 / PrimeMask / PMAT (**G-Tp**).
8. Shape-map morphism nested ↔ additive (**G-SHAPE**).

## Safe next Lean increments (no invention)

- Port A5/A6 as optional gated modules once Spec marks them in-scope.
- Replace Nat proxies with Mathlib ℝ **after** Spec freezes types.
- Prove list properties of `P64List` (pairwise distinct, true primality) as data lemmas.
- Strengthen `iterateNested` induction lemmas under explicit measure hypotheses (when Gap-ContractAlg closes).
