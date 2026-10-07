<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC — Mathematical Research Center

**Purpose.** This repository is the coherence research center for the HCALC abstract dynamics

\[
X_{t+1} = \Xi\bigl(t,\; \Lambda_m \cdot C[T_p(X_t)]\bigr).
\]

It records what is defined, what must be axiomatized, and what must remain open until Spec closes a GapId. The center combines a prose gap map (`spec/`), finite relational models (`alloy/`), and a Lean 4 library (`lean/`) so claims about the pipeline can be checked at three levels without inventing numeric constants, fake digests, or unconditional “stability” theorems.

**License.** GNU Affero General Public License **v3.0 only** — see [`LICENSE`](LICENSE). SPDX: `AGPL-3.0-only`. Do **not** relicense under MIT or other permissive terms.

**Owner (GitHub):** [AHMADALIPARR](https://github.com/AHMADALIPARR).

**Status (2026-10-07 PT):** Production definitions landed in [`spec/PRODUCTION.md`](spec/PRODUCTION.md) — all domain Gap-* **CLOSED** via `InstanceBridge` (NOT `rfl` / NOT Foundry39≡nested); dual `NestedFaithful`|`FoundryAdditive`; A7 → **SpecDefined**; Lean L6 → defs; L7 UNBLOCKED; L5 dischargeable under Hyp. Alloy must replace Undefined; Lean defs not axioms; Verify flip SKIP→PASS where hyps hold. Handoff: [`spec/HANDOFF_PRODUCTION.md`](spec/HANDOFF_PRODUCTION.md). **Not pushed** — waiting Alloy/Lean/Verify green.


---

## Research posture

HCALC is treated as a **research object**, not a product narrative. Marketing language (UAC branding, quantum/AI/cognitive slogans), ungrounded redirects, and stability claims without hypotheses are out of scope (`spec/COHERENCE.md` § Noise).

The boxed recurrence above is the **nested** form. Foundry J Core’s closest coded step (PROPERTIES **39**) is the **additive** Banach form

\[
x' = \Xi\, x + \Lambda\, T(x) + g
\]

(with soft-projection when a coded \(q\)-budget exceeds \(1-\varepsilon\)). Spec **does not identify** these two shapes. Gap-ShapeMap is **CLOSED** as explicit **`InstanceBridge`** (parameter table; NOT `rfl`) with dual `bridgeMode` **NestedFaithful**|**FoundryAdditive** — Lean **L7 UNBLOCKED**. Alloy must forbid silent equation / identity (`INV_step_shape`, **A4**).

---

## Pipeline

```
MULTIMODAL → MULTIPLICITY/TENSOR → PRIME-INDEXED RECURSION (T_p)
  → Λm STABILIZATION → Ξ(t) EVOLUTION → ORTHOGONAL/SPECTRAL
  → LAYERWISE CONTRACTION (C) → OPTIMIZATION → CONVERGED REP
```

| Stage | Role | Status |
|-------|------|--------|
| Multimodal → tensor | Carrier / multiplicity | **CLOSED** — `HCALC.Carrier` ℝ^n (optional Goldilocks later) |
| \(T_p\) | Prime-indexed transform | **CLOSED** — diag α (**spec-def**) from P64 |
| \(\Lambda_m\) | Stabilizing **scalar** | **CLOSED** — scalar min formula |
| \(\Xi(t,\cdot)\) | Controlled evolution operator | **CLOSED** — ξ_t·y+g_t (Uniform default) |
| Spectral / orthogonal | Analysis / classification | Foundry hooks measure; not in-step \(C\) |
| \(C[\cdot]\) | In-step contraction wrapper | **CLOSED** — scale-or-id (**spec-adapt** ≠ Foundry **43**) |
| Optimize | Objective \(\mathcal{J}\) | **CLOSED** — residual \(\ell_\infty\); iterate to tol |
| Converged rep | Fixed point / monitor | **CLOSED** — Hyp ⇒ Banach + residual→0; L5 dischargeable |

Abstract symbols \(X_t\), \(T_p\), \(C\), \(\Lambda_m\), \(\Xi\) are **defined** in [`spec/PRODUCTION.md`](spec/PRODUCTION.md). Alloy records must be **SpecDefined**; Lean uses **defs** (not opaque axioms) for L6; do not invent beyond PRODUCTION.

---

## Repository layout

```
hcalc/
  LICENSE                      AGPL-3.0-only (full text)
  README.md                    this file
  .gitignore
  spec/
    COHERENCE.md               gap map, invariants, open problems, Alloy↔Lean
    AXIOMS.md                  GapIds A1–A7, L1–L7, Gap-*, G-* aliases
    PROPERTIES.md              Verify outline (Foundry pattern)
    INTERFACES.md              Alloy vs Lean contracts
    PRODUCTION.md             production defs + Gap disposition (CLOSED)
    HANDOFF_PRODUCTION.md     copy-paste Alloy/Lean/Verify/Core
    FOUNDRY_J_CROSSLINKS.md    absorbed Spec input (preserve)
    FOUNDRY_J_PRODUCTION_REVIEW.md  Foundry J Spec review mirror
  alloy/
    HCALC.als                  top-level checks A1–A7 + INV_*
    modules/*.als              State, PrimeIndex, Transform, Recursion,
                               Stabilize, Contract, Evolve, Optimize, Converge
    tools/org.alloytools.alloy.dist.jar
    run.sh                     headless Alloy CLI runner
    logs/alloy-check.txt       last check log
    INVARIANTS.md              Alloy-local inventory (optional)
  lean/                        Lake project Hcalc (Lean 4 stable)
    Hcalc/{RealStub,Foundry,Axioms,Pipeline,Invariants,Convergence}.lean
  docs/
    INVARIANTS.md              Alloy asserts ↔ Lean theorem/axiom map
    REMAINING.md               open Lean research after L6
  j/                          HCALC production J verbs (Core path)
  verify/
    README.md                  stub → Foundry Verify gate proposal
```

Ownership convention: Spec owns GapId meanings; Alloy owns `.als`; Lean owns `.lean`; Verify owns harness stubs. Agents merge without clobbering richer formal content.

---

## GapId system (stable)

### Alloy asserts A1–A7

| ID | Informal claim | Provenance |
|----|----------------|------------|
| A1 | `#P_64 = 64` / distinct prime index slots | source-claim (prop **23**) |
| A2 | contractive ↔ Gershgorin \(< 1-\varepsilon\) (+ power-iter) | source-claim (**33–37**) |
| A3 | soft-project when \(q > 1-\varepsilon\) | source-claim (**43**) |
| A4 | Foundry additive step only if `instance = Foundry` | source-claim (**39**, gated) |
| A5 | PMAT conservation if PMAT used | source-claim (**29**) |
| A6 | guardian rejects \(\rho \ge 1\) or non-finite | source-claim (**55**) |
| A7 | definition-**record** present for Λm, Ξ, C, Tp — **SpecDefined** | SpecDefined (CLOSED) |

### Lean L1–L7

| ID | Kind | Note |
|----|------|------|
| L1 | def | `P64` / first-64 primes data |
| L2 | def (+ iff) | `gershgorinBound`, `contractiveG` |
| L3 | def | `FoundryStep` = prop **39**; ≠ nested |
| L4 | def / axioms | `qEstimate`, `softProject` control flow |
| L5 | theorem (dischargeable) | Banach unique FP under PRODUCTION Hyp |
| L6 | **defs** | Λm, Ξ, C, Tp — PRODUCTION §§2–5 |
| L7 | **UNBLOCKED** | `InstanceBridge` + dual bridgeMode — NOT `rfl` |

### Steering aliases

| Alias | Canonical GapId |
|-------|-----------------|
| **G-SHAPE** | Gap-ShapeMap |
| **G-Lm** | Gap-Λm-scalar |
| **G-C** | Gap-C-wrapper |
| **G-Tp** | Gap-Tp-from-P64 |

Full inventory: [`spec/AXIOMS.md`](spec/AXIOMS.md), [`spec/COHERENCE.md`](spec/COHERENCE.md).

---

## Alloy model

Finite signatures model `Time`, `State`, `PrimeLabel` / `P64Carrier`, `TensorSpace`, `TpMap`, `LambdaM` (lone scalar placeholder), contraction / spectral atoms, dual step predicates (`foundry_additive_step`, `hcalc_nested_step`), optimization objective gap, and convergence hypothesis gap.

Every underspecified piece is commented with Provenance `source-claim | axiom-gap | derived` and a GapId. Safety-style constraints include: evolution total on State; measure non-increase under Contract when axiomatized; primes used as indexes stay in P64 (or a stated extension); recursion bounded by finite `Time` / lone `next`.

**Run (headless):**

```bash
cd alloy
./run.sh          # writes logs/alloy-check.txt
# or:
java -jar tools/org.alloytools.alloy.dist.jar exec -f -o logs/alloy-out -t text HCALC.als
```

Requires Java 21+. The Alloy Analyzer JAR is vendored under `alloy/tools/` (AlloyTools 6.2). GUI mode needs a display; CLI `exec` / `commands` do not.

Invariant table mapping Alloy ↔ Lean: [`docs/INVARIANTS.md`](docs/INVARIANTS.md).

---

## Lean 4 library

Project `Hcalc` targets Lean 4 **v4.34.1** via elan. **No Mathlib** in the first cut (opaque `Real` stub). **Zero `sorry`.** Policy:

- Prefer **definitions** where Foundry is concrete (L1–L4).
- Replace L6 with **defs** from PRODUCTION.md (no opaque domain axioms).
- State convergence / stability **only** with hypotheses (L5 under Hyp).
- Introduce L7 as `structure InstanceBridge` + dual-mode theorems — **not** `FoundryStep = hcalcStep`.

```bash
export PATH="$HOME/.elan/bin:$PATH"
cd lean && lake build
```

What remains after axioms: [`docs/REMAINING.md`](docs/REMAINING.md).

---

## Verify stub

[`verify/README.md`](verify/README.md) points at the Foundry Verify gate proposal: PROPERTIES + PROPERTY_MAP + prop_N logs; `sorry` / Alloy failure / missing A7 record ⇒ **SKIP** or FAIL-open, never PASS. Full HCALC harness is not implemented in this stub.

---

## Related experimental witnesses (not theorems)

- **foundry-j** — Pure-J Core + Verify for Goldilocks, PMAT, spectral governor, Banach recurrence (`P64`, `pmat_compose`, `spectral_analyze`, `soft_project`, `q_estimate`, `synth_weights`, `rec_step`, `rec_run`, `ace_certify`). Cite `spec/J_API.md`, `j/BOXING.md`, `spec/GAP_DECISIONS.md`. Instantiation **hooks**, not definitions of HCALC \(\Lambda_m\)/\(\Xi\)/\(C\)/\(T_p\).
- **sedona-k** — P64 Riemann-gas thermo / experimental spine. Selective architectural context only; not a math definition of \(T_p\).

Primary Spec note: [`spec/FOUNDRY_J_CROSSLINKS.md`](spec/FOUNDRY_J_CROSSLINKS.md) (preserve). Foundry-side mirror: `foundry-j/spec/HCALC_CROSSLINKS.md` when present.

---

## Open problems

Domain Gap-* are **CLOSED** in [`spec/PRODUCTION.md`](spec/PRODUCTION.md). Remaining optional / infra only:

1. Optional Goldilocks \(\mathbb{F}_p\) carrier instance (Foundry **1–17**).  
2. Mathlib migration replacing RealStub / Gap-Foundry-* infra stubs.  
3. Empirical ε tier tuning beyond default T2=0.05.  
4. Optional Option C embedding morphism theorem (still not identity).

---

## Contributing

1. Follow [`spec/PRODUCTION.md`](spec/PRODUCTION.md) + [`spec/HANDOFF_PRODUCTION.md`](spec/HANDOFF_PRODUCTION.md).  
2. Alloy: A1–A7 SpecDefined; dual bridgeMode; never equate NestedFaithful with prop-**39**.  
3. Lean: L1–L6 defs; L7 InstanceBridge; L5 under Hyp; no `sorry`.  
4. Verify: flip SKIP→PASS where hyps hold; H-SHAPE never identity PASS.  
5. License contributions under **AGPL-3.0-only**.

This README is architecture documentation for the research center. Production formulas are in Spec; Alloy/Lean/Verify/Core must implement without inventing beyond the mandate.
