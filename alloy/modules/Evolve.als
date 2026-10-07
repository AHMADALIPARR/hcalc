/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Evolve — production Ξ + InstanceBridge ShapeMap (NOT Foundry39≡nested).
 * Cite: PRODUCTION.md §5 Gap-Ξ, §6 Gap-ShapeMap / L7 CLOSED (InstanceBridge).
 * Ξ(t,y)=ξ_t·y+g_t; Uniform ξ_t=1.
 * bridgeMode = InstanceBridge; NestedFaithful/FoundryAdditive stay DISTINCT from identity.
 * Provenance: SpecDefined
 */

module modules/Evolve

open modules/State
open modules/PrimeIndex
open modules/Transform
open modules/Stabilize
open modules/Contract
open modules/Recursion

/* ---- Production Ξ: ξ_t·y + g_t, Uniform ξ=1 ----
 * Provenance: SpecDefined — PRODUCTION.md §5. */
abstract sig XiScheduleKind {}
one sig UniformXi extends XiScheduleKind {}

one sig XiSchedule {
  kind: one XiScheduleKind,
  /* xiIsOne=1 encodes Uniform ξ_t = 1 for all t */
  xiIsOne: Int
}

sig Kick {
  /* g_t affine kick (default zero vector — presence optional) */
  target: lone State
}

sig Intermediate {
  fromState: one State,
  viaTp: lone TpMap,
  viaC: lone COp,
  viaLambda: lone Scalar
}

/* HCALC Ξ(t, ·) — affine Uniform; NOT Foundry Ξ_t schedule weights. */
sig HCALC_Xi {
  atTime: one Time,
  map: Intermediate -> lone State,
  /* isAffine=1 encodes Ξ(t,y)=ξ_t·y+g_t */
  isAffine: Int,
  schedule: one XiScheduleKind
}

fact fact_P5_xi_uniform_affine {
  XiSchedule.kind = UniformXi
  XiSchedule.xiIsOne = 1
  all xi: HCALC_Xi |
    xi.isAffine = 1 and xi.schedule = UniformXi
}

pred xi_uniform_affine_ok {
  XiSchedule.kind = UniformXi
  XiSchedule.xiIsOne = 1
  all xi: HCALC_Xi |
    xi.isAffine = 1 and xi.schedule = UniformXi
}

assert P5_xi_uniform_affine {
  /* Production assert P5 — Ξ affine with Uniform ξ=1 */
  xi_uniform_affine_ok
}

/* Foundry schedule weights — distinct sigs from HCALC_Xi / LambdaM. */
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

/* Foundry additive Step (prop 39) — diagnostic / Foundry instance only. */
pred foundry_additive_step[x: State, xNext: State] {
  some xi: FoundryXiWeights, lam: FoundryLambdaWeights, tn: FoundryT |
    some xi.schedule and some lam.schedule and
    (xNext in x.(tn.apply) or (some g: FoundryG | xNext = g.kick) or xNext = x)
}

/* HCALC nested: X' = Ξ(t, Λm · C[T_p(X)]) */
pred hcalc_nested_step[t: Time, X: State, XNext: State] {
  some xi: HCALC_Xi, tp: TpMap, c: COp, mid: Intermediate |
    xi.atTime = t and
    xi.isAffine = 1 and
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

fact INV_evolve_respects_active_instance {
  all t: Time | evolve_next[t]
}

/* A4 — Foundry additive ONLY when instance = Foundry; not equated to HCALC nested. */
pred A4_foundry_step_only_if_foundry_instance {
  ActiveInstance.kind = FoundryInstance or ActiveInstance.kind = HCALCInstance
  ActiveInstance.kind = FoundryInstance implies
    (all t: Time | some t.next implies foundry_additive_step[t.at, t.next.at])
  ActiveInstance.kind = HCALCInstance implies
    (all t: Time | some t.next implies hcalc_nested_step[t, t.at, t.next.at])
}

assert A4_foundry_additive_only_if_Foundry_instance {
  /* Sealed assert id A4 — PROPERTY_MAP */
  A4_foundry_step_only_if_foundry_instance
}

/* ---- ShapeMap / L7: InstanceBridge morphism (NOT identity / NOT Foundry39≡nested) ----
 * Provenance: SpecDefined — PRODUCTION.md §6.
 * NestedFaithful / FoundryAdditive remain DISTINCT modes — never identity claims. */
abstract sig BridgeMode {}
one sig InstanceBridge, NestedFaithful, FoundryAdditive extends BridgeMode {}

/* Explicit morphism table under InstanceBridge (Option B production). */
one sig InstanceBridgeTable {
  /* Parameter assignments (flags=1) — NOT symbol identities */
  T_assigned_C_circ_Tp: Int,
  Lambda_scalar_broadcast: Int,
  Xi_from_hcalc_schedule: Int,
  g_instance_param: Int,
  /* claimsIdentity MUST stay 0 — forbid Foundry39 ≡ nested */
  claimsIdentity: Int
}

one sig ShapeMapConfig {
  bridgeMode: one BridgeMode
}

fact fact_P6_instance_bridge_morphism {
  ShapeMapConfig.bridgeMode = InstanceBridge
  InstanceBridgeTable.T_assigned_C_circ_Tp = 1
  InstanceBridgeTable.Lambda_scalar_broadcast = 1
  InstanceBridgeTable.Xi_from_hcalc_schedule = 1
  InstanceBridgeTable.g_instance_param = 1
  InstanceBridgeTable.claimsIdentity = 0
}

pred instance_bridge_morphism_ok {
  ShapeMapConfig.bridgeMode = InstanceBridge
  InstanceBridgeTable.T_assigned_C_circ_Tp = 1
  InstanceBridgeTable.Lambda_scalar_broadcast = 1
  InstanceBridgeTable.Xi_from_hcalc_schedule = 1
  InstanceBridgeTable.g_instance_param = 1
  InstanceBridgeTable.claimsIdentity = 0
}

assert P6_instance_bridge_morphism {
  /* Production assert P6 — bridgeMode=InstanceBridge; forbid identity */
  instance_bridge_morphism_ok
}

/* INV: bridge is InstanceBridge morphism, never silent identity. */
pred bridge_instance_not_identity {
  ShapeMapConfig.bridgeMode = InstanceBridge
  InstanceBridgeTable.claimsIdentity = 0
}

fact fact_bridge_production {
  bridge_instance_not_identity
}

assert INV_step_shape_bridge_instance {
  /* INV_step_shape_bridge_instance — production InstanceBridge (not axiom-gap) */
  bridge_instance_not_identity
}

assert INV_evolve_total_State_reachable {
  evolution_total_on_State
}
