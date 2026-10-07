/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Converge — convergence hypotheses as axiom-gap; Guardian A6.
 * Cite: FOUNDRY_J_CROSSLINKS.md §2 item 5; §3 A6; props 41, 46, 55.
 * Core witnesses (intent): spectral_analyze, q_estimate.
 * GapId: Gap-Converge (COHERENCE.md)
 */

module modules/Converge

open modules/State
open modules/Contract

sig Residual {
  of: one State,
  belowTol: Int
}

/* Provenance: axiom-gap — FOUNDRY_J_CROSSLINKS §2 item 5 / Lean L5 unfinished. */
sig ConvergenceHyp {
  discharged: lone Int
}

pred convergence_hyps_axiom_gap {
  all h: ConvergenceHyp |
    h.discharged = 1 implies (some r: Residual | r.belowTol = 1)
}

/* Assert id: INV_converge_hyps_axiom_gap */
fact fact_converge_hyps {
  convergence_hyps_axiom_gap
}

assert INV_converge_hyps_axiom_gap {
  convergence_hyps_axiom_gap
}

/* A6 — Guardian: reject spectral radius ≥ 1 or non-finite.
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §3 A6 / prop 55.
 * Core witness (intent): spectral_analyze */
abstract sig GuardianVerdict {}
one sig Accept, Reject extends GuardianVerdict {}

sig GuardianCheck {
  subject: one State,
  spectralRadiusGeOne: Int,
  nonFinite: Int,
  verdict: one GuardianVerdict
}

fact fact_A6_guardian {
  all g: GuardianCheck |
    (g.spectralRadiusGeOne = 1 or g.nonFinite = 1) implies g.verdict = Reject
  all g: GuardianCheck |
    (g.spectralRadiusGeOne = 0 and g.nonFinite = 0) implies g.verdict = Accept
}

assert A6_guardian_reject_spectral_or_nonfinite {
  /* Sealed assert id A6 — PROPERTY_MAP */
  all g: GuardianCheck |
    ((g.spectralRadiusGeOne = 1 or g.nonFinite = 1) implies g.verdict = Reject) and
    ((g.spectralRadiusGeOne = 0 and g.nonFinite = 0) implies g.verdict = Accept)
}
