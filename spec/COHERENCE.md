<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Coherence Map

**Owner:** HCALC Spec agent  
**License:** AGPL-3.0-only  
**Absorbs:** [`FOUNDRY_J_CROSSLINKS.md`](FOUNDRY_J_CROSSLINKS.md) (verbatim source input; keep that file).  
**Mirror:** `/workspace/foundry-j/spec/HCALC_CROSSLINKS.md` (same content at Foundry side).  
**Cite-only (do not copy bodies):**  
`/workspace/foundry-j/spec/PROPERTIES.md`, `J_API.md`, `GAP_DECISIONS.md`, `/workspace/foundry-j/j/BOXING.md`.

---

## Pipeline (canonical)

Informal multimodal research narrative (noise stripped) collapses to the discrete dynamical pipeline:

```
multimodal system
  → multiplicity / tensor representation
  → prime-indexed recursion T_p
  → Λm stabilization
  → Ξ(t) controlled evolution
  → orthogonal / spectral transform
  → layerwise contraction C
  → optimization
  → converged representation
```

**Boxed abstract recurrence (HCALC nested form):**

\[
X_{t+1} = \Xi\bigl(t,\; \Lambda_m \cdot C[T_p(X_t)]\bigr)
\]

| Symbol | Role | Status |
|--------|------|--------|
| \(X_t\) | State at discrete time \(t\) | Carrier open — **Gap-Carrier** |
| \(T_p\) | Prime-indexed transform / recursion | Undefined — **Gap-Tp-from-P64**, **A7/L6** |
| \(C\) | Contraction (in-step wrapper) | Undefined — **Gap-C-wrapper**, **A7/L6** |
| \(\Lambda_m\) | Stabilizing **scalar** | Undefined — **Gap-Λm-scalar**, **A7/L6** |
| \(\Xi(t,\cdot)\) | Controlled evolution operator | Undefined — **Gap-Ξ**, **A7/L6** |

**Critical shape fact.** Foundry F1 closest coded step (PROPERTIES **39**) is **additive** Banach:

\[
x' = \Xi\cdot x + \Lambda\cdot T(x) + g
\quad\text{(with soft_project when } q > 1-\varepsilon\text{)}
\]

HCALC boxed form is **nested**. Spec **does not equate** them. Bridge only via **Gap-ShapeMap** / **L7** after HCALC LHS is defined here (currently blocked).

---

## Gap map

### Defined (working definitions we adopt)

Provisional working vocabulary — minimal, not invented formulas:

| Symbol | Working definition | Provisional? |
|--------|-------------------|--------------|
| \(X_t\) | Element of a declared carrier \(\mathcal{X}\) (real/complex Banach, finite-dim, or Goldilocks \(\mathbb{F}_p\) lift — must be named per instance) | Yes — **Gap-Carrier** |
| \(T_p\) | Map \(\mathcal{X}\to\mathcal{X}\) (or to a tensor space) indexed by a prime index set; Foundry candidate index set is `P_64` (prop **23**) | Yes — not equal to Foundry \(T(x)\) |
| \(C\) | Non-expansive / Lipschitz map intended as in-step contraction wrapper \(C[\cdot]\) | Yes — Foundry has post-hoc spectral tests, not in-step \(C\) |
| \(\Lambda_m\) | Scalar such that \(\|\Lambda_m\cdot C\circ T_p\| < 1-\varepsilon\) is a candidate stability target | Yes — Foundry `lambda_schedule` is a **vector**, not this scalar |
| \(\Xi(t,\cdot)\) | Time-indexed evolution operator on the contracted/stabilized image | Yes — ≠ Foundry \(\Xi_t\) schedule weights |
| Spectral / orthogonal step | Optional analysis layer; Foundry hooks: Gershgorin, power iteration, guardian (props **33–38**, **55**) | Measure, not full HCALC transform |
| Optimization interface | Uninterpreted objective \(\mathcal{J}\) over traces / fixed points until Spec defines it | Yes — **Gap-OptObj** |

### Axiom-needed (cannot be derived from source)

Canonical IDs for Alloy Provenance tags / Lean axioms. Provenance values: `source-claim` | `axiom-gap` | `derived`.

#### Named gaps (HCALC-native)

| GapId | Statement | Provenance | Cross-ref |
|-------|-----------|------------|-----------|
| **Gap-ShapeMap** | Explicit map/bridge between nested HCALC step and additive Foundry **39**; **not** identity | `axiom-gap` | **L7** (blocked), **A4** |
| **Gap-Λm-scalar** | \(\Lambda_m\in\mathbb{R}\) (or declared field) with \(\|\Lambda_m\cdot C\circ T_p\|<1-\varepsilon\); Foundry `lambda_schedule` is vector — no verb outputs \(\Lambda_m\) | `axiom-gap` | **A7**, **L6** |
| **Gap-C-wrapper** | In-step \(C[\cdot]\); Foundry `spectral_analyze` / `gershgorin_*` / `power_iteration*` / `soft_project` / `q_estimate` / `ace_*` are **not** in-step \(C\) | `axiom-gap` | **A7**, **L6** |
| **Gap-Tp-from-P64** | Construction of \(T_p\) from `P_64` / PrimeMask / ResonanceWord / PMAT / `T_hook`; candidates ≠ definition | `axiom-gap` | **A1**, **A7**, **L1**, **L6** |
| **Gap-Ξ** | Formal \(\Xi(t,\cdot)\) as operator; Foundry `synth_weights`→`xi_schedule` are schedule vectors | `axiom-gap` | **A7**, **L6** |
| **Gap-Carrier** | Explicit tensor / Banach / \(\mathbb{F}_p\) carrier for \(X_t\) | `axiom-gap` | multimodal→tensor stage |
| **Gap-Converge** | Convergence hypotheses (Banach unique FP, residual tolerance, monitor) for nested form | `axiom-gap` | **L5** (Foundry-side), residual **46** |
| **Gap-ContractAlg** | Algorithm realizing \(C\) (not merely a contractive flag) | `axiom-gap` | **A2**, **Gap-C-wrapper** |
| **Gap-OptObj** | Optimization objective \(\mathcal{J}\) | `axiom-gap` | pipeline tail |

#### Alloy asserts A1–A7 (from FOUNDRY_J_CROSSLINKS)

| ID | Assert (informal) | Foundry anchor | Provenance |
|----|-------------------|----------------|------------|
| **A1** | `#P_64 = 64` and elements are the listed first-64 primes | Prop **23** | `source-claim` |
| **A2** | `contractive(J,ε) iff gershgorin(J) < 1-ε` (+ optional power-iter **37**) | **33–37** | `source-claim` |
| **A3** | Soft-project: if `q > 1-ε` then scaled weights used in the step | **43** | `source-claim` |
| **A4** | Recurrence carrier = Foundry affine form **only if** `instance=Foundry` | **39** | `source-claim` (instance-gated) |
| **A5** | PMAT conservation on insert-set | **29** | `source-claim` |
| **A6** | Guardian: reject when spectral radius ≥ 1 or non-finite | **55** | `source-claim` |
| **A7** | Gap stub: `Λm`, HCALC-`Ξ`, `C`, `T_p` unconstrained until defined — assert **presence of a definition record**, not a formula | (no Foundry cite) | `axiom-gap` |

#### Lean L1–L7 (from FOUNDRY_J_CROSSLINKS)

| ID | Candidate | Kind | Note |
|----|-----------|------|------|
| **L1** | `P64 : Fin 64 → ℕ` (PROPERTIES **23** list) | definition (data) | No axiom if listed |
| **L2** | `gershgorinBound`, `contractiveG` | def + theorem | From **33–34** |
| **L3** | `FoundryStep Ξ Λ T g x` | definition | Exact **39**; **≠** HCALC nested |
| **L4** | `qEstimate` / `softProject` | definition | **42–43** as coded |
| **L5** | Banach unique FP under `q < 1-ε` | theorem (or unfinished) | Narrative **41** |
| **L6** | `Λm`, `HCALC.Ξ`, `C`, `Tp` | axioms / uninterpreted | **Gaps — do not invent** |
| **L7** | Bridge `HCALCStep = FoundryStep` (or embedding) | axiom/theorem **BLOCKED** | Only after Spec defines HCALC LHS; **Gap-ShapeMap** stands |

### Noise (explicitly out of scope)

- UAC branding and product wrappers  
- Quantum / AI / cognitive marketing language  
- Ungrounded or Google-redirect citations  
- “Stability without hypotheses” claims  
- Equating Sedona Spine / PIRTM linker theater (**21**) with mathematical \(T_p\)  
- Silently identifying Foundry additive **39** with HCALC nested form  

---

## Foundry instantiation map (cite-only)

Absorbed from `FOUNDRY_J_CROSSLINKS.md` §1.

### \(T_p\) candidates (not definitions)

| Foundry surface | Role vs \(T_p\) | Cite |
|-----------------|----------------|------|
| **23** `P_64` | Discrete prime index set | `types.h`; PROPERTIES 23 |
| `PrimeMask` / `ResonanceWord` | Representation over `P_64`, not recursive tensor law | J_API.md |
| **26–32** PMAT | Sparse prime-monomial LA; skeleton only | PROPERTIES E; GAP_DECISIONS |
| **1–17** Goldilocks \(\mathbb{F}_p\) | Carrier for discrete lifts; not real contraction of \(X_t\) | PROPERTIES A–C |
| **21** PIRTM_MAGIC / linker | Tooling ≠ math \(T_p\) | PROPERTIES 21 |

Core cite-only hooks: `P64`, `pmat_compose`, `spectral_analyze`, `soft_project`, `q_estimate`, `synth_weights`, `rec_step`, `rec_run`, `ace_certify`.

### Contraction / spectral measures

| Props | Measure |
|-------|---------|
| **33–34** | Gershgorin; `contractive ⟺ bound < 1-ε` |
| **35–37** | Power iteration + fallback |
| **38** | Contractive / expansive test matrices |
| **25** | Tier ε schedule |
| **39–46** | Banach recurrence, \(q_t\), soft project, residual |
| **55** | Guardian spectral legality |

---

## Invariant inventory (for Alloy)

Eight coherence obligations (from crosslinks §2). Alloy encodes finite predicates / traces; open math remains in GapIds.

| # | Name | Informal statement | Alloy must check | Remains open |
|---|------|--------------------|------------------|--------------|
| 1 | **Inv-StepForm** | Step-form declared: Foundry39 ≠ HCALC nested unless bridge | Trace tag `instance ∈ {Foundry, HCALC, Bridged}`; forbid mixed symbols without **Gap-ShapeMap** discharge | **Gap-ShapeMap**, **L7** |
| 2 | **Inv-P64** | If Foundry-backed prime-index, indices from `P_64` | **A1** | Extension beyond 64 primes |
| 3 | **Inv-Contractive** | Modulus bound \(< 1-\varepsilon\) for declared ε | **A2**; ε from tier **25** or declared | Nested-form Lip constant |
| 4 | **Inv-QSoft** | If schedules used: soft-project when \(q>1-\varepsilon\) | **A3** | Relation to \(\Lambda_m\) scalar |
| 5 | **Inv-Residual** | Residual / convergence witness discharged when claimed | Monitor predicate; link **L5**/prop **46** | **Gap-Converge** for nested form |
| 6 | **Inv-PMAT** | If PMAT used: conservation | **A5** | — |
| 7 | **Inv-GapDecisions** | Honor `/workspace/foundry-j/spec/GAP_DECISIONS.md` until Spec overrides in writing | Parameter/fixture consistency | HCALC overrides |
| 8 | **Inv-OpaqueGaps** | \(\Lambda_m\), \(\Xi\), \(C\), \(T_p\) opaque until defined | **A7** definition-record presence | **L6**, named Gap-* |

Additional Alloy-oriented: **A4** (Foundry carrier only if instance=Foundry), **A6** (guardian).

---

## Axiom candidates (for Lean)

See [`AXIOMS.md`](AXIOMS.md) for full keyed inventory. Summary:

- **L1–L4**: prefer **definitions** from Foundry concrete data.  
- **L5**: theorem or unfinished — do not silent-`sorry` as PASS.  
- **L6**: axioms for \(\Lambda_m\), `HCALC.Ξ`, `C`, `Tp` — irreducible; no invented formulas.  
- **L7**: **blocked** until **Gap-ShapeMap** / HCALC LHS defined in Spec.  
- Named **Gap-*** each induce at most one Lean axiom / uninterpreted constant until Spec closes them.

---

## Open problems

1. Explicit scalar \(\Lambda_m\) and stabilizing range (**Gap-Λm-scalar**).  
2. Formal operator \(\Xi(t,\cdot)\) (**Gap-Ξ**).  
3. Tensor / carrier spaces for \(X_t\) (**Gap-Carrier**).  
4. Convergence criteria for the **nested** recurrence (**Gap-Converge**).  
5. In-step contraction algorithm \(C\) (**Gap-C-wrapper**, **Gap-ContractAlg**).  
6. Optimization objective (**Gap-OptObj**).  
7. Shape map nested HCALC ↔ additive Foundry39 (**Gap-ShapeMap** / **L7**).  
8. Law giving \(T_p\) from `P_64` / PMAT / hooks (**Gap-Tp-from-P64**).

---

## Cross-links

- **Foundry J / PIRTM (conceptual):** prime index set, Gershgorin contraction tests, Banach step, PMAT — **candidate instantiation**, not definitions of HCALC \(\Lambda_m\)/\(\Xi\)/\(C\)/\(T_p\). Primary note: [`FOUNDRY_J_CROSSLINKS.md`](FOUNDRY_J_CROSSLINKS.md). Foundry mirror: `/workspace/foundry-j/spec/HCALC_CROSSLINKS.md`.  
- **Alapeno:** hardware stack; no Spec dependency for coherence math. Interface notes only if a future carrier is hardware-backed.  
- **Verify pattern:** [`PROPERTIES.md`](PROPERTIES.md), [`../verify/README.md`](../verify/README.md).
