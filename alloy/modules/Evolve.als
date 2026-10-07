/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Evolve — BOTH step shapes + relationship axiom-gap (do NOT equate silently).
 * Cite: FOUNDRY_J_CROSSLINKS.md §0 shape gap; §3 A4; Lean bridge L7.
 * Foundry additive: x' = Ξx + ΛT(x) + g
 * HCALC nested:     X' = Ξ(t, Λm · C[T_p(X)])
 * GapIds: Gap-Ξ, Gap-Λm-scalar, Gap-C-wrapper, Gap-Tp-from-P64, Gap-ShapeMap (COHERENCE.md); L7 blocked — do NOT equate Foundry39 with nested HCALC.
 * Core witness (intent): rec_step
 */

module modules/Evolve

open modules/State
open modules/PrimeIndex
open modules/Transform
open modules/Stabilize
open modules/Contract
open modules/Recursion

/* HCALC Ξ(t, ·) — NOT Foundry Ξ_t schedule weights.
 * Provenance: axiom-gap — GapId: Gap-Ξ (COHERENCE.md)
 */
sig HCALC_Xi {
  atTime: one Time,
  map: Intermediate -> lone State
}

sig Intermediate {
  fromState: one State,
  viaTp: lone TpMap,
  viaC: lone COp,
  viaLambda: lone Scalar
}

/* C[·] UNDEFINED.
 * Provenance: axiom-gap — GapId: Gap-C-wrapper / Gap-ContractAlg (COHERENCE.md)
 */
sig COp {
  apply: State -> lone State
}

/* Foundry schedule weights — distinct sigs from HCALC_Xi / LambdaM.
 * Provenance: source-claim — PROPERTIES 39; FOUNDRY_J_CROSSLINKS §0. */
sig FoundryXiWeights {
  schedule: one ScheduleVector
}

sig FoundryLambdaWeights {
  schedule: one ScheduleVector
}

sig FoundryT {
  apply: State -> lone State
}

sig FoundryG {
  kick: lone State
}

/* Foundry additive Step (relational placeholder — no invented algebra).
 * Provenance: source-claim — PROPERTIES 39 / A4.
 * Core witness (intent): rec_step */
pred foundry_additive_step[x: State, xNext: State] {
  some xi: FoundryXiWeights, lam: FoundryLambdaWeights, tn: FoundryT |
    some xi.schedule and some lam.schedule and
    (xNext in x.(tn.apply) or (some g: FoundryG | xNext = g.kick) or xNext = x)
}

/* HCALC nested: X' = Ξ(t, Λm · C[T_p(X)])
 * Provenance: source-claim — HCALC abstract; operators opaque.
 * GapId: Gap-Ξ (COHERENCE.md)
 */
pred hcalc_nested_step[t: Time, X: State, XNext: State] {
  some xi: HCALC_Xi, tp: TpMap, c: COp, mid: Intermediate |
    xi.atTime = t and
    mid.fromState = X and
    mid.viaTp = tp and
    mid.viaC = c and
    mid.viaLambda = LambdaM.scalar and
    XNext in mid.(xi.map)
}

pred evolve_next[t: Time] {
  some t.next implies (
    (ActiveInstance.kind = HCALCInstance implies
      hcalc_nested_step[t, t.at, t.next.at])
    and
    (ActiveInstance.kind = FoundryInstance implies
      foundry_additive_step[t.at, t.next.at])
  )
}

/* Assert id: INV_evolve_respects_active_instance */
fact INV_evolve_respects_active_instance {
  all t: Time | evolve_next[t]
}

/* A4 — Foundry additive ONLY when instance = Foundry; not equated to HCALC nested.
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §3 A4 / §0. */
pred A4_foundry_step_only_if_foundry_instance {
  ActiveInstance.kind = FoundryInstance or ActiveInstance.kind = HCALCInstance
  /* When Foundry: additive shape is the permitted witness family */
  ActiveInstance.kind = FoundryInstance implies
    (all t: Time | some t.next implies foundry_additive_step[t.at, t.next.at])
  /* When HCALC: nested shape is the permitted witness family */
  ActiveInstance.kind = HCALCInstance implies
    (all t: Time | some t.next implies hcalc_nested_step[t, t.at, t.next.at])
}

assert A4_foundry_additive_only_if_Foundry_instance {
  /* Sealed assert id A4 — PROPERTY_MAP */
  A4_foundry_step_only_if_foundry_instance
}

/* Bridge gap L7 / shape gap §0 — relationship axiom-gap; NOT equality.
 * Provenance: axiom-gap — GapId: Gap-ShapeMap (COHERENCE.md); L7 blocked
 * Assert id: INV_step_shape_bridge_axiom_gap */
one sig StepShapeBridge {
  /* defined empty until Spec supplies bridge; Int flag optional */
  defined: lone Int
}

/* Structural separation: distinct operator signatures (already separate sigs).
 * Record obligation that no model may treat them as the same family via bridge.defined. */
pred bridge_not_silent_equation {
  /* Bridge may not claim defined=1 without Spec GapId remap */
  no StepShapeBridge.defined or StepShapeBridge.defined != 1
  /* InstanceKind is exclusive */
}

fact fact_bridge_gap {
  bridge_not_silent_equation
}

assert INV_step_shape_bridge_axiom_gap {
  /* INV_step_shape_bridge_axiom_gap — axiom-gap (L7); NOT an equality theorem */
  bridge_not_silent_equation
}

assert INV_evolve_total_State_reachable {
  /* INV_evolve_total_State_reachable */
  evolution_total_on_State
}
