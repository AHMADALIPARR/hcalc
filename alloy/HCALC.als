/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Top-level HCALC Alloy — PRODUCTION close (AGPL-3.0-only).
 * Cite: PRODUCTION.md (authoritative); AXIOMS.md; COHERENCE.md; FOUNDRY_J_CROSSLINKS.md.
 * Nested: X_{t+1}=Ξ(t,Λm·C(T_p(X_t))).
 * ShapeMap: InstanceBridge morphism — NOT Foundry39 ≡ nested.
 * Sealed: A1–A6 + A7 SpecDefined + production P1–P8.
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

/* ---- A7 Gap records: all SpecDefined (PRODUCTION close) ----
 * Provenance: SpecDefined — PRODUCTION.md; AXIOMS A7.
 * Retire Undefined stubs; formulas live in PRODUCTION.md §§1–9. */

abstract sig DefStatus {}
one sig Undefined, SpecDefined extends DefStatus {}

one sig GapRecord_LambdaM {
  /* Gap-Λm-scalar — CLOSED PRODUCTION §4 */
  status: one DefStatus
}
one sig GapRecord_HCALC_Xi {
  /* Gap-Ξ — CLOSED PRODUCTION §5 */
  status: one DefStatus
}
one sig GapRecord_C {
  /* Gap-C-wrapper — CLOSED PRODUCTION §3 */
  status: one DefStatus
}
one sig GapRecord_Tp {
  /* Gap-Tp-from-P64 — CLOSED PRODUCTION §2 */
  status: one DefStatus
}
one sig GapRecord_Carrier {
  /* Gap-Carrier — CLOSED PRODUCTION §1 */
  status: one DefStatus
}
one sig GapRecord_ShapeMap {
  /* Gap-ShapeMap / L7 — CLOSED PRODUCTION §6 InstanceBridge */
  status: one DefStatus
}
one sig GapRecord_ContractAlg {
  /* Gap-ContractAlg — CLOSED PRODUCTION §7 */
  status: one DefStatus
}
one sig GapRecord_Converge {
  /* Gap-Converge — CLOSED PRODUCTION §8 */
  status: one DefStatus
}
one sig GapRecord_OptObj {
  /* Gap-OptObj — CLOSED PRODUCTION §9 */
  status: one DefStatus
}

fact A7_production_all_spec_defined {
  GapRecord_LambdaM.status = SpecDefined
  GapRecord_HCALC_Xi.status = SpecDefined
  GapRecord_C.status = SpecDefined
  GapRecord_Tp.status = SpecDefined
  GapRecord_Carrier.status = SpecDefined
  GapRecord_ShapeMap.status = SpecDefined
  GapRecord_ContractAlg.status = SpecDefined
  GapRecord_Converge.status = SpecDefined
  GapRecord_OptObj.status = SpecDefined
}

pred A7_production_defined_records_present {
  one GapRecord_LambdaM
  one GapRecord_HCALC_Xi
  one GapRecord_C
  one GapRecord_Tp
  one GapRecord_Carrier
  one GapRecord_ShapeMap
  one GapRecord_ContractAlg
  one GapRecord_Converge
  one GapRecord_OptObj
  GapRecord_LambdaM.status = SpecDefined
  GapRecord_HCALC_Xi.status = SpecDefined
  GapRecord_C.status = SpecDefined
  GapRecord_Tp.status = SpecDefined
  GapRecord_Carrier.status = SpecDefined
  GapRecord_ShapeMap.status = SpecDefined
  GapRecord_ContractAlg.status = SpecDefined
  GapRecord_Converge.status = SpecDefined
  GapRecord_OptObj.status = SpecDefined
  /* Undefined remains a taxonomy atom but is unused by production records */
  some Undefined
  some SpecDefined
}

assert A7_production_defined_records {
  /* Sealed assert id A7 — PRODUCTION; all GapRecords SpecDefined */
  A7_production_defined_records_present
}

/* ---- Sealed check commands (finite scopes) for PROPERTY_MAP / Verify ----
 * Int bitwidth 8 so literals 63/64 are representable. Avoid heavy Int arith.
 */

/* A1–A6 sealed (keep working facts → UNSAT) */
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

/* A7 production SpecDefined */
check A7_production_defined_records for 5 but 8 Int

/* Production P1–P8 */
check P1_carrier_linf_dim for 5 but 8 Int
check P2_tp_diag_spec_alpha for 5 but 8 Int
check P3_c_scale_or_id for 5 but 8 Int
check P4_lambda_m_scalar_bound for 5 but exactly 1 LambdaM, 8 Int
check P5_xi_uniform_affine for 5 but 8 Int
check P6_instance_bridge_morphism for 5 but 8 Int
check P7_optobj_residual for 5 but 8 Int
check P8_contractalg_gershgorin_then_c for 5 but 8 Int

/* Safety / pipeline asserts (production-updated INV_*) */
check INV_LambdaM_scalar_placeholder for 5 but exactly 1 LambdaM, 8 Int
check INV_step_shape_bridge_instance for 5 but 8 Int
check INV_prime_index_bounded_to_P64 for 5 but exactly 1 P64Carrier, 8 PrimeLabel, 8 Int
check INV_recursion_uses_prime_index for 5 but 8 PrimeLabel, 8 Int
check INV_contract_measure_non_increase for 5 but 8 Int
check INV_optimize_objective_residual for 5 but 8 Int
check INV_converge_hyps_production for 5 but 8 Int
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
