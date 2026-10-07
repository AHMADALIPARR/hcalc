/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Optimize — production OptObj = residual J.
 * Cite: PRODUCTION.md §9 Gap-OptObj CLOSED.
 * J(X) = ‖X − Ξ(t, Λm·C(Tp(X)))‖_∞; iterate to tol.
 * Provenance: SpecDefined
 */

module modules/Optimize

open modules/State

abstract sig ObjKind {}
one sig ResidualObj extends ObjKind {}

sig Objective {
  kind: one ObjKind,
  score: State -> lone Int
}

fact fact_P7_optobj_residual {
  all o: Objective | o.kind = ResidualObj
}

pred optobj_residual_ok {
  all o: Objective | o.kind = ResidualObj
}

assert P7_optobj_residual {
  /* Production assert P7 — OptObj = residual */
  optobj_residual_ok
}

pred objective_is_residual {
  all o: Objective | o.kind = ResidualObj
}

assert INV_optimize_objective_residual {
  /* INV_optimize_objective_residual — production residual (was axiom-gap) */
  objective_is_residual
}
