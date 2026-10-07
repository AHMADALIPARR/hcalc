/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: State — discrete evolution carrier for HCALC Alloy skeleton.
 * Cite: FOUNDRY_J_CROSSLINKS.md §0–§2; HCALC abstract X_{t+1}=Ξ(t,Λm·C[T_p(X_t)]).
 * GapId: Gap-Carrier (COHERENCE.md)
 */

module modules/State

/* Provenance: axiom-gap — State is an opaque carrier; no invented tensor law. */
sig State {}

/* Finite time atoms for bounded evolution (safety: not unrestricted recursion).
 * Provenance: derived — structural scaffolding for next-state relations. */
sig Time {
  next: lone Time,
  at: one State
}

/* Total order spine on Time: linear chain, unique start.
 * Provenance: derived — finite-scope safety for evolution.
 * Assert id: INV_time_linear_chain */
fact INV_time_linear_chain {
  /* unique root + functional next + single chain */
  one t: Time | no t.~next
  all t: Time | lone t.next
  all disj t1, t2: Time | t1 in t2.^next or t2 in t1.^next
}

/* Evolution totality: every State is witnessed at some Time.
 * Provenance: source-claim — Hilbert: evolution total on State.
 * Core witness (intent, not Alloy proof): rec_step
 * Assert id: INV_evolution_total_on_State */
fact fact_evolution_total_on_State {
  all s: State | some t: Time | t.at = s
}

pred evolution_total_on_State {
  all s: State | some t: Time | t.at = s
}

assert INV_evolution_total_on_State {
  evolution_total_on_State
}

/* Instance tag: Foundry vs HCALC-native step shape (do not equate silently).
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §0 shape gap; A4. */
abstract sig InstanceKind {}
one sig FoundryInstance, HCALCInstance extends InstanceKind {}

one sig ActiveInstance {
  kind: one InstanceKind
}

/* Underspecified measure for contraction decrease (algorithm undefined).
 * Provenance: axiom-gap — GapId: Gap-C-wrapper / Gap-ContractAlg (COHERENCE.md)
 * Core witness (intent): spectral_analyze / q_estimate */
/* Measure atom — no Int payload (Int bitblast hangs checks).
 * Ordering for contraction is relational in Contract module (Gap-ContractAlg). */
sig Measure {}

sig StateMeasure {
  of: one State,
  m: one Measure
}

/* Assert id: INV_state_measure_functional */
fact INV_state_measure_functional {
  all s: State | lone sm: StateMeasure | sm.of = s
}
