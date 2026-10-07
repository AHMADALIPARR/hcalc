<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Invariant Inventory — Alloy ↔ Lean

Maps every Alloy `assert` / `fact` / sealed check to Lean status (theorem vs axiom vs deferred).
Sources: `alloy/hcalc/**/*.als`, `spec/COHERENCE.md`, `spec/AXIOMS.md`, `spec/FOUNDRY_J_CROSSLINKS.md`.

Provenance: `source-claim` | `axiom-gap` | `derived`.

| Alloy ID | Informal statement | Provenance | Lean status |
|----------|-------------------|------------|-------------|
| **A1** `A1_P64_cardinality_and_distinct` | `#P_64=64`, distinct indices | source-claim | **L1 theorem** `P64List_length` (+ data) |
| **A1b** `A1b_P64_distinct_indices` | Distinct idx among carrier primes | derived | type-level `Fin 64` + list data |
| **A2** `A2_contractive_iff_gershgorin_bound` | contractive ↔ Gershgorin &lt; 1-ε (+ power-iter) | source-claim | **L2** abstract `contractiveG` ↔ `GershgorinBelowMargin` (no matrix arith) |
| **A3** `A3_soft_project_when_q_over_margin` | soft-project when q &gt; 1-ε | source-claim | **L4** `softProject` control flow |
| **A4** `A4_foundry_additive_only_if_Foundry_instance` | Foundry additive only if instance=Foundry | source-claim | **L3** `FoundryStep` def; tagged `StepForm` |
| **A5** `A5_PMAT_conservation_gated` | PMAT conservation if used | source-claim | not yet in Lean (optional surface) |
| **A6** `A6_guardian_reject_spectral_or_nonfinite` | reject ρ≥1 or non-finite | source-claim | not yet in Lean |
| **A7** `A7_gap_stub_definition_records` | definition-record presence for Λm, Ξ, C, Tp | axiom-gap | **L6 axioms** (named) |
| `INV_LambdaM_scalar_placeholder` | Λm lone scalar ≠ schedule vector | axiom-gap / G-Lm | **L6** `LambdaM : Nat` vs `ScheduleWeights` |
| `INV_step_shape_bridge_axiom_gap` | no silent Foundry↔HCALC equation | axiom-gap / G-SHAPE | **L7 deferred**; `StepForm` tags |
| `INV_prime_index_bounded_to_P64` | no unbounded prime stream | source-claim | `Tp : Fin 64 → …` |
| `INV_bounded_recursion_depth` | finite Time / lone next | derived | `iterateNested` on `Nat` |
| `INV_contract_measure_non_increase` | measure non-increase under Contract | axiom-gap / G-C | open (needs Gap-ContractAlg) |
| `INV_optimize_objective_axiom_gap` | objective underspecified | axiom-gap | open Gap-OptObj |
| `INV_converge_hyps_axiom_gap` | no Banach from narrative alone | axiom-gap | **L5** hypothesis skeleton only |
| `INV_evolve_respects_active_instance` | evolve matches ActiveInstance | derived | instance via `StepForm` |
| `INV_evolution_total_on_State` | every State on some Time | source-claim | `hcalcNestedStep_total` / `foundryStep_total` |
| `INV_Tp_index_in_P64_or_extension` | Tp index honesty | source-claim / G-Tp | `Fin 64` index |
| `INV_Tp_unique_per_index` | unique TpMap per index | derived | — |
| `INV_state_measure_functional` | lone measure per State | derived | — |
| `INV_stabilize_uses_LambdaM_scalar` | stabilize via Λm scalar | axiom-gap | nested uses `LambdaM` |
| `INV_time_linear_chain` | Time linear | derived | — |
| `INV_multimodal_tensor_wiring` | multimodal↔tensor wiring | derived | — |
| `INV_recursion_uses_prime_index` | recursion uses prime index | source-claim | `Tp` / `P64` |
| `INV_evolve_total_State_reachable` | evolve total | source-claim | totals above |
| `INV_extension_disjoint_or_empty` | prime extension honesty | derived | — |

**Invariant count (Alloy sealed asserts + facts listed):** 25 rows above (A1–A7 + A1b + named INVs).

## Alias GapIds (steering)

| Alias | Spec GapId | Role |
|-------|------------|------|
| **G-SHAPE** | Gap-ShapeMap | Nested ≠ additive; no silent identify |
| **G-Lm** | Gap-Λm-scalar | No scalar Λm verb; lambda_schedule is vector |
| **G-C** | Gap-C-wrapper | spectral_analyze classifies; not C[·] |
| **G-Tp** | Gap-Tp-from-P64 | No T_p from P64/PrimeMask yet |
