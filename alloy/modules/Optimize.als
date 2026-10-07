/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Optimize — optimization objective as axiom-gap (UNDEFINED in source).
 * Cite: HCALC pipeline stage "optimize"; FOUNDRY_J_CROSSLINKS.md (no Foundry objective).
 * PENDING-SPEC-GAPID: (await Spec) — do NOT invent an objective theorem.
 */

module hcalc/modules/Optimize

open hcalc/modules/State

/* Objective is UNDEFINED — underspecified predicate only.
 * Provenance: axiom-gap — no invented loss/utility formula. */
sig Objective {
  /* opaque score on State; no semantics claimed */
  score: State -> lone Int
}

pred objective_underspecified {
  /* Presence of Objective atoms is allowed; no optimality theorem asserted. */
  all o: Objective | all s: State | lone s.(o.score)
}

assert INV_optimize_objective_axiom_gap {
  /* INV_optimize_objective_axiom_gap — axiom-gap placeholder */
  objective_underspecified
}
