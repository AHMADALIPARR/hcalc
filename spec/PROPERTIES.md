<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC PROPERTIES (Verify outline)

**Owner:** HCALC Spec (outline) → HCALC Verify / Foundry J Verify (harness).  
**Pattern:** Foundry `PROPERTIES → J_API freeze → verify/ harness prop_N`.  
**Authority:** This file’s **PROPERTY_MAP** is authoritative for HCALC verify naming. Foundry props remain cited by number under `/workspace/foundry-j/spec/PROPERTIES.md` (cite-only).  
**Harness:** Not written here — see [`../verify/README.md`](../verify/README.md).

Absorbed obligations: [`FOUNDRY_J_CROSSLINKS.md`](FOUNDRY_J_CROSSLINKS.md).

---

## Gate sequence

1. **PROPERTIES** (this outline) — name props and SKIP reasons.  
2. **J_API freeze** — when a J surface is adopted, freeze nouns against `/workspace/foundry-j/spec/J_API.md`.  
3. **verify/ harness** — `prop_N` executables; map via PROPERTY_MAP.  
4. **Seal** — Lean ↔ Alloy ↔ J: `sorry` / Alloy unsat / missing A7 record ⇒ **SKIP** or **FAIL-open**, never PASS.

---

## Checks A–E (sketch)

| Check | Title | Intent | Gap / ID links | PASS requires |
|-------|-------|--------|----------------|---------------|
| **A** | Prime carrier | `P_64` length/contents; prime-index honesty | A1, L1, Gap-Tp-from-P64 | A1 holds for Foundry-backed instance |
| **B** | Contraction spectral / q | Gershgorin / power-iter / tier ε / q-budget | A2, A3, L2, L4 | contractive flags consistent; no silent ε |
| **C** | Evolution step shape + soft_project | Declare Foundry39 vs HCALC nested; soft_project when schedules | A3, A4, Gap-ShapeMap, L3, L7 | instance tag correct; **no** additive=nested without bridge |
| **D** | Field ids if \(\mathbb{F}_p\) | Goldilocks / field identifiers when carrier is finite-field | Gap-Carrier; Foundry 1–17 | ids match coded field; prop **16** FAIL kept in view if claimed |
| **E** | Cross-artifact seal | Lean ↔ Alloy ↔ J agreement | A7, L6, L5 unfinished | no PASS with sorry/unsat/opaque-undef |

---

## PROPERTY_MAP (authoritative names)

| HCALC prop id | Check | Statement (one line) | Foundry cite | Default if open |
|---------------|-------|----------------------|--------------|-----------------|
| H-A1 | A | P_64 cardinality and list | **23** | FAIL if Foundry instance and mismatch |
| H-A2 | B | contractive iff gershgorin < 1-ε | **33–34** | FAIL on contradiction |
| H-A3 | B/C | soft_project when q>1-ε | **43** | FAIL if schedules used and skipped |
| H-A4 | C | affine step only if instance=Foundry | **39** | FAIL on mixed symbols |
| H-A5 | A/E | PMAT conservation if PMAT used | **29** | SKIP if PMAT unused |
| H-A6 | B | guardian spectral legality | **55** | FAIL on illegal accept |
| H-A7 | E | definition-record for Λm, Ξ, C, Tp | — | FAIL-open if claimed defined without record |
| H-SHAPE | C | Gap-ShapeMap undischarged ⇒ no bridge PASS | — | **SKIP** bridge tests |
| H-L5 | E | Banach unique FP | **41** | SKIP/FAIL-open until proved |
| H-NEST | C | Nested HCALC step well-tagged | L6 gaps | SKIP numeric nested tests until defs |

---

## SKIP registry (names + reason)

| SKIP name | Reason |
|-----------|--------|
| SKIP-ShapeBridge | Gap-ShapeMap / L7 blocked; additive ≠ nested |
| SKIP-Λm-formula | Gap-Λm-scalar; no scalar formula |
| SKIP-C-instep | Gap-C-wrapper; Foundry tests are post-hoc |
| SKIP-Tp-law | Gap-Tp-from-P64; P_64 is index set only |
| SKIP-Ξ-op | Gap-Ξ; schedule ≠ operator |
| SKIP-OptObj | Gap-OptObj undefined |
| SKIP-L5-proof | L5 unfinished |
| SKIP-Goldilocks16 | Foundry prop **16** FAIL — do not claim PASS lift |

---

## Core citation targets (cite-only)

`P64`, `pmat_compose`, `spectral_analyze`, `soft_project`, `q_estimate`, `synth_weights`, `rec_step`, `rec_run`, `ace_certify`.

Docs: `/workspace/foundry-j/spec/J_API.md`, `GAP_DECISIONS.md`, `PROPERTIES.md`, `/workspace/foundry-j/j/BOXING.md`.
