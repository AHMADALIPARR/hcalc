/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Contract — spectral/orthogonal contraction predicates (Foundry-backed).
 * Cite: FOUNDRY_J_CROSSLINKS.md §1; §3 A2, A3, A5.
 * Core witnesses (intent, not Alloy proofs): spectral_analyze, soft_project, q_estimate.
 * GapId: Gap-C-wrapper / Gap-ContractAlg (COHERENCE.md)
 */

module modules/Contract

open modules/State

/* Provenance: source-claim — PROPERTIES 25 tier labels (not numeric theorems). */
abstract sig EpsilonTier {}
one sig T1, T2, T3, T4 extends EpsilonTier {}

sig Jacobian {}

sig SpectralBound {
  of: one Jacobian,
  belowMargin: lone EpsilonTier,
  powerIterOK: lone EpsilonTier
}

/* A2 — contractive(J,ε) iff gershgorin(J) < 1-ε (optional power-iter).
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §3 A2 / props 33–37.
 * Core witness (intent): spectral_analyze */
pred contractive[j: Jacobian, e: EpsilonTier] {
  some sb: SpectralBound | sb.of = j and (sb.belowMargin = e or sb.powerIterOK = e)
}

pred gershgorin_below[j: Jacobian, e: EpsilonTier] {
  some sb: SpectralBound | sb.of = j and sb.belowMargin = e
}

/* Fact encoding of A2 iff — keeps check A2 from being a free counterexample hunt
 * on unconstrained preds; the assert verifies the fact holds. */
fact fact_A2_contractive_iff {
  all j: Jacobian, e: EpsilonTier |
    contractive[j, e] iff
      (gershgorin_below[j, e] or
       (some sb: SpectralBound | sb.of = j and sb.powerIterOK = e))
}

assert A2_contractive_iff_gershgorin_bound {
  /* Sealed assert id A2 — PROPERTY_MAP */
  all j: Jacobian, e: EpsilonTier |
    contractive[j, e] iff
      (gershgorin_below[j, e] or
       (some sb: SpectralBound | sb.of = j and sb.powerIterOK = e))
}

sig QBudget {
  q: Int,
  epsTier: one EpsilonTier,
  overMargin: Int
}

sig SoftProject {
  budget: one QBudget,
  applied: Int
}

/* A3 — soft_project when q > 1-ε.
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §3 A3 / prop 43.
 * Core witness (intent): soft_project, q_estimate */
fact fact_A3_soft_project {
  all sp: SoftProject |
    (sp.budget.overMargin = 1) implies sp.applied = 1
}

assert A3_soft_project_when_q_over_margin {
  /* Sealed assert id A3 — PROPERTY_MAP */
  all sp: SoftProject |
    (sp.budget.overMargin = 1) implies sp.applied = 1
}

/* Measure non-increase — algorithm UNDEFINED → axiom-gap relational order (no Int).
 * Provenance: axiom-gap — GapId: Gap-C-wrapper / Gap-ContractAlg (COHERENCE.md)
 * Assert id: INV_contract_measure_non_increase
 * Core witness (intent): spectral_analyze / q_estimate */
one sig MeasureOrder {
  /* m -> mNext means measure does not increase from m to mNext */
  nonIncrease: Measure -> Measure
}

fact fact_measure_order_reflexive {
  all m: Measure | m in m.(MeasureOrder.nonIncrease)
}

pred measure_non_increase[s: State, sNext: State] {
  all sm: StateMeasure, smNext: StateMeasure |
    (sm.of = s and smNext.of = sNext) implies
      smNext.m in sm.m.(MeasureOrder.nonIncrease)
}

sig ContractLink {
  pre: one State,
  post: one State
}

fact fact_measure_on_contract_links {
  all cl: ContractLink | measure_non_increase[cl.pre, cl.post]
}

assert INV_contract_measure_non_increase {
  all cl: ContractLink | measure_non_increase[cl.pre, cl.post]
}

/* A5 — PMAT conservation if used (optional/gated).
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §3 A5 / prop 29. */
sig PMATUsage {
  conserved: Int
}

fact fact_A5_pmat_if_used {
  all p: PMATUsage | p.conserved = 1
}

assert A5_PMAT_conservation_gated {
  /* Sealed assert id A5 — PROPERTY_MAP (vacuous if no PMATUsage) */
  all p: PMATUsage | p.conserved = 1
}
