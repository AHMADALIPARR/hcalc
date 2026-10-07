<!--
  Copyright (C) 2026 HCALC / Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Alloy — Invariant Inventory

**Owner:** HCALC Alloy agent  
**License:** AGPL-3.0-only  
**Spec sources:** `/workspace/hcalc/spec/COHERENCE.md`, `INTERFACES.md`, `AXIOMS.md`, `FOUNDRY_J_CROSSLINKS.md`  
**Purpose:** Listable assert IDs for Verify `PROPERTY_MAP`. Provenance ∈ {`source-claim`, `axiom-gap`, `derived`}.

**Shape rule:** Foundry additive prop **39** ≠ HCALC nested form. Bridge only via **Gap-ShapeMap** / L7 (blocked). Do not equate.

**Core witnesses (cite-only, not Alloy proofs):** `spectral_analyze`, `soft_project`, `q_estimate`, `P64`, `rec_step`.

---

## (A) Invariants Alloy can check now (finite scopes)

| Assert ID | Module | Provenance | GapId / Spec cross-ref | Brief meaning |
|-----------|--------|------------|------------------------|---------------|
| **A1_P64_cardinality_and_distinct** | PrimeIndex / HCALC | source-claim | A1; Gap-Tp-from-P64 (index honesty); Lean L1 for numeric list | `declaredCard=64`; distinct `idx` in range for carrier primes |
| **A1b_P64_distinct_indices** | HCALC | derived | A1 companion | Distinct indices among `P64Carrier.primes` at small scope |
| **A2_contractive_iff_gershgorin_bound** | Contract | source-claim | A2; props 33–37; Gap-ContractAlg (alg still open) | `contractive(J,ε) iff` Gershgorin-below or power-iter OK |
| **A3_soft_project_when_q_over_margin** | Contract | source-claim | A3; prop 43 | If `q > 1-ε` (`overMargin=1`) then soft_project `applied=1` |
| **A4_foundry_additive_only_if_Foundry_instance** | Evolve | source-claim | A4; Inv-StepForm; Gap-ShapeMap | Foundry additive step only when `instance=Foundry`; HCALC uses nested |
| **A5_PMAT_conservation_gated** | Contract | source-claim | A5; prop 29 | If `PMATUsage` present, `conserved=1` (vacuous if unused) |
| **A6_guardian_reject_spectral_or_nonfinite** | Converge | source-claim | A6; prop 55 | Reject when spectral radius ≥ 1 or non-finite |
| **A7_gap_stub_definition_records** | HCALC | axiom-gap | A7; Inv-OpaqueGaps; **Gap-Λm-scalar, Gap-Ξ, Gap-C-wrapper, Gap-Tp-from-P64** | Definition-record presence with status `Undefined` (not formulas) |
| **INV_LambdaM_scalar_placeholder** | Stabilize | axiom-gap | Gap-Λm-scalar | Λm is lone scalar placeholder — not a schedule vector |
| **INV_step_shape_bridge_axiom_gap** | Evolve | axiom-gap | **Gap-ShapeMap**; L7 blocked | Bridge not silently equating shapes (`defined≠1`) |
| **INV_prime_index_bounded_to_P64** | PrimeIndex | source-claim | A1; Inv-P64 | No silent infinite prime stream; labels ⊆ P64 carrier |
| **INV_recursion_uses_prime_index** | Recursion | derived | Gap-Tp-from-P64 | Every `TpMap.index` in P64 or stated extension |
| **INV_contract_measure_non_increase** | Contract | axiom-gap | Gap-ContractAlg / Gap-C-wrapper | On `ContractLink`, measure does not increase (placeholder) |
| **INV_optimize_objective_axiom_gap** | Optimize | axiom-gap | Gap-OptObj | Objective underspecified; no optimality theorem |
| **INV_converge_hyps_axiom_gap** | Converge | axiom-gap | Gap-Converge | Discharged hyps require residual witness; no fake Banach thm |
| **INV_evolution_total_on_State** | State | source-claim | Hilbert / Inv evolution total | Every `State` appears at some `Time` |
| **INV_evolve_total_State_reachable** | Evolve | derived | same | Same totality via Evolve module |
| **INV_multimodal_tensor_wiring** | Transform | derived | Gap-Carrier | Multimodal inputs wired into some `TensorSpace.support` |

### Facts (safety structure; not separate check commands)

| Fact ID | Module | Provenance | Meaning |
|---------|--------|------------|---------|
| INV_time_linear_chain | State | derived | Finite Time chain; bounded evolution |
| INV_bounded_recursion_depth | Recursion | derived | `lone next` — no unrestricted recursion |
| INV_state_measure_functional | State | derived | At most one measure per state |
| INV_Tp_index_in_P64_or_extension | Transform | source-claim | Prime-index honesty for T_p |
| INV_Tp_unique_per_index | Transform | derived | Unique TpMap per prime index |
| INV_stabilize_uses_LambdaM_scalar | Stabilize | axiom-gap | Stabilized.via = Λm.scalar when present |
| INV_evolve_respects_active_instance | Evolve | source-claim | Next-state follows active instance shape |
| A7_default_undefined | HCALC | axiom-gap | Gap records default Undefined |
| A1_declared_cardinality_64 | PrimeIndex | source-claim | `declaredCard = 64` |
| fact_A2 / fact_A3 / fact_A5 / fact_A6 | Contract/Converge | source-claim | Encode A2–A3/A5–A6 as facts + matching asserts |

---

## (B) Must hand to Lean as axioms / unfinished (underspecified gaps)

Do **not** invent formulas. Alloy keeps opaque sigs + A7 records. Lean uses named axioms per Spec `AXIOMS.md`.

| GapId | Alloy stance | Lean hand-off | Notes |
|-------|--------------|---------------|-------|
| **Gap-ShapeMap** | INV_step_shape_bridge_axiom_gap; A4 gating; no equality | **L7 BLOCKED** until Spec defines HCALC LHS + ShapeMap | Additive ≠ nested |
| **Gap-Λm-scalar** | `LambdaM.scalar: lone Scalar`; A7 record | **L6** uninterpreted | Not Foundry `lambda_schedule` vector |
| **Gap-C-wrapper** | `COp` opaque; A7 record | **L6** | Foundry spectral_* ≠ in-step C |
| **Gap-Tp-from-P64** | `TpMap` opaque on P64; A7 record | **L6** + **L1** P64 data def | Candidates ≠ definition |
| **Gap-Ξ** | `HCALC_Xi` opaque; A7 record | **L6** | ≠ Foundry `xi_schedule` vectors |
| **Gap-Carrier** | `State` / `TensorSpace` opaque | type / instance param | Banach/tensor/F_p unnamed |
| **Gap-Converge** | INV_converge_hyps_axiom_gap | extends **L5** (unfinished OK) | Nested-form hyps open |
| **Gap-ContractAlg** | measure_non_increase placeholder | — | Algorithm realizing C undefined |
| **Gap-OptObj** | `Objective` opaque | uninterpreted | Pipeline tail |

### Lean defs preferred (not Alloy theorems)

| ID | Kind | Note |
|----|------|------|
| L1 | definition | P64 numeric list (PROPERTIES 23) |
| L2 | def + theorem | gershgorinBound / contractiveG |
| L3 | definition | FoundryStep (≠ HCALC nested) |
| L4 | definition | qEstimate / softProject as coded |

---

## Sealed PROPERTY_MAP checklist (A1–A7)

| ID | Assert name in `.als` | Provenance |
|----|----------------------|------------|
| A1 | `A1_P64_cardinality_and_distinct` | source-claim |
| A2 | `A2_contractive_iff_gershgorin_bound` | source-claim |
| A3 | `A3_soft_project_when_q_over_margin` | source-claim |
| A4 | `A4_foundry_additive_only_if_Foundry_instance` | source-claim |
| A5 | `A5_PMAT_conservation_gated` | source-claim |
| A6 | `A6_guardian_reject_spectral_or_nonfinite` | source-claim |
| A7 | `A7_gap_stub_definition_records` | axiom-gap |

---

## Provenance counts (assert-level, listable)

Counting named `assert` IDs in modules + HCALC.als (excluding pure facts):

| Provenance | Count | IDs |
|------------|------:|-----|
| source-claim | 10 | A1, A1b*, A2, A3, A4, A5, A6, INV_prime_index_bounded_to_P64, INV_evolution_total_on_State, INV_evolve_total_State_reachable* |
| axiom-gap | 6 | A7, INV_LambdaM_scalar_placeholder, INV_step_shape_bridge_axiom_gap, INV_contract_measure_non_increase, INV_optimize_objective_axiom_gap, INV_converge_hyps_axiom_gap |
| derived | 2 | INV_recursion_uses_prime_index, INV_multimodal_tensor_wiring |

\* A1b / evolve-total marked derived/source companion as appropriate; A1b is structural companion to A1.

**Totals:** 18 named asserts checkable in Alloy scopes; **9** GapIds remain Lean/Spec-open (section B).

---

## Scopes used for checks

Default in `HCALC.als`: `for 5` (or `for 4` on runs) with **`8 Int`** bitwidth so literals `63`/`64` are representable. `P64` numeric enumeration of 64 prime *values* is Lean **L1**, not required as 64 Alloy atoms in CI.

---

## Blockers for Spec / Lean coordination

1. **Gap-ShapeMap / L7** blocked — no bridge morphism until Spec defines HCALC LHS.  
2. **A7 / L6** symbols (`Λm`, `Ξ`, `C`, `Tp`) stay uninterpreted — no invented formulas.  
3. Concrete first-64 prime **values** for A1 live in Lean L1; Alloy checks `declaredCard=64` + distinct indices.  
4. Nested-form convergence (**Gap-Converge**) and contraction algorithm (**Gap-ContractAlg**) need Spec closure before Alloy can strengthen beyond placeholders.  
5. Verify `PROPERTY_MAP` should key on sealed assert IDs in the A1–A7 table above.
