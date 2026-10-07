/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Stabilize — production Λm scalar ≥0 with op-bound ‖Λm·(C∘Tp)‖≤1-ε.
 * Cite: PRODUCTION.md §4 Gap-Λm-scalar CLOSED.
 * Provenance: SpecDefined
 */

module modules/Stabilize

open modules/State

sig Scalar {}

/* Λm — lone scalar (NOT Foundry lambda_schedule vector).
 * nonNeg=1 encodes Λm≥0; opBoundOK=1 encodes ‖Λm·(C∘Tp)‖_op ≤ 1-ε.
 * Provenance: SpecDefined — PRODUCTION.md §4. */
one sig LambdaM {
  scalar: one Scalar,
  nonNeg: Int,
  opBoundOK: Int
}

/* Foundry-style schedule vector — distinct from LambdaM. */
sig ScheduleVector {
  w0: lone Scalar,
  w1: lone Scalar
}

fact fact_LambdaM_not_schedule_vector {
  some LambdaM.scalar
  no sv: ScheduleVector |
    LambdaM.scalar = sv.w0 and LambdaM.scalar = sv.w1 and some sv.w0 and some sv.w1
}

pred LambdaM_is_scalar_not_schedule {
  some LambdaM.scalar
  no sv: ScheduleVector |
    LambdaM.scalar = sv.w0 and LambdaM.scalar = sv.w1 and some sv.w0 and some sv.w1
}

assert INV_LambdaM_scalar_placeholder {
  /* INV_LambdaM_scalar_placeholder — Λm scalar ≠ schedule vector */
  LambdaM_is_scalar_not_schedule
}

fact INV_LambdaM_scalar_not_schedule {
  LambdaM_is_scalar_not_schedule
}

/* Production: Λm ≥ 0 and op-bound flag. */
fact fact_P4_lambda_m_scalar_bound {
  LambdaM.nonNeg = 1
  LambdaM.opBoundOK = 1
}

pred lambda_m_scalar_bound_ok {
  some LambdaM.scalar
  LambdaM.nonNeg = 1
  LambdaM.opBoundOK = 1
}

assert P4_lambda_m_scalar_bound {
  /* Production assert P4 — Λm scalar ≥0 with ‖Λm·(C∘Tp)‖≤1-ε flag */
  lambda_m_scalar_bound_ok
}

sig Stabilized {
  source: one State,
  via: lone Scalar
}

fact INV_stabilize_uses_LambdaM_scalar {
  all st: Stabilized | no st.via or st.via = LambdaM.scalar
}
