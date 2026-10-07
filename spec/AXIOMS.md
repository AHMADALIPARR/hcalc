<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Axiom Inventory

**Owner:** HCALC Spec agent  
**Consumers:** HCALC Lean (axioms / defs), HCALC Alloy (Provenance tags), Foundry J Verify (cite-only).  
**Rule:** Do not invent formulas for open gaps. Prefer Foundry **definitions** where concrete.  
**Source absorbed:** [`FOUNDRY_J_CROSSLINKS.md`](FOUNDRY_J_CROSSLINKS.md).

Provenance tags: `source-claim` | `axiom-gap` | `derived`.

---

## Alloy A1–A7

| ID | Statement sketch | Kind | Lean link | Core / doc cite | Provenance |
|----|------------------|------|-----------|-----------------|------------|
| A1 | `#P_64=64`; elements = first-64 primes | assert | L1 | PROPERTIES **23**; Core `P64` | source-claim |
| A2 | `contractive(J,ε) ↔ gershgorin(J)<1-ε` (+ opt. power-iter 37) | assert | L2 | **33–37**; `spectral_analyze`, `gershgorin_*`, `power_iteration*` | source-claim |
| A3 | if `q>1-ε` then soft-projected weights used | assert | L4 | **43**; `soft_project`, `q_estimate` | source-claim |
| A4 | affine Foundry recurrence **only if** `instance=Foundry` | assert | L3 | **39**; `rec_step`, `rec_run` | source-claim |
| A5 | PMAT conservation on insert-set | assert | (PMAT defs) | **29**; `pmat_compose` | source-claim |
| A6 | guardian rejects spectral_radius≥1 or non-finite | assert | — | **55** | source-claim |
| A7 | definition-record present for Λm, HCALC-Ξ, C, T_p; formulas unconstrained | gap gate | L6 | none | axiom-gap |

---

## Lean L1–L7

| ID | Statement sketch | Kind | Why irreducible / status | Depends / dependents | Provenance |
|----|------------------|------|--------------------------|----------------------|------------|
| L1 | `P64 : Fin 64 → ℕ` = PROPERTIES 23 list | **def** | Data; no axiom if listed | Used by Tp indexing hypotheses | source-claim |
| L2 | `gershgorinBound`, `contractiveG` | **def+thm** | From 33–34 | Contraction lemmas; A2 | source-claim |
| L3 | `FoundryStep Ξ Λ T g x` = prop 39 | **def** | Exact Foundry; ≠ HCALC nested | A4; must not be used as HCALC step | source-claim |
| L4 | `qEstimate` / `softProject` | **def** | 42–43 as coded | A3; Banach side conditions | source-claim |
| L5 | Unique FP when `q<1-ε` | **thm** or unfinished | Narrative 41 — prove or mark unfinished; never PASS via silent sorry | Convergence claims | derived / unfinished |
| L6 | Uninterpreted `Λm`, `HCALC.Ξ`, `C`, `Tp` | **axioms** | Source does not define; do not invent | All nested-form theorems | axiom-gap |
| L7 | Bridge `HCALCStep ≃ FoundryStep` | **BLOCKED** | Requires Spec HCALC LHS + **Gap-ShapeMap**; additive ≠ nested | Future instance proofs | axiom-gap (blocked) |

---

## Named Gap-* (HCALC-native axioms)

| GapId | Axiom / constant sketch | Alloy | Lean | Core citation targets (cite-only; not definitions) | Provenance |
|-------|-------------------------|-------|------|-----------------------------------------------------|------------|
| Gap-ShapeMap | ∃ bridge morphism nested↔additive; **not** `rfl` | A4, Inv-StepForm | L7 blocked | `rec_step`, `rec_run`, prop **39** | axiom-gap |
| Gap-Λm-scalar | `Λm : R` with candidate `‖Λm • (C ∘ Tp)‖ < 1-ε` | A7 | L6 | `synth_weights`→`lambda_schedule` (vector ≠ scalar) | axiom-gap |
| Gap-C-wrapper | `C : X → X` in-step; non-expansive candidate | A7 | L6 | `spectral_analyze`, `soft_project`, `q_estimate`, `ace_certify` (post-hoc ≠ C) | axiom-gap |
| Gap-Tp-from-P64 | `Tp` from prime index data | A1, A7 | L1, L6 | `P64`, `pmat_*`, `apply_hook`/`T_hook` | axiom-gap |
| Gap-Ξ | `HCALC.Ξ : Time → (Y → X)` | A7 | L6 | `synth_weights`→`xi_schedule`; `StepInfo` history | axiom-gap |
| Gap-Carrier | Carrier \(\mathcal{X}\) (Banach / tensor / \(\mathbb{F}_p\)) | instance param | type | Goldilocks 1–17 (carrier only) | axiom-gap |
| Gap-Converge | Nested-form convergence hypotheses | Inv-Residual | extends L5 | residual **46**; `ace_certify` | axiom-gap |
| Gap-ContractAlg | Algorithmic realization of C | A2 | — | gershgorin/power-iter flags | axiom-gap |
| Gap-OptObj | Objective \(\mathcal{J}\) | param | uninterpreted | none | axiom-gap |

---

## Theorems that may depend on axioms (Lean guidance)

| After closing | Dependent results (sketches) |
|---------------|------------------------------|
| L1 + Gap-Tp-from-P64 | Well-definedness of prime-indexed layers |
| L2 + Gap-C-wrapper | Lip / non-expansive bound for nested step |
| Gap-Λm-scalar + L2 | Stabilizing-range lemmas |
| Gap-Ξ + L3≠ | Controlled evolution distinct from Foundry schedules |
| Gap-ShapeMap + L7 | Instance transport Foundry ↔ HCALC |
| Gap-Converge | Convergence monitors; uniqueness |

**FAIL-open:** `sorry` / Alloy `unsat` failure / missing definition-record (**A7**) ⇒ SKIP or FAIL — never PASS.
