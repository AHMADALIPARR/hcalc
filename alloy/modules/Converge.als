/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Converge — convergence hypotheses as axiom-gap; Guardian A6.
 * Cite: FOUNDRY_J_CROSSLINKS.md §2 item 5; §3 A6; props 41, 46, 55.
 * Core witnesses (intent): spectral_analyze, q_estimate.
 * PENDING-SPEC-GAPID: convergence hyps undefined — no fake Banach theorems.
 */

module hcalc/modules/Converge

open hcalc/modules/State
open hcalc/modules/Contract

/* Residual / tolerance placeholders (Foundry 46 style) — opaque.
 * Provenance: axiom-gap — unique fixed-point only where Banach hyps discharged. */
sig Residual {
  of: one State,
  belowTol: Int  /* 1 = residual below declared tolerance */
}

/* ConvergenceHyp — UNDEFINED hypotheses bundle (no invented discharge).
 * Provenance: axiom-gap — FOUNDRY_J_CROSSLINKS §2 item 5 / Lean L5 unfinished. */
sig ConvergenceHyp {
  /* discharged=1 only when Spec/Lean says so; default unconstrained */
  discharged: lone Int
}

pred convergence_hyps_axiom_gap {
  /* Do not claim fixed-point uniqueness from narrative alone. */
  all h: ConvergenceHyp | h.discharged = 1 implies
    (some r: Residual | r.belowTol = 1)
}

assert INV_converge_hyps_axiom_gap {
  /* INV_converge_hyps_axiom_gap — axiom-gap; NOT a Banach theorem */
  convergence_hyps_axiom_gap
}

/* A6 — Guardian: reject spectral radius ≥ 1 or non-finite next state.
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §3 A6 / prop 55.
 * Core witness (intent): spectral_analyze */
abstract sig GuardianVerdict {}
one sig Accept, Reject extends GuardianVerdict {}

sig GuardianCheck {
  subject: one State,
  spectralRadiusGeOne: Int,  /* 1 = rho >= 1 */
  nonFinite: Int,            /* 1 = non-finite next state */
  verdict: one GuardianVerdict
}

pred guardian_reject_illegal {
  all g: GuardianCheck |
    (g.spectralRadiusGeOne = 1 or g.nonFinite = 1) implies g.verdict = Reject
  all g: GuardianCheck |
    (g.spectralRadiusGeOne = 0 and g.nonFinite = 0) implies g.verdict = Accept
}

assert A6_guardian_reject_spectral_or_nonfinite {
  /* Sealed assert id A6 — PROPERTY_MAP */
  guardian_reject_illegal
}
