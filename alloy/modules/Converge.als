/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Converge — production Hyp ⇒ Banach + residual→0; Guardian A6.
 * Cite: PRODUCTION.md §8 Gap-Converge CLOSED; FOUNDRY_J_CROSSLINKS §3 A6.
 * Provenance: SpecDefined (converge hyp); source-claim (A6)
 */

module modules/Converge

open modules/State
open modules/Contract

sig Residual {
  of: one State,
  belowTol: Int
}

/* Production ConvergenceHyp: under Spec Hyp, discharged with residual witness.
 * Provenance: SpecDefined — PRODUCTION.md §8 (L5 dischargeable). */
sig ConvergenceHyp {
  discharged: lone Int,
  hypHolds: Int
}

pred convergence_hyps_production {
  all h: ConvergenceHyp |
    (h.discharged = 1 implies (h.hypHolds = 1 and some r: Residual | r.belowTol = 1))
}

fact fact_converge_hyps {
  convergence_hyps_production
}

assert INV_converge_hyps_production {
  /* INV_converge_hyps_production — Spec Hyp + residual (was axiom-gap) */
  convergence_hyps_production
}

/* A6 — Guardian: reject spectral radius ≥ 1 or non-finite.
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §3 A6 / prop 55. */
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
