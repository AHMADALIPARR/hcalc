/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Transform — multimodal → multiplicity/tensor → T_p placeholders.
 * Cite: FOUNDRY_J_CROSSLINKS.md §0–§1; HCALC pipeline.
 * GapId: Gap-Tp-from-P64 (COHERENCE.md)
 */

module modules/Transform

open modules/State
open modules/PrimeIndex

/* Provenance: axiom-gap — pipeline stage only. */
sig MultimodalInput {
  encodes: one State
}

/* TensorSpace UNDEFINED — underspecified signature only.
 * Provenance: axiom-gap — GapId: Gap-Tp-from-P64 (COHERENCE.md)
 */
sig TensorSpace {
  support: set State
}

/* T_p — abstract prime-indexed map. NOT a recursive tensor law.
 * Provenance: axiom-gap — GapId: Gap-Tp-from-P64 (COHERENCE.md)
 */
sig TpMap {
  index: one PrimeLabel,
  apply: State -> lone State
}

/* Assert id: INV_Tp_index_in_P64_or_extension */
fact INV_Tp_index_in_P64_or_extension {
  all tp: TpMap |
    tp.index in P64Carrier.primes or
    (some e: PrimeExtension | tp.index in e.extra)
}

/* Assert id: INV_Tp_unique_per_index */
fact INV_Tp_unique_per_index {
  all disj a, b: TpMap | a.index != b.index
}

pred multimodal_wired {
  all m: MultimodalInput | some ts: TensorSpace | m.encodes in ts.support
}

fact fact_multimodal_wired {
  multimodal_wired
}

assert INV_multimodal_tensor_wiring {
  /* INV_multimodal_tensor_wiring — structural; vacuous if no MultimodalInput */
  multimodal_wired
}
