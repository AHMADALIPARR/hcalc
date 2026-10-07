<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Interfaces — Alloy vs Lean

**Owner:** HCALC Spec agent  
**Definitions live in:** [`COHERENCE.md`](COHERENCE.md), [`AXIOMS.md`](AXIOMS.md), [`FOUNDRY_J_CROSSLINKS.md`](FOUNDRY_J_CROSSLINKS.md).  
**Spec does not write** `.als` or `.lean` files.

---

## Shared vocabulary (symbol table)

| Symbol | Meaning | Gap / ID |
|--------|---------|----------|
| \(X_t\) | State | Gap-Carrier |
| \(T_p\) | Prime-indexed transform | Gap-Tp-from-P64, A7, L6 |
| \(C\) | In-step contraction wrapper | Gap-C-wrapper, A7, L6 |
| \(\Lambda_m\) | Stabilizing **scalar** | Gap-Λm-scalar, A7, L6 |
| \(\Xi(t,\cdot)\) | HCALC evolution operator | Gap-Ξ, A7, L6 |
| Foundry step | \(x'=\Xi x+\Lambda T(x)+g\) | A4, L3 (≠ nested) |
| HCALC step | \(X_{t+1}=\Xi(t,\Lambda_m\cdot C[T_p(X_t)])\) | nested; Gap-ShapeMap |
| `P_64` | First-64 primes index set | A1, L1 |

Provenance on every Alloy assert / Lean axiom: `source-claim` | `axiom-gap` | `derived`.

---

## What HCALC Alloy must assert

- **A1–A6** when the model claims Foundry-backed surfaces (finite predicates / traces).  
- **A7** always for open symbols: definition-record presence; **no** invented formulas.  
- **Inv-StepForm … Inv-OpaqueGaps** (COHERENCE invariant inventory).  
- Forbidden: traces that mix Foundry additive **39** with HCALC nested symbols without a discharged **Gap-ShapeMap**.  
- Forbidden: PASS when guardian (**A6**) would reject.  
- May leave as **parameters:** ε tier, instance tag, carrier dimension, whether PMAT is enabled, OptObj.

Provenance tags should reference GapIds / A* / L* from COHERENCE/AXIOMS.

---

## What HCALC Lean may axiomize vs must prove

| May axiomize (uninterpreted / axiom) | Must define or prove |
|--------------------------------------|----------------------|
| L6: Λm, HCALC.Ξ, C, Tp | L1 P64 data as def |
| Gap-* until Spec closes | L2 gershgorin/contractiveG |
| L7 **only after** Spec defines HCALC LHS + ShapeMap | L3 FoundryStep def (≠ HCALC) |
| | L4 qEstimate/softProject defs |
| | L5 as theorem — or mark unfinished (no silent PASS) |

Zero `sorry` in non-gap leaves is Lean agent policy; gaps use **named** axioms keyed by L6 / Gap-*.

---

## Foundry J Core / Verify

- Cross-links: `FOUNDRY_J_CROSSLINKS.md`; Foundry mirror `/workspace/foundry-j/spec/HCALC_CROSSLINKS.md`.  
- Core hooks are **cite-only** — not HCALC implementations.  
- Verify outline: [`PROPERTIES.md`](PROPERTIES.md); harness stub [`../verify/README.md`](../verify/README.md).  
- **Gap-ShapeMap** must be named before Core can implement a bridge.

---

## Hand-off

| Agent | Owns | Does not own |
|-------|------|--------------|
| **Spec** | COHERENCE, AXIOMS, PROPERTIES outline, INTERFACES, FOUNDRY_J_CROSSLINKS retention | `.als`, `.lean`, J harness bodies |
| **Alloy** | `alloy/**/*.als`, Alloy README beyond stub | Changing GapId meanings |
| **Lean** | `lean/**/*.lean` | Inventing Λm/Ξ/C/Tp formulas |
| **Verify** | `verify/` harness per PROPERTIES | Closing ShapeMap without Spec |
