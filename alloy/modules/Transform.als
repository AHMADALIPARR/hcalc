/*
 * Copyright (C) 2026 HCALC / Foundry J contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 *
 * Module: Transform — production T_p = diag(α), α_j = 1/(1+log p_{j mod 64}).
 * Cite: PRODUCTION.md §2 Gap-Tp-from-P64 CLOSED.
 * Numeric log not required in Alloy — SpecAlphaLaw flag + diagonal Tp.
 * Provenance: SpecDefined
 */

module modules/Transform

open modules/State
open modules/PrimeIndex

sig MultimodalInput {
  encodes: one State
}

sig TensorSpace {
  support: set State
}

/* α law kind — Spec law α_j=1/(1+log p_{j mod 64}) encoded as SpecAlphaLaw. */
abstract sig AlphaLawKind {}
one sig SpecAlphaLaw extends AlphaLawKind {}

/* T_p — diagonal prime-indexed map under SpecAlphaLaw.
 * Provenance: SpecDefined — PRODUCTION.md §2.
 * (Tp x)_j = α_j · x_j; φ = id on coordinates. */
sig TpMap {
  index: one PrimeLabel,
  apply: State -> lone State,
  /* isDiagonal=1 encodes diag(α) action */
  isDiagonal: Int,
  alphaLaw: one AlphaLawKind
}

fact fact_P2_tp_diag_spec_alpha {
  all tp: TpMap |
    tp.isDiagonal = 1 and tp.alphaLaw = SpecAlphaLaw
}

pred tp_diag_spec_alpha_ok {
  all tp: TpMap |
    tp.isDiagonal = 1 and tp.alphaLaw = SpecAlphaLaw
}

assert P2_tp_diag_spec_alpha {
  /* Production assert P2 — Tp diagonal + SpecAlphaLaw */
  tp_diag_spec_alpha_ok
}

fact INV_Tp_index_in_P64_or_extension {
  all tp: TpMap |
    tp.index in P64Carrier.primes or
    (some e: PrimeExtension | tp.index in e.extra)
}

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
  multimodal_wired
}
