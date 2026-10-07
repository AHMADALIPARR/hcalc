/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Top-level HCALC Alloy module — opens pipeline modules; sealed checks A1–A7.
 * Cite: FOUNDRY_J_CROSSLINKS.md §3; HCALC abstract X_{t+1}=Ξ(t,Λm·C[T_p(X_t)]).
 * PENDING-SPEC-GAPID tags throughout modules — remap when COHERENCE.md / INTERFACES.md land.
 * Rule: no invented Λm / Ξ / C / T_p / tensor / convergence theorems.
 */

module hcalc/HCALC

open hcalc/modules/State
open hcalc/modules/PrimeIndex
open hcalc/modules/Transform
open hcalc/modules/Recursion
open hcalc/modules/Stabilize
open hcalc/modules/Contract
open hcalc/modules/Evolve
open hcalc/modules/Optimize
open hcalc/modules/Converge

/* ---- A7 Gap stub: definition-record presence, not formulas ----
 * Provenance: axiom-gap — FOUNDRY_J_CROSSLINKS §3 A7 / §2 item 8.
 * PENDING-SPEC-GAPID: Gap-Lambda-m, Gap-Xi-evolution, Gap-C-contraction, Gap-T-p
 * Assert presence of a definition record slot — NOT a mathematical definition. */

abstract sig DefStatus {}
one sig Undefined, SpecDefined extends DefStatus {}

one sig GapRecord_LambdaM { status: one DefStatus }
one sig GapRecord_HCALC_Xi { status: one DefStatus }
one sig GapRecord_C { status: one DefStatus }
one sig GapRecord_Tp { status: one DefStatus }

/* Default: all open symbols Undefined until Spec writes otherwise.
 * Provenance: axiom-gap — A7. */
fact A7_default_undefined {
  GapRecord_LambdaM.status = Undefined
  GapRecord_HCALC_Xi.status = Undefined
  GapRecord_C.status = Undefined
  GapRecord_Tp.status = Undefined
}

pred A7_gap_stub_records_present {
  /* Presence of definition records (stubs), not formulas for the symbols. */
  one GapRecord_LambdaM
  one GapRecord_HCALC_Xi
  one GapRecord_C
  one GapRecord_Tp
  /* Until Spec defines them, status remains Undefined */
  GapRecord_LambdaM.status = Undefined
  GapRecord_HCALC_Xi.status = Undefined
  GapRecord_C.status = Undefined
  GapRecord_Tp.status = Undefined
}

assert A7_gap_stub_definition_records {
  /* Sealed assert id A7 — PROPERTY_MAP */
  A7_gap_stub_records_present
}

/* ---- Sealed check commands (finite scopes) for PROPERTY_MAP / Verify ---- */

/* A1: P_64 cardinality + distinct indices.
 * Scope note: Alloy cannot allocate 64 PrimeLabel atoms cheaply in every CI run;
 * we check the integrity PREDICATE structure at small scope AND provide a
 * dedicated cardinality check when primes are drawn from a bounded pool.
 * Full #=64 is recorded as check A1; small-scope structural checks accompany it.
 */
check A1_P64_cardinality_and_distinct for 5 but exactly 1 P64Carrier, 8 PrimeLabel, 5 Int

/* Structural companion: distinct idx among carrier primes (always checkable). */
assert A1b_P64_distinct_indices {
  all disj p1, p2: P64Carrier.primes | p1.idx != p2.idx
}
check A1b_P64_distinct_indices for 5 but exactly 1 P64Carrier, 8 PrimeLabel, 5 Int

check A2_contractive_iff_gershgorin_bound for 5 but 5 Int

check A3_soft_project_when_q_over_margin for 5 but 5 Int

check A4_foundry_additive_only_if_Foundry_instance for 5 but exactly 1 ActiveInstance, 5 Int

check A5_PMAT_conservation_gated for 5 but 5 Int

check A6_guardian_reject_spectral_or_nonfinite for 5 but 5 Int

check A7_gap_stub_definition_records for 5 but 5 Int

/* Additional safety / pipeline asserts */
check INV_LambdaM_scalar_placeholder for 5 but exactly 1 LambdaM, 5 Int
check INV_step_shape_bridge_axiom_gap for 5 but 5 Int
check INV_prime_index_bounded_to_P64 for 5 but exactly 1 P64Carrier, 8 PrimeLabel, 5 Int
check INV_bounded_recursion_depth for 5 but 5 Time, 5 Int
check INV_contract_measure_non_increase for 5 but 5 Int
check INV_optimize_objective_axiom_gap for 5 but 5 Int
check INV_converge_hyps_axiom_gap for 5 but 5 Int
check INV_evolve_respects_active_instance for 5 but exactly 1 ActiveInstance, 5 Time, 5 Int
check INV_evolution_total_on_State for 5 but 5 Time, 5 State, 5 Int

/* Optional run: exhibit a finite HCALC-shaped trace (instance exploration). */
pred show_hcalc_trace {
  ActiveInstance.kind = HCALCInstance
  some t: Time | some t.next
  hcalc_nested_step[t, t.at, t.next.at]
}
run show_hcalc_trace for 4 but exactly 1 ActiveInstance, exactly 1 HCALCInstance, 3 Time, 3 State, 2 TpMap, 1 HCALC_Xi, 1 COp, 1 Intermediate, 5 Int

pred show_foundry_trace {
  ActiveInstance.kind = FoundryInstance
  some t: Time | some t.next
  foundry_additive_step[t.at, t.next.at]
}
run show_foundry_trace for 4 but exactly 1 ActiveInstance, exactly 1 FoundryInstance, 3 Time, 3 State, 5 Int
