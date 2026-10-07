/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Evolve — BOTH step shapes + relationship axiom-gap (do NOT equate silently).
 * Cite: FOUNDRY_J_CROSSLINKS.md §0 shape gap; §3 A4; Lean bridge L7.
 * Foundry additive: x' = Ξx + ΛT(x) + g
 * HCALC nested:     X' = Ξ(t, Λm · C[T_p(X)])
 * PENDING-SPEC-GAPID: Gap-Xi-evolution, Gap-Lambda-m, Gap-C-contraction, Gap-T-p
 *   + bridge gap (L7 / shape gap §0) — remap when COHERENCE.md / INTERFACES.md land.
 * Core witness (intent): rec_step
 */

module hcalc/modules/Evolve

open hcalc/modules/State
open hcalc/modules/PrimeIndex
open hcalc/modules/Transform
open hcalc/modules/Stabilize
open hcalc/modules/Contract
open hcalc/modules/Recursion

/* ---- Opaque operators (UNDEFINED in HCALC source; no invented defs) ---- */

/* HCALC Ξ(t, ·) — operator/map; NOT Foundry Ξ_t schedule weights.
 * Provenance: axiom-gap — PENDING-SPEC-GAPID: Gap-Xi-evolution */
sig HCALC_Xi {
  atTime: one Time,
  /* maps an intermediate (Λm·C[T_p(X)]) atom to next State */
  map: Intermediate -> lone State
}

/* Intermediate = result of Λm · C[T_p(X)] before Ξ — opaque product.
 * Provenance: axiom-gap — multiplication/composition undefined. */
sig Intermediate {
  fromState: one State,
  viaTp: lone TpMap,
  viaC: lone COp,
  viaLambda: lone Scalar
}

/* C[·] contraction/combinator — UNDEFINED.
 * Provenance: axiom-gap — PENDING-SPEC-GAPID: Gap-C-contraction */
sig COp {
  apply: State -> lone State
}

/* Foundry schedule weights Ξ_t, Λ_t (length-2 vectors) — distinct from HCALC_Xi / LambdaM.
 * Provenance: source-claim — PROPERTIES 39; FOUNDRY_J_CROSSLINKS §0. */
sig FoundryXiWeights {
  /* schedule vector carrier — NOT HCALC_Xi */
  schedule: one ScheduleVector
}

sig FoundryLambdaWeights {
  schedule: one ScheduleVector
}

sig FoundryT {
  /* nonlinear T(x) — NOT T_p */
  apply: State -> lone State
}

sig FoundryG {
  /* inhomogenous term g_t */
  kick: lone State
}

/* ---- Dual step shapes ---- */

/* Foundry additive Step: x' = Ξx + ΛT(x) + g  (abstract relational form).
 * Provenance: source-claim — PROPERTIES 39 / FOUNDRY_J_CROSSLINKS §3 A4.
 * Core witness (intent): rec_step */
pred foundry_additive_step[x: State, x': State] {
  some xi: FoundryXiWeights, lam: FoundryLambdaWeights, tn: FoundryT, g: FoundryG |
    /* Relational placeholder for affine combination — no invented algebra. */
    x' in x.(tn.apply) + g.kick or x' = x
    /* schedules present (shape witness) */
    some xi.schedule and some lam.schedule
}

/* HCALC nested: X' = Ξ(t, Λm · C[T_p(X)])
 * Provenance: source-claim — HCALC abstract (given); operators opaque.
 * PENDING-SPEC-GAPID: Gap-Xi-evolution, Gap-Lambda-m, Gap-C-contraction, Gap-T-p */
pred hcalc_nested_step[t: Time, X: State, X': State] {
  some xi: HCALC_Xi, tp: TpMap, c: COp, mid: Intermediate |
    xi.atTime = t
    mid.fromState = X
    mid.viaTp = tp
    mid.viaC = c
    mid.viaLambda = LambdaM.scalar
    X' in mid.(xi.map)
}

/* Next-state relation matching skeleton along Time.
 * Provenance: derived — wiring only. */
pred evolve_next[t: Time] {
  some t.next implies
    (ActiveInstance.kind = HCALCInstance implies
       hcalc_nested_step[t, t.at, t.next.at])
    and
    (ActiveInstance.kind = FoundryInstance implies
       foundry_additive_step[t.at, t.next.at])
}

fact INV_evolve_respects_active_instance {
  /* INV_evolve_respects_active_instance */
  all t: Time | evolve_next[t]
}

/* A4 — Foundry additive form ONLY when instance = Foundry; NOT equated to HCALC nested.
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §3 A4 / §0. */
pred A4_foundry_step_only_if_foundry_instance {
  all t: Time |
    (some t.next and foundry_additive_step[t.at, t.next.at] and
     not hcalc_nested_step[t, t.at, t.next.at]) implies
      ActiveInstance.kind = FoundryInstance
  all t: Time |
    (some t.next and hcalc_nested_step[t, t.at, t.next.at] and
     not foundry_additive_step[t.at, t.next.at]) implies
      ActiveInstance.kind = HCALCInstance
}

assert A4_foundry_additive_only_if_Foundry_instance {
  /* Sealed assert id A4 — PROPERTY_MAP */
  A4_foundry_step_only_if_foundry_instance
}

/* Bridge gap: relationship between Foundry additive and HCALC nested.
 * Provenance: axiom-gap — Lean L7 / shape gap §0; PENDING-SPEC-GAPID: bridge-L7-shape
 * Do NOT assert equality. Record that a bridge obligation exists. */
one sig StepShapeBridge {
  /* defined=1 means Spec has supplied a bridge; default unconstrained/absent */
  defined: lone Int
}

pred bridge_not_silent_equation {
  /* Safety: models must not identify the two operator families */
  no HCALC_Xi & FoundryXiWeights
  LambdaM not in FoundryLambdaWeights
  no tp: TpMap, tn: FoundryT | tp = tn
}

assert INV_step_shape_bridge_axiom_gap {
  /* INV_step_shape_bridge_axiom_gap — axiom-gap (L7); NOT an equality theorem */
  bridge_not_silent_equation
}

/* Evolution total on State (Hilbert).
 * Provenance: source-claim — Hilbert safety list. */
assert INV_evolve_total_State_reachable {
  /* INV_evolve_total_State_reachable */
  evolution_total_on_State
}
