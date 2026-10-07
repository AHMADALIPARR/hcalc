/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Top-level HCALC Alloy module — opens pipeline modules; sealed checks A1–A7.
 * Cite: FOUNDRY_J_CROSSLINKS.md §3; COHERENCE.md; INTERFACES.md; AXIOMS.md.
 * HCALC abstract: X_{t+1}=Ξ(t,Λm·C[T_p(X_t)]).
 * Shape gap stands — Gap-ShapeMap; do NOT equate Foundry39 with nested HCALC.
 * Rule: no invented Λm / Ξ / C / T_p / tensor / convergence theorems.
 */

module HCALC

open modules/State
open modules/PrimeIndex
open modules/Transform
open modules/Recursion
open modules/Stabilize
open modules/Contract
open modules/Evolve
open modules/Optimize
open modules/Converge

/* ---- A7 Gap stub: definition-record presence, not formulas ----
 * Provenance: axiom-gap — FOUNDRY_J_CROSSLINKS §3 A7; COHERENCE Inv-OpaqueGaps.
 * Cross-refs: Gap-Λm-scalar, Gap-Ξ, Gap-C-wrapper, Gap-Tp-from-P64
 * Assert presence of a definition record slot — NOT a mathematical definition. */

abstract sig DefStatus {}
one sig Undefined, SpecDefined extends DefStatus {}

one sig GapRecord_LambdaM {
  /* Gap-Λm-scalar */
  status: one DefStatus
}
one sig GapRecord_HCALC_Xi {
  /* Gap-Ξ */
  status: one DefStatus
}
one sig GapRecord_C {
  /* Gap-C-wrapper */
  status: one DefStatus
}
one sig GapRecord_Tp {
  /* Gap-Tp-from-P64 */
  status: one DefStatus
}

/* Default: all open symbols Undefined until Spec writes SpecDefined.
 * Provenance: axiom-gap — A7. */
fact A7_default_undefined {
  GapRecord_LambdaM.status = Undefined
  GapRecord_HCALC_Xi.status = Undefined
  GapRecord_C.status = Undefined
  GapRecord_Tp.status = Undefined
}

pred A7_gap_stub_records_present {
  one GapRecord_LambdaM
  one GapRecord_HCALC_Xi
  one GapRecord_C
  one GapRecord_Tp
  GapRecord_LambdaM.status = Undefined
  GapRecord_HCALC_Xi.status = Undefined
  GapRecord_C.status = Undefined
  GapRecord_Tp.status = Undefined
}

assert A7_gap_stub_definition_records {
  /* Sealed assert id A7 — PROPERTY_MAP; cross-ref Gap-Λm-scalar, Gap-Ξ, Gap-C-wrapper, Gap-Tp-from-P64 */
  A7_gap_stub_records_present
}

/* ---- Sealed check commands (finite scopes) for PROPERTY_MAP / Verify ----
 * A1 cardinality uses declaredCard=64 (scope-friendly); concrete prime list = Lean L1.
 */

check A1_P64_cardinality_and_distinct for 5 but exactly 1 P64Carrier, 8 PrimeLabel, 8 Int

assert A1b_P64_distinct_indices {
  all disj p1, p2: P64Carrier.primes | p1.idx != p2.idx
}
check A1b_P64_distinct_indices for 5 but exactly 1 P64Carrier, 8 PrimeLabel, 8 Int

check A2_contractive_iff_gershgorin_bound for 5 but 8 Int

check A3_soft_project_when_q_over_margin for 5 but 8 Int

check A4_foundry_additive_only_if_Foundry_instance for 5 but exactly 1 ActiveInstance, 8 Int

check A5_PMAT_conservation_gated for 5 but 8 Int

check A6_guardian_reject_spectral_or_nonfinite for 5 but 8 Int

check A7_gap_stub_definition_records for 5 but 8 Int

/* Safety / pipeline asserts (COHERENCE Inv-* + Hilbert) */
check INV_LambdaM_scalar_placeholder for 5 but exactly 1 LambdaM, 8 Int
check INV_step_shape_bridge_axiom_gap for 5 but 8 Int
check INV_prime_index_bounded_to_P64 for 5 but exactly 1 P64Carrier, 8 PrimeLabel, 8 Int
check INV_recursion_uses_prime_index for 5 but 8 PrimeLabel, 8 Int
check INV_contract_measure_non_increase for 5 but 8 Int
check INV_optimize_objective_axiom_gap for 5 but 8 Int
check INV_converge_hyps_axiom_gap for 5 but 8 Int
check INV_evolution_total_on_State for 5 but 5 Time, 5 State, 8 Int
check INV_multimodal_tensor_wiring for 5 but 8 Int
check INV_evolve_total_State_reachable for 5 but 5 Time, 5 State, 8 Int

/* Optional runs: exhibit finite traces per instance (exploration, not theorems). */
pred show_hcalc_trace {
  ActiveInstance.kind = HCALCInstance
  some t: Time | some t.next and hcalc_nested_step[t, t.at, t.next.at]
}
run show_hcalc_trace for 4 but exactly 1 ActiveInstance, exactly 1 HCALCInstance,
  3 Time, 3 State, 2 TpMap, 1 HCALC_Xi, 1 COp, 1 Intermediate, 8 Int

pred show_foundry_trace {
  ActiveInstance.kind = FoundryInstance
  some t: Time | some t.next and foundry_additive_step[t.at, t.next.at]
}
run show_foundry_trace for 4 but exactly 1 ActiveInstance, exactly 1 FoundryInstance,
  3 Time, 3 State, 8 Int
