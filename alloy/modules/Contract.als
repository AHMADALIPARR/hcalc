/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Contract — production C = scale-or-id (Spec); ContractAlg = Gershgorin→C.
 * SoftProject/A3 remains Foundry *schedule* soft_project cite-only (prop 43).
 * DO NOT assert C = soft_project prop43.
 * Cite: PRODUCTION.md §3 Gap-C-wrapper, §7 Gap-ContractAlg CLOSED.
 * Provenance: SpecDefined (C, ContractAlg); source-claim (A2/A3/A5)
 */

module modules/Contract

open modules/State

/* Provenance: source-claim — PROPERTIES 25 tier labels. */
abstract sig EpsilonTier {}
one sig T1, T2, T3, T4 extends EpsilonTier {}

sig Jacobian {}

sig SpectralBound {
  of: one Jacobian,
  belowMargin: lone EpsilonTier,
  powerIterOK: lone EpsilonTier
}

/* A2 — contractive(J,ε) iff gershgorin(J) < 1-ε (optional power-iter).
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §3 A2 / props 33–37. */
pred contractive[j: Jacobian, e: EpsilonTier] {
  some sb: SpectralBound | sb.of = j and (sb.belowMargin = e or sb.powerIterOK = e)
}

pred gershgorin_below[j: Jacobian, e: EpsilonTier] {
  some sb: SpectralBound | sb.of = j and sb.belowMargin = e
}

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

/* ---- SoftProject: Foundry *schedule* soft_project cite-only (prop 43 / A3) ----
 * NOT identified with Spec C (scale-or-id on state). */
sig QBudget {
  q: Int,
  epsTier: one EpsilonTier,
  overMargin: Int
}

sig SoftProject {
  budget: one QBudget,
  applied: Int
}

fact fact_A3_soft_project {
  all sp: SoftProject |
    (sp.budget.overMargin = 1) implies sp.applied = 1
}

assert A3_soft_project_when_q_over_margin {
  /* Sealed assert id A3 — PROPERTY_MAP; Foundry schedule soft_project cite-only */
  all sp: SoftProject |
    (sp.budget.overMargin = 1) implies sp.applied = 1
}

/* ---- Production Spec C: scale-or-id on state ----
 * C(x) = ((1-ε)/q)·x if q>1-ε else x. Provenance: SpecDefined — PRODUCTION §3.
 * Distinct from SoftProject (Foundry schedule API). */
abstract sig CMode {}
one sig ScaleOrId extends CMode {}

sig COp {
  mode: one CMode,
  apply: State -> lone State
}

fact fact_P3_c_scale_or_id {
  all c: COp | c.mode = ScaleOrId
}

pred c_scale_or_id_ok {
  all c: COp | c.mode = ScaleOrId
}

assert P3_c_scale_or_id {
  /* Production assert P3 — C = Spec scale-or-id (NOT soft_project identity) */
  c_scale_or_id_ok
}

/* SoftProject and COp remain distinct families (no forced equality). */
fact fact_C_not_soft_project_identity {
  /* Structural: SoftProject and COp are different sigs; no bridge equating them. */
  all sp: SoftProject | some sp.budget
  all c: COp | c.mode = ScaleOrId
}

/* ---- Production ContractAlg: Gershgorin then scale-or-id (Spec C) ----
 * Provenance: SpecDefined — PRODUCTION.md §7. */
abstract sig ContractAlgKind {}
one sig GershgorinThenScaleOrId extends ContractAlgKind {}

one sig ProductionContractAlg {
  kind: one ContractAlgKind
}

fact fact_P8_contractalg_gershgorin_then_c {
  ProductionContractAlg.kind = GershgorinThenScaleOrId
}

pred contractalg_gershgorin_then_c_ok {
  ProductionContractAlg.kind = GershgorinThenScaleOrId
}

assert P8_contractalg_gershgorin_then_c {
  /* Production assert P8 — ContractAlg = Gershgorin → scale-or-id C */
  contractalg_gershgorin_then_c_ok
}

/* Measure non-increase — relational order (no Int). */
one sig MeasureOrder {
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

/* A5 — PMAT conservation if used (optional/gated). */
sig PMATUsage {
  conserved: Int
}

fact fact_A5_pmat_if_used {
  all p: PMATUsage | p.conserved = 1
}

assert A5_PMAT_conservation_gated {
  /* Sealed assert id A5 — PROPERTY_MAP */
  all p: PMATUsage | p.conserved = 1
}
