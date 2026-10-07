<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC PROPERTIES (Verify outline)

**Owner:** HCALC Spec (outline) → HCALC Verify / Foundry J Verify (harness).  
**Pattern:** Foundry `PROPERTIES → J_API freeze → verify/ harness prop_N`.  
**Authority:** This file’s **PROPERTY_MAP** is authoritative for HCALC verify naming. Foundry props remain cited by number under `/workspace/foundry-j/spec/PROPERTIES.md` (cite-only).  
**Production:** [`PRODUCTION.md`](PRODUCTION.md) — domain Gap-* CLOSED; flip SKIP→PASS where hyps hold.  
**Harness:** Not written here — see [`../verify/README.md`](../verify/README.md).

Absorbed obligations: [`FOUNDRY_J_CROSSLINKS.md`](FOUNDRY_J_CROSSLINKS.md).

---

## Gate sequence

1. **PROPERTIES** (this outline) — name props and SKIP reasons.  
2. **J_API freeze** — when a J surface is adopted, freeze nouns against `/workspace/foundry-j/spec/J_API.md` and `/workspace/hcalc/j/`.  
3. **verify/ harness** — `prop_N` executables; map via PROPERTY_MAP.  
4. **Seal** — Lean ↔ Alloy ↔ J: `sorry` / Alloy unsat / missing A7 SpecDefined ⇒ **SKIP** or **FAIL-open**, never PASS.

---

## Checks A–E (disposition under production defs)

| Check | Title | Intent | Gap / ID links | PASS requires |
|-------|-------|--------|----------------|---------------|
| **A** | Prime carrier | `P_64` length/contents; Tp α law | A1, L1, Gap-Tp-from-P64 (**CLOSED**, α **spec-def**) | A1 holds; diag Tp encoded |
| **B** | Contraction spectral / q | Gershgorin / power-iter / tier ε / Spec q-budget | A2, A3, L2, L4, Gap-C (**spec-adapt**) | contractive flags consistent; C scale-or-id |
| **C** | Evolution step shape | Dual bridgeMode NestedFaithful\|FoundryAdditive; InstanceBridge table | A3, A4, Gap-ShapeMap, L3, L7 | instance/bridgeMode correct; **no** additive=`rfl` nested |
| **D** | Field ids if \(\mathbb{F}_p\) | Goldilocks / field identifiers when carrier is finite-field | Gap-Carrier optional; Foundry 1–17 | ids match coded field; prop **16** FAIL kept in view if claimed |
| **E** | Cross-artifact seal | Lean ↔ Alloy ↔ J agreement | A7 SpecDefined, L6 defs, L5 under Hyp | no PASS with sorry/unsat/Undefined A7 |

---

## PROPERTY_MAP (authoritative names)

| HCALC prop id | Check | Statement (one line) | Foundry cite | Default if open |
|---------------|-------|----------------------|--------------|-----------------|
| H-A1 | A | P_64 cardinality and list | **23** | FAIL if Foundry instance and mismatch |
| H-A2 | B | contractive iff gershgorin < 1-ε | **33–34** | FAIL on contradiction |
| H-A3 | B/C | scale-or-id when Spec q>1-ε (C) | cousin of **43** | FAIL if production C skipped |
| H-A4 | C | affine step only if FoundryAdditive / instance=Foundry | **39** | FAIL on mixed symbols / silent identity |
| H-A5 | A/E | PMAT conservation if PMAT used | **29** | SKIP if PMAT unused |
| H-A6 | B | guardian spectral legality | **55** | FAIL on illegal accept |
| H-A7 | E | SpecDefined definition-record for Λm, Ξ, C, Tp | PRODUCTION.md | FAIL-open if Undefined |
| H-SHAPE | C | InstanceBridge witness (NOT identity) | PRODUCTION §6 | **PASS** under InstanceBridge; never identity PASS |
| H-L5 | E | Banach unique FP under Hyp | **41** | PASS when Hyp discharged; else SKIP/FAIL-open |
| H-NEST | C | Nested `hcalcStep` well-tagged (NestedFaithful) | PRODUCTION §§5–6 | PASS when nested defs hold |
| H-OPT | E | residual \(J\) \(\ell_\infty\) < tol | PRODUCTION §9 (≠ **46** \(\ell_2\)) | PASS when iterate-to-tol |

---

## SKIP registry (names + reason)

| SKIP name | Reason | Production disposition |
|-----------|--------|------------------------|
| SKIP-ShapeBridge | Was: Gap-ShapeMap / L7 blocked | **RETIRE** for InstanceBridge tests → PASS; keep SKIP only for identity/`rfl` claims |
| SKIP-Λm-formula | Was: no scalar formula | **RETIRE** — Λm CLOSED |
| SKIP-C-instep | Was: post-hoc only | **RETIRE** — C CLOSED (spec-adapt) |
| SKIP-Tp-law | Was: P_64 index only | **RETIRE** — Tp CLOSED (spec-def) |
| SKIP-Ξ-op | Was: schedule ≠ operator | **RETIRE** — Ξ CLOSED |
| SKIP-OptObj | Was: undefined | **RETIRE** — J = residual |
| SKIP-L5-proof | L5 unfinished | **FLIP** → PASS when Hyp proved; else FAIL-open |
| SKIP-Goldilocks16 | Foundry prop **16** FAIL — do not claim PASS lift | **KEEP** |

---

## Core citation targets (cite-only)

`P64`, `pmat_compose`, `spectral_analyze`, `soft_project`, `q_estimate`, `synth_weights`, `rec_step`, `rec_run`, `ace_certify`.

HCALC Core verbs (implement in `/workspace/hcalc/j/`): `tp_from_p64`, `c_wrap`, `lam_m_from_bound`, `hcalc_xi_apply`, `hcalc_step`, `hcalc_run`.

Docs: `/workspace/foundry-j/spec/J_API.md`, `GAP_DECISIONS.md`, `PROPERTIES.md`, `/workspace/foundry-j/j/BOXING.md`, [`PRODUCTION.md`](PRODUCTION.md).
