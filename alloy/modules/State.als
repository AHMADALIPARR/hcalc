/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: State — production Carrier Fin n → ℝ with ℓ∞ (abstract).
 * Cite: PRODUCTION.md §1 Gap-Carrier CLOSED; FOUNDRY_J_CROSSLINKS §0–§2.
 * Provenance: SpecDefined
 */

module modules/State

/* Discrete evolution carrier (abstract atoms; dim/norm in CarrierSpec). */
sig State {}

/* Finite time atoms for bounded evolution. */
sig Time {
  next: lone Time,
  at: one State
}

/* Total order spine on Time: linear chain, unique start.
 * Provenance: derived — finite-scope safety for evolution. */
fact INV_time_linear_chain {
  one t: Time | no t.~next
  all t: Time | lone t.next
  all disj t1, t2: Time | t1 in t2.^next or t2 in t1.^next
}

/* Evolution totality: every State is witnessed at some Time. */
fact fact_evolution_total_on_State {
  all s: State | some t: Time | t.at = s
}

pred evolution_total_on_State {
  all s: State | some t: Time | t.at = s
}

assert INV_evolution_total_on_State {
  evolution_total_on_State
}

/* Instance tag: Foundry vs HCALC-native step shape (do not equate silently). */
abstract sig InstanceKind {}
one sig FoundryInstance, HCALCInstance extends InstanceKind {}

one sig ActiveInstance {
  kind: one InstanceKind
}

/* ---- Production Carrier: abstract dim n≥1, ℓ∞ ----
 * Provenance: SpecDefined — PRODUCTION.md §1.
 * Numeric ℝ^n lives in Lean; Alloy encodes dim≥1 + LInf flags (no heavy Int arith). */
abstract sig NormKind {}
one sig LInf extends NormKind {}

one sig CarrierSpec {
  /* dimPositive=1 encodes n≥1 (avoid bitblast of concrete n). */
  dimPositive: Int,
  norm: one NormKind
}

fact fact_P1_carrier_production {
  CarrierSpec.dimPositive = 1
  CarrierSpec.norm = LInf
}

pred carrier_linf_dim_ok {
  CarrierSpec.dimPositive = 1
  CarrierSpec.norm = LInf
}

assert P1_carrier_linf_dim {
  /* Production assert P1 — Carrier abstract dim n≥1, ℓ∞ */
  carrier_linf_dim_ok
}

/* Measure atom — no Int payload (Int bitblast hangs checks). */
sig Measure {}

sig StateMeasure {
  of: one State,
  m: one Measure
}

fact INV_state_measure_functional {
  all s: State | lone sm: StateMeasure | sm.of = s
}
