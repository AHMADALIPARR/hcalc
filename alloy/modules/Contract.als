/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Contract — spectral/orthogonal contraction predicates (Foundry-backed).
 * Cite: FOUNDRY_J_CROSSLINKS.md §1 contraction table; §3 A2, A3, A5, A6 pieces.
 * Core witnesses (intent, not Alloy proofs): spectral_analyze, soft_project, q_estimate.
 * PENDING-SPEC-GAPID: Gap-C-contraction — algorithm undefined; measure decrease = axiom-gap.
 */

module hcalc/modules/Contract

open hcalc/modules/State

/* Epsilon margin tiers (Foundry prop 25) as abstract atoms — not numeric theorems.
 * Provenance: source-claim — PROPERTIES 25 (T1→0.10 … T4→0.01) as labels. */
abstract sig EpsilonTier {}
one sig T1, T2, T3, T4 extends EpsilonTier {}

/* Jacobian / linearization atom (opaque).
 * Provenance: axiom-gap — no matrix entries invented in Alloy. */
sig Jacobian {}

/* Abstract comparison atoms for spectral bounds (finite, checkable relations).
 * Provenance: derived — Alloy encoding of gershgorin < 1-ε without ℝ arithmetic. */
sig SpectralBound {
  of: one Jacobian,
  /* belowMargin: stands for gershgorin(J) < 1-ε */
  belowMargin: lone EpsilonTier,
  /* powerIterOK: optional branch PROPERTIES 37 */
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

pred A2_contractive_iff_gershgorin {
  all j: Jacobian, e: EpsilonTier |
    contractive[j, e] iff
      (gershgorin_below[j, e] or
       (some sb: SpectralBound | sb.of = j and sb.powerIterOK = e))
}

assert A2_contractive_iff_gershgorin_bound {
  /* Sealed assert id A2 — PROPERTY_MAP */
  A2_contractive_iff_gershgorin
}

/* q-estimate atom (Foundry 42): q = ||Ξ||+||Λ||·||T|| — opaque Int proxy.
 * Provenance: source-claim — PROPERTIES 42; Core witness: q_estimate */
sig QBudget {
  q: Int,
  epsTier: one EpsilonTier,
  /* overMargin stands for q > 1-ε */
  overMargin: Int  /* 1 = over, 0 = ok; Alloy Int flag */
}

/* Soft-project flag on a step (Foundry 43).
 * Provenance: source-claim — PROPERTIES 43; Core witness: soft_project */
sig SoftProject {
  budget: one QBudget,
  applied: Int  /* 1 if scaled weights used */
}

/* A3 — soft_project when q > 1-ε.
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §3 A3 / prop 43. */
pred soft_project_when_over_margin {
  all sp: SoftProject |
    (sp.budget.overMargin = 1) implies sp.applied = 1
}

assert A3_soft_project_when_q_over_margin {
  /* Sealed assert id A3 — PROPERTY_MAP */
  soft_project_when_over_margin
}

/* Measure non-increase under Contract (algorithm UNDEFINED → axiom-gap pred).
 * Provenance: axiom-gap — PENDING-SPEC-GAPID: Gap-C-contraction
 * Hilbert: measure non-increase under Contract when axiomatized. */
pred measure_non_increase[s: State, s': State] {
  /* Underspecified: if both have measures, value does not increase.
   * NOT a proven contraction algorithm — placeholder obligation. */
  all sm: StateMeasure, sm': StateMeasure |
    (sm.of = s and sm'.of = s') implies sm'.m.value <= sm.m.value
}

assert INV_contract_measure_non_increase {
  /* INV_contract_measure_non_increase — axiom-gap obligation */
  all disj s, s': State | measure_non_increase[s, s']
}

/* A5 — PMAT conservation if used (optional/gated).
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §3 A5 / prop 29.
 * Gate: only when PMATUsage present. */
sig PMATUsage {
  conserved: Int  /* 1 = conservation holds on insert-set */
}

pred pmat_conservation_if_used {
  all p: PMATUsage | p.conserved = 1
}

assert A5_PMAT_conservation_gated {
  /* Sealed assert id A5 — PROPERTY_MAP (vacuous if no PMATUsage) */
  pmat_conservation_if_used
}
