<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Interfaces — Alloy vs Lean

**Owner:** HCALC Spec agent  
**Definitions live in:** [`PRODUCTION.md`](PRODUCTION.md), [`COHERENCE.md`](COHERENCE.md), [`AXIOMS.md`](AXIOMS.md), [`FOUNDRY_J_CROSSLINKS.md`](FOUNDRY_J_CROSSLINKS.md).  
**Status:** Production definitions landed; Alloy must replace A7 Undefined→SpecDefined; Lean defs not axioms; Verify flip SKIP→PASS where hyps hold.  
**Spec does not write** `.als` or `.lean` bodies (see [`HANDOFF_PRODUCTION.md`](HANDOFF_PRODUCTION.md)).

---

## Shared vocabulary (symbol table)

| Symbol | Meaning | Gap / ID | Status |
|--------|---------|----------|--------|
| \(X_t\) | State | Gap-Carrier | **CLOSED** — `HCALC.Carrier` |
| \(T_p\) | Diagonal prime-indexed transform | Gap-Tp-from-P64, A7, L6 | **CLOSED** (**spec-def** α) |
| \(C\) | In-step scale-or-id | Gap-C-wrapper, A7, L6 | **CLOSED** (**spec-adapt** ≠ **43**) |
| \(\Lambda_m\) | Stabilizing **scalar** | Gap-Λm-scalar, A7, L6 | **CLOSED** |
| \(\Xi(t,\cdot)\) | HCALC evolution operator | Gap-Ξ, A7, L6 | **CLOSED** |
| Foundry step | \(x'=\Xi x+\Lambda T(x)+g\) | A4, L3 | FoundryAdditive diagnostic |
| HCALC step | \(X_{t+1}=\Xi(t,\Lambda_m\cdot C(T_p(X_t)))\) | NestedFaithful | production Core verb |
| InstanceBridge | Param table \(T:=C\circ T_p\), \(\Lambda:=\Lambda_m\mathbf{1}\), \(\Xi:=\xi_t\) | Gap-ShapeMap, L7 | **CLOSED** — NOT `rfl` |
| `P_64` | First-64 primes index set | A1, L1 | source-claim **23** |

Provenance on every Alloy assert / Lean axiom: `source-claim` | `axiom-gap` | `derived` | `SpecDefined` | `spec-def` | `spec-adapt`.

---

## What HCALC Alloy must assert

- **A1–A6** when the model claims Foundry-backed surfaces (finite predicates / traces).  
- **A7** with **SpecDefined** records pointing at PRODUCTION.md (replace prior `Undefined`).  
- **Inv-StepForm … Inv-OpaqueGaps** (COHERENCE invariant inventory).  
- Dual `bridgeMode ∈ {NestedFaithful, FoundryAdditive}` + InstanceBridge table; **forbid** NestedFaithful = prop-**39** / `rfl`.  
- Forbidden: PASS when guardian (**A6**) would reject.  
- May leave as **parameters:** ε tier, instance tag, carrier dimension, whether PMAT is enabled.  
- OptObj = Spec \(\ell_\infty\) residual; ContractAlg = Gershgorin→power-iter→scale-or-id.

Provenance tags should reference GapIds / A* / L* from COHERENCE/AXIOMS/PRODUCTION.

---

## What HCALC Lean may axiomize vs must prove

| May keep as infra axiom (toolchain only) | Must define or prove |
|------------------------------------------|----------------------|
| Gap-Real-arith / Gap-Foundry-* stubs | L1 P64 data as def |
| | L2 gershgorin/contractiveG |
| | L3 FoundryStep def (**≠** hcalcStep) |
| | L4 qEstimate/softProject (Foundry) |
| | L5 theorem under Hyp (0 sorry) |
| | L6: Λm, Ξ, C, Tp as **defs** (replace axioms) |
| | L7: `structure InstanceBridge` + dual-mode thms — **NOT** `rfl` / **NOT** `FoundryStep = hcalcStep` |

Zero `sorry` in production leaves. Domain gaps are CLOSED — no new L6 axioms.

---

## Foundry J Core / Verify

- Cross-links: `FOUNDRY_J_CROSSLINKS.md`; Foundry mirror `/workspace/foundry-j/spec/HCALC_CROSSLINKS.md`.  
- Core implement path (authoritative): **`/workspace/hcalc/j/`** — verbs `tp_from_p64`, `c_wrap`, `lam_m_from_bound`, `hcalc_xi_apply`, `hcalc_step`, `hcalc_run`.  
- Core hooks are **cite-only** — do not equate `hcalc_step` with `rec_step`.  
- Verify outline: [`PROPERTIES.md`](PROPERTIES.md); harness [`../verify/README.md`](../verify/README.md).  
- H-SHAPE PASS only for InstanceBridge witness, never identity.

---

## Hand-off

| Agent | Owns | Does not own |
|-------|------|--------------|
| **Spec** | PRODUCTION, COHERENCE, AXIOMS, PROPERTIES outline, INTERFACES, crosslinks | `.als`, `.lean`, J verb bodies |
| **Alloy** | `alloy/**/*.als`, Alloy README beyond stub | Changing GapId meanings / inventing `rfl` bridge |
| **Lean** | `lean/**/*.lean` | Re-axiomatizing CLOSED L6; `FoundryStep = hcalcStep` |
| **Verify** | `verify/` harness per PROPERTIES | Closing ShapeMap without Spec |
| **Core** | `/workspace/hcalc/j/` production verbs | Equating FoundryAdditive with NestedFaithful |
