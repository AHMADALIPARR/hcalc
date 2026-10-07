/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Stabilize — Λm as lone scalar placeholder (NOT a schedule vector).
 * Cite: FOUNDRY_J_CROSSLINKS.md §0 (Λm undefined; Foundry has Λ_t weights only);
 *       Hilbert: Λm = lone scalar placeholder NOT schedule vector.
 * PENDING-SPEC-GAPID: Gap-Lambda-m — do NOT invent a definition.
 */

module hcalc/modules/Stabilize

open hcalc/modules/State

/* Λm — UNDEFINED in source. Scalar constraint placeholder only.
 * Provenance: axiom-gap — PENDING-SPEC-GAPID: Gap-Lambda-m
 * Explicitly NOT a Foundry Λ_t schedule vector (length-2 weights). */
sig Scalar {}

/* Lone global Λm placeholder (0 or 1 scalar selected as the multiplicity stabilizer).
 * Provenance: axiom-gap — FOUNDRY_J_CROSSLINKS §3 A7 / §2 item 8. */
one sig LambdaM {
  /* lone: at most one scalar; may be absent until Spec defines it */
  scalar: lone Scalar
}

/* Forbidden: treating Λm as a schedule vector (Foundry Λ_t shape).
 * Provenance: source-claim — shape gap §0; Hilbert constraint. */
sig ScheduleVector {
  /* Foundry-style length-2 weights — distinct from LambdaM */
  w0: lone Scalar,
  w1: lone Scalar
}

pred LambdaM_is_scalar_not_schedule {
  /* Λm occupies Scalar slot only; no ScheduleVector identity */
  no sv: ScheduleVector | sv.w0 = LambdaM.scalar and sv.w1 = LambdaM.scalar
  /* cardinality discipline: LambdaM.scalar is lone (by sig) */
  lone LambdaM.scalar
}

assert INV_LambdaM_scalar_placeholder {
  /* INV_LambdaM_scalar_placeholder — PROPERTY_MAP */
  LambdaM_is_scalar_not_schedule
}

/* Stabilized multiplicity: optional link from State to Λm scalar (underspecified).
 * Provenance: axiom-gap — no invented stabilize algorithm. */
sig Stabilized {
  source: one State,
  via: lone Scalar
}

fact INV_stabilize_uses_LambdaM_scalar {
  /* INV_stabilize_uses_LambdaM_scalar */
  all st: Stabilized | no st.via or st.via = LambdaM.scalar
}
