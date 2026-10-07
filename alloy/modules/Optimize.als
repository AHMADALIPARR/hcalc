/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Optimize — optimization objective as axiom-gap (UNDEFINED in source).
 * Cite: HCALC pipeline "optimize"; no Foundry objective in FOUNDRY_J_CROSSLINKS.
 * GapId: Gap-OptObj (COHERENCE.md)
 */

module modules/Optimize

open modules/State

/* Provenance: axiom-gap — no invented loss/utility formula. */
sig Objective {
  score: State -> lone Int
}

pred objective_underspecified {
  all o: Objective | all s: State | lone s.(o.score)
}

assert INV_optimize_objective_axiom_gap {
  /* INV_optimize_objective_axiom_gap — axiom-gap placeholder */
  objective_underspecified
}
