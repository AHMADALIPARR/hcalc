<!--
  Copyright (C) 2026 HCALC / Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Alloy — Invariant Inventory (PRODUCTION)

**Owner:** HCALC Alloy agent  
**License:** AGPL-3.0-only  
**Status:** PRODUCTION — domain Gap-* CLOSED per [`../spec/PRODUCTION.md`](../spec/PRODUCTION.md)  
**Spec sources:** `PRODUCTION.md` (authoritative), `AXIOMS.md`, `COHERENCE.md`, `FOUNDRY_J_CROSSLINKS.md`  
**Purpose:** Listable assert IDs for Verify `PROPERTY_MAP`. Provenance ∈ {`source-claim`, `SpecDefined`, `derived`}.

**Shape rule:** Foundry additive prop **39** ≠ HCALC nested form. Bridge via **InstanceBridge** morphism (NOT `rfl` / NOT Foundry39≡nested). NestedFaithful / FoundryAdditive stay DISTINCT from identity.

**Core witnesses (cite-only, not Alloy proofs):** `spectral_analyze`, `soft_project`, `q_estimate`, `P64`, `rec_step`, `synth_weights`.

---

## Sealed A1–A7 + production P1–P8

| ID | Assert name | Module | Provenance | Meaning |
|----|-------------|--------|------------|---------|
| A1 | `A1_P64_cardinality_and_distinct` | PrimeIndex | source-claim | `declaredCard=64`; distinct idx in range |
| A1b | `A1b_P64_distinct_indices` | HCALC | derived | Distinct indices among carrier primes |
| A2 | `A2_contractive_iff_gershgorin_bound` | Contract | source-claim | contractive ↔ Gershgorin / power-iter |
| A3 | `A3_soft_project_when_q_over_margin` | Contract | source-claim | Foundry *schedule* soft_project cite-only (prop 43) |
| A4 | `A4_foundry_additive_only_if_Foundry_instance` | Evolve | source-claim | Foundry additive only if instance=Foundry |
| A5 | `A5_PMAT_conservation_gated` | Contract | source-claim | PMAT conserved if used |
| A6 | `A6_guardian_reject_spectral_or_nonfinite` | Converge | source-claim | Guardian reject spectral≥1 / non-finite |
| A7 | `A7_production_defined_records` | HCALC | **SpecDefined** | All GapRecords status = SpecDefined |
| P1 | `P1_carrier_linf_dim` | State | SpecDefined | Carrier abstract dim n≥1, ℓ∞ |
| P2 | `P2_tp_diag_spec_alpha` | Transform | SpecDefined | Tp diagonal + SpecAlphaLaw α_j=1/(1+log p_{j mod 64}) |
| P3 | `P3_c_scale_or_id` | Contract | SpecDefined | C = Spec scale-or-id (NOT soft_project identity) |
| P4 | `P4_lambda_m_scalar_bound` | Stabilize | SpecDefined | Λm scalar ≥0; ‖Λm·(C∘Tp)‖≤1-ε flag |
| P5 | `P5_xi_uniform_affine` | Evolve | SpecDefined | Ξ(t,y)=ξ_t y+g_t; Uniform ξ=1 |
| P6 | `P6_instance_bridge_morphism` | Evolve | SpecDefined | bridgeMode=InstanceBridge; forbid identity |
| P7 | `P7_optobj_residual` | Optimize | SpecDefined | OptObj = residual |
| P8 | `P8_contractalg_gershgorin_then_c` | Contract | SpecDefined | ContractAlg = Gershgorin then scale-or-id C |

---

## Pipeline INV_* (production-updated)

| Assert ID | Module | Provenance | Brief |
|-----------|--------|------------|-------|
| INV_LambdaM_scalar_placeholder | Stabilize | SpecDefined | Λm lone scalar ≠ schedule vector |
| INV_step_shape_bridge_instance | Evolve | SpecDefined | InstanceBridge; claimsIdentity=0 |
| INV_prime_index_bounded_to_P64 | PrimeIndex | source-claim | Labels ⊆ P64 carrier |
| INV_recursion_uses_prime_index | Recursion | derived | TpMap.index in P64 or extension |
| INV_contract_measure_non_increase | Contract | SpecDefined | Measure non-increase on ContractLink |
| INV_optimize_objective_residual | Optimize | SpecDefined | Objective kind = ResidualObj |
| INV_converge_hyps_production | Converge | SpecDefined | Discharged ⇒ Hyp + residual |
| INV_evolution_total_on_State | State | source-claim | Every State at some Time |
| INV_evolve_total_State_reachable | Evolve | derived | Same via Evolve |
| INV_multimodal_tensor_wiring | Transform | derived | Multimodal → TensorSpace |

---

## Gap disposition (Alloy)

| GapId | Status | Alloy encoding |
|-------|--------|----------------|
| Gap-Carrier | **CLOSED** | CarrierSpec dimPositive=1, norm=LInf; P1 |
| Gap-Tp-from-P64 | **CLOSED** | TpMap isDiagonal=1, alphaLaw=SpecAlphaLaw; P2 |
| Gap-C-wrapper | **CLOSED** | COp mode=ScaleOrId; P3 (≠ SoftProject) |
| Gap-Λm-scalar | **CLOSED** | LambdaM scalar + nonNeg + opBoundOK; P4 |
| Gap-Ξ | **CLOSED** | UniformXi xiIsOne=1, HCALC_Xi isAffine; P5 |
| Gap-ShapeMap / L7 | **CLOSED** | ShapeMapConfig.bridgeMode=InstanceBridge; P6 |
| Gap-ContractAlg | **CLOSED** | GershgorinThenScaleOrId; P8 |
| Gap-Converge | **CLOSED** | ConvergenceHyp production; INV_converge |
| Gap-OptObj | **CLOSED** | ResidualObj; P7 |
| A7 | **SpecDefined** | All GapRecords SpecDefined |

**Infra gaps** (Gap-Real-arith, Gap-Foundry-*) are Lean stubs — not Alloy domain blockers.

**Leftover axiom-gap:** none for domain production path. SoftProject/A3 remains Foundry schedule cite-only (source-claim), intentionally distinct from Spec C.

---

## SoftProject vs Spec C (do not equate)

| Symbol | Role | Assert |
|--------|------|--------|
| `SoftProject` | Foundry schedule soft_project (prop **43**) cite-only | A3 |
| `COp` / `ScaleOrId` | Spec in-step C on state | P3 |
| Identity `C ≡ soft_project` | **FORBIDDEN** | — |

---

## Scopes

Default: `for 5` with **`8 Int`** bitwidth. P64 numeric values = Lean L1; Alloy checks `declaredCard=64` + distinct indices. Avoid heavy Int arithmetic (flags encode production bounds).

---

## Core Option B

Production Core implements `hcalc_step` only; `toFoundryStep` is cite-only diagnostic under InstanceBridge param table. Never claim `hcalcStep = FoundryStep`.
