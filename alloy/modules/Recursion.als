/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Recursion — prime-indexed recursion (bounded, not unrestricted).
 * Cite: FOUNDRY_J_CROSSLINKS.md §0; HCALC pipeline.
 * GapId: Gap-Tp-from-P64 (COHERENCE.md)
 * Core witnesses (intent): rec_step, P64.
 */

module modules/Recursion

open modules/State
open modules/PrimeIndex
open modules/Transform

pred recurse_via_Tp[t: Time, tp: TpMap, sNext: State] {
  tp.index in P64Carrier.primes
  sNext in (t.at).(tp.apply)
}

/* Assert id: INV_bounded_recursion_depth */
fact INV_bounded_recursion_depth {
  all t: Time | lone t.next
}

assert INV_recursion_uses_prime_index {
  /* INV_recursion_uses_prime_index */
  all tp: TpMap | tp.index in P64Carrier.primes or
    (some e: PrimeExtension | tp.index in e.extra)
}
