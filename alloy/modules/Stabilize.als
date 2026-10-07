/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Stabilize — Λm as lone scalar placeholder (NOT a schedule vector).
 * Cite: FOUNDRY_J_CROSSLINKS.md §0; Hilbert: Λm = lone scalar NOT schedule vector.
 * GapId: Gap-Λm-scalar (COHERENCE.md)
 */

module modules/Stabilize

open modules/State

sig Scalar {}

/* Λm UNDEFINED — lone scalar placeholder only.
 * Provenance: axiom-gap — GapId: Gap-Λm-scalar (COHERENCE.md)
 */
one sig LambdaM {
  scalar: lone Scalar
}

/* Foundry-style schedule vector — distinct sig from LambdaM (not a schedule). */
sig ScheduleVector {
  w0: lone Scalar,
  w1: lone Scalar
}

/* Structural: Λm is a lone scalar placeholder, never a 2-slot schedule vector.
 * Provenance: axiom-gap — Gap-Λm-scalar */
fact fact_LambdaM_not_schedule_vector {
  lone LambdaM.scalar
  /* Forbid identifying Λm with a schedule by occupying both weight slots. */
  no sv: ScheduleVector |
    some LambdaM.scalar and LambdaM.scalar = sv.w0 and LambdaM.scalar = sv.w1
}

pred LambdaM_is_scalar_not_schedule {
  lone LambdaM.scalar
  no sv: ScheduleVector |
    some LambdaM.scalar and LambdaM.scalar = sv.w0 and LambdaM.scalar = sv.w1
}


assert INV_LambdaM_scalar_placeholder {
  /* INV_LambdaM_scalar_placeholder — PROPERTY_MAP */
  LambdaM_is_scalar_not_schedule
}

fact INV_LambdaM_scalar_not_schedule {
  /* Force G-Lm discipline in all instances */
  LambdaM_is_scalar_not_schedule
}

sig Stabilized {
  source: one State,
  via: lone Scalar
}

/* Assert id: INV_stabilize_uses_LambdaM_scalar */
fact INV_stabilize_uses_LambdaM_scalar {
  all st: Stabilized | no st.via or st.via = LambdaM.scalar
}
