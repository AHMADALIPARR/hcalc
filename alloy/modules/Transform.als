/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Transform — multimodal → multiplicity/tensor → T_p placeholders.
 * Cite: FOUNDRY_J_CROSSLINKS.md §0–§1; HCALC pipeline.
 * PENDING-SPEC-GAPID: Gap-T-p — T_p undefined; tensor spaces undefined.
 * No invented recursive tensor law.
 */

module hcalc/modules/Transform

open hcalc/modules/State
open hcalc/modules/PrimeIndex

/* Multimodal input token (opaque).
 * Provenance: axiom-gap — pipeline stage only; no semantics invented. */
sig MultimodalInput {
  encodes: one State
}

/* TensorSpace is UNDEFINED in source — underspecified signature only.
 * Provenance: axiom-gap — PENDING-SPEC-GAPID: Gap-T-p / tensor spaces.
 * Do NOT invent dimension or product theorems. */
sig TensorSpace {
  /* placeholder carrier link; no product axioms claimed */
  support: set State
}

/* T_p — prime-indexed transform: abstract function State → State, indexed by PrimeLabel.
 * Provenance: axiom-gap — PENDING-SPEC-GAPID: Gap-T-p
 * Closest Foundry hooks: P_64 + PMAT + T(x); NOT a definition of recursive T_p. */
sig TpMap {
  index: one PrimeLabel,
  apply: State -> lone State
}

fact INV_Tp_index_in_P64_or_extension {
  /* INV_Tp_index_in_P64_or_extension — prime-index honesty for T_p */
  all tp: TpMap |
    tp.index in P64Carrier.primes or
    (some e: PrimeExtension | tp.index in e.extra)
}

/* Structural: at most one TpMap per prime index in a finite model.
 * Provenance: derived — integrity, not a math theorem about T_p. */
fact INV_Tp_unique_per_index {
  /* INV_Tp_unique_per_index */
  all disj a, b: TpMap | a.index != b.index
}

/* Pipeline stage marker: multimodal related to some tensor support.
 * Provenance: derived — structural wiring only. */
pred multimodal_wired {
  all m: MultimodalInput | some ts: TensorSpace | m.encodes in ts.support
}

assert INV_multimodal_tensor_wiring {
  /* INV_multimodal_tensor_wiring */
  multimodal_wired
}
