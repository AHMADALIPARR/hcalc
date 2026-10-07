/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: PrimeIndex — P_64 prime-index integrity (Foundry prop 23).
 * Cite: FOUNDRY_J_CROSSLINKS.md §1, §3 A1; Core witness: P64.
 * PENDING-SPEC-GAPID: Gap-T-p (T_p valued on P_64 or stated extension; remap via Spec).
 */

module hcalc/modules/PrimeIndex

/* Abstract prime labels. Integrity = distinct indices + underspecified isPrimeLabel.
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS prop 23 / A1.
 * We do NOT embed the numeric first-64 prime list as theorems; Alloy scopes
 * check cardinality and distinctness. Numeric list is Lean L1 data. */
sig PrimeLabel {
  idx: Int  /* discrete index into the P_64 carrier */
}

/* P64Carrier: sealed abstract of Foundry P_64 (length-64 list).
 * Provenance: source-claim — PROPERTIES 23; #P_64 = 64.
 * Core witness (intent, not Alloy proof): P64 */
one sig P64Carrier {
  primes: set PrimeLabel
}

/* Underspecified predicate: label is a valid prime (numeric check deferred to Lean).
 * Provenance: axiom-gap — Alloy cannot verify primality of concrete ℕ values here. */
pred isPrimeLabel[p: PrimeLabel] {
  /* structural stand-in: index in [0,63] and membership in carrier */
  p.idx >= 0 and p.idx <= 63
  p in P64Carrier.primes
}

/* A1 — #P_64 = 64 and elements are distinct first-64 prime slots.
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §3 A1 / prop 23.
 * Note: concrete prime VALUES are Lean L1; Alloy checks cardinality + distinct idx. */
pred prime_index_integrity {
  #P64Carrier.primes = 64
  all disj p1, p2: P64Carrier.primes | p1.idx != p2.idx
  all p: P64Carrier.primes | isPrimeLabel[p]
  all p: P64Carrier.primes | p.idx >= 0 and p.idx <= 63
}

assert A1_P64_cardinality_and_distinct {
  /* Sealed assert id A1 — PROPERTY_MAP */
  prime_index_integrity
}

/* No silent infinite prime stream: every PrimeLabel in model is in P64 or flagged extension.
 * Provenance: source-claim — FOUNDRY_J_CROSSLINKS §2 item 2. */
pred no_unbounded_prime_stream {
  PrimeLabel = P64Carrier.primes
}

assert INV_prime_index_bounded_to_P64 {
  /* INV_prime_index_bounded_to_P64 */
  no_unbounded_prime_stream
}

/* Optional extension hook (empty by default) — must be stated, never silent.
 * Provenance: derived — honesty clause for Spec overrides. */
sig PrimeExtension {
  extra: set PrimeLabel
}

fact INV_extension_disjoint_or_empty {
  /* INV_extension_disjoint_or_empty */
  all e: PrimeExtension |
    e.extra in P64Carrier.primes or
    (no (e.extra & P64Carrier.primes) and all p: e.extra | p.idx > 63)
}
