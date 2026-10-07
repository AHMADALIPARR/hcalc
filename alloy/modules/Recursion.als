/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Recursion — prime-indexed recursion stage (bounded, not unrestricted).
 * Cite: FOUNDRY_J_CROSSLINKS.md §0; HCALC pipeline: prime-indexed recursion.
 * PENDING-SPEC-GAPID: Gap-T-p, Gap-X-state.
 * Safety: bounded evolution via finite Time (State module).
 */

module hcalc/modules/Recursion

open hcalc/modules/State
open hcalc/modules/PrimeIndex
open hcalc/modules/Transform

/* Recursion step: apply T_p at a prime index along Time.
 * Provenance: derived — structural next-state wiring for skeleton equation.
 * Core witness (intent, not Alloy proof): rec_step, P64 */
pred recurse_via_Tp[t: Time, tp: TpMap, s': State] {
  tp.index in P64Carrier.primes
  let s = t.at |
    some s => s' in s.(tp.apply)
}

/* Bounded recursion: every next Time is reached by at most one recursive edge
 * in the abstract pipeline (no unrestricted fixpoint search in Alloy).
 * Provenance: derived — safety-style constraint (bounded evolution). */
fact INV_bounded_recursion_depth {
  /* INV_bounded_recursion_depth */
  all t: Time | lone t.next
  /* finite Time sig + linear chain already caps depth */
}

assert INV_recursion_uses_prime_index {
  /* INV_recursion_uses_prime_index */
  all tp: TpMap | tp.index in P64Carrier.primes or
    (some e: PrimeExtension | tp.index in e.extra)
}
