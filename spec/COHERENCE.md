<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Coherence Map

**Owner:** HCALC Spec agent  
**License:** AGPL-3.0-only  
**Absorbs:** [`FOUNDRY_J_CROSSLINKS.md`](FOUNDRY_J_CROSSLINKS.md) (verbatim source input; keep that file).  
**Production authority:** [`PRODUCTION.md`](PRODUCTION.md) — all domain Gap-* CLOSED by definition.  
**Pass-2 review mirror:** [`FOUNDRY_J_PRODUCTION_REVIEW.md`](FOUNDRY_J_PRODUCTION_REVIEW.md).  
**Mirror:** `/workspace/foundry-j/spec/HCALC_CROSSLINKS.md` (Foundry side).  
**Cite-only (do not copy bodies):**  
`/workspace/foundry-j/spec/PROPERTIES.md`, `J_API.md`, `GAP_DECISIONS.md`, `/workspace/foundry-j/j/BOXING.md`.

---

## Pipeline (canonical — production formulas)

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

**Boxed abstract recurrence (HCALC nested form) — PRODUCTION:**

\[
X_{t+1} = \Xi\bigl(t,\; \Lambda_m \cdot C(T_p(X_t))\bigr)
  = \xi_t\cdot\bigl(\Lambda_m\cdot C(T_p(X_t))\bigr) + g_t.
\]

| Symbol | Role | Status |
|--------|------|--------|
| \(X_t\) | State at discrete time \(t\) | **Defined** — `HCALC.Carrier = Fin n → ℝ`, ℓ∞ |
| \(T_p\) | Diagonal PrimeMask transform | **Defined** — \((T_p x)_j = \alpha_j x_j\), \(\alpha_j=1/(1+\log p_{j\bmod 64})\) (**spec-def**) |
| \(C\) | In-step scale-or-id governor | **Defined** — scale \((1-\varepsilon)/q\) or id (**spec-adapt**; ≠ Foundry **43**) |
| \(\Lambda_m\) | Stabilizing **scalar** | **Defined** — \(\min(1,(1-\varepsilon)/(\|C\circ T_p\|_{\mathrm{op}}+\delta))\) |
| \(\Xi(t,\cdot)\) | Controlled evolution | **Defined** — \(\xi_t\cdot y + g_t\); Uniform \(\xi_t=1\) |

**Shape fact (production).** Foundry F1 additive step (PROPERTIES **39**) and HCALC nested form are **different morphisms**. Spec closes Gap-ShapeMap via **`InstanceBridge`** parameter table (PRODUCTION §6) with dual `bridgeMode`:

| bridgeMode | Meaning | vs Foundry **39** |
|------------|---------|-------------------|
| **FoundryAdditive** | `toFoundryStep` with InstanceBridge params | **ACCEPT** morphism into additive shape — **not** nested |
| **NestedFaithful** / `hcalcStep` | nested production verb | Spec definitional — **REJECT** as prop-**39** `rfl` / identity |

- **REJECTED:** `Foundry39 ≡ nested`; silent symbol swaps; identity/`rfl`.  
- **InstanceBridge** = explicit parameter table (morphism data), **not** an equality proof. Hilbert morphism maps to **FoundryAdditive** shape only.  
- **Core:** implement only `hcalc_step` (NestedFaithful semantics); `toFoundryStep` is FoundryAdditive diagnostic.  
- **L7 UNBLOCKED** as `structure InstanceBridge` + dual-mode theorems — **never** `FoundryStep = hcalcStep`.

### Provenance (pass-2 — do not revert)

- **Gap-Tp-from-P64** \(\alpha\) law: `spec-def` (P64 list alone is Foundry **source-claim** **23**).  
- **Gap-C-wrapper**: `spec-adapt` — algorithmic cousin of Foundry soft_project **43**, **not** symbol identity (43 scales schedules; production C scales **state** under Spec \(q=\|D(T_p)\|\)).  
- **Gap-ShapeMap / L7**: dual NestedFaithful | FoundryAdditive; InstanceBridge param table; morphism → FoundryAdditive only — never NestedFaithful = prop-**39** rfl.  
- Residual \(J\): Spec \(\ell_\infty\); Foundry **46** is \(\ell_2\).

---

## Gap map

### Defined (production — CLOSED)

| Symbol | Production definition | GapId |
|--------|----------------------|-------|
| \(X_t\) | `HCALC.Carrier := Fin n → ℝ`, \(\|·\|_\infty\) | Gap-Carrier **CLOSED** |
| \(T_p\) | \(\mathrm{diag}(\alpha)\), \(\alpha_j = 1/(1+\log p_{j\bmod 64})\) from L1/`P64` (**23**); α law **spec-def** | Gap-Tp-from-P64 **CLOSED** |
| \(C\) | scale-or-id on Spec \(q=\|D(T_p)\|_{\mathrm{est}}\) (**spec-adapt**; cousin of **43**, ≠ **43**) | Gap-C-wrapper **CLOSED** |
| \(\Lambda_m\) | scalar \(\min(1,(1-\varepsilon)/(\|C\circ T_p\|_{\mathrm{op}}+\delta))\) | Gap-Λm-scalar **CLOSED** |
| \(\Xi(t,\cdot)\) | \(\xi_t\cdot y + g_t\); default Uniform | Gap-Ξ **CLOSED** |
| ContractAlg | Gershgorin → power-iter fallback → soft_project scale idea | Gap-ContractAlg **CLOSED** |
| Convergence | Hyp ⇒ Banach unique FP (**41**) + residual→0 | Gap-Converge **CLOSED**; L5 dischargeable |
| \(J\) | residual \(\|X - \Xi(t,\Lambda_m\cdot C(T_p(X)))\|_\infty\); iterate to tol (≠ Foundry **46** \(\ell_2\)) | Gap-OptObj **CLOSED** |
| ShapeMap / L7 | **`InstanceBridge`** + dual NestedFaithful\|FoundryAdditive (NOT `rfl`) | Gap-ShapeMap **CLOSED**; L7 **UNBLOCKED** |
| Spectral / orthogonal | Gershgorin, power iter, guardian (**33–38**, **55**) | measure + ContractAlg input |
| Parameters | \(n\), ε tier (**25**, default T2=0.05), δ=1e-12, tol=1e-6 | PRODUCTION § Parameters |

Full formulas: [`PRODUCTION.md`](PRODUCTION.md). Inventory: [`AXIOMS.md`](AXIOMS.md).

### Axiom-needed

**None for domain Gap-*.** All closed in PRODUCTION.md.

Infrastructure toolchain stubs (accepted, not domain, not production blockers): **Gap-Real-arith**, **Gap-Foundry-StateOps**, **Gap-Foundry-FinMax**, **Gap-Foundry-Norm**, **Gap-Foundry-Div**, **Gap-Foundry-SoftScale** — see [`AXIOMS.md`](AXIOMS.md) § Infrastructure. Status = infra stub (Mathlib deferred).

### Steering aliases

| Alias | Canonical | Status |
|-------|-----------|--------|
| G-SHAPE | Gap-ShapeMap | **CLOSED** — `InstanceBridge` (NOT `rfl`); dual bridgeMode |
| G-Lm | Gap-Λm-scalar | **CLOSED** — scalar formula |
| G-C | Gap-C-wrapper | **CLOSED** — `spec-adapt` scale-or-id (≠ **43**) |
| G-Tp | Gap-Tp-from-P64 | **CLOSED** — diagonal α (**spec-def**) from P64 |

#### Alloy asserts A1–A7

| ID | Assert (informal) | Foundry / PRODUCTION anchor | Provenance |
|----|-------------------|----------------------------|------------|
| **A1** | `#P_64 = 64` and elements are the listed first-64 primes | Prop **23** | `source-claim` |
| **A2** | `contractive(J,ε) iff gershgorin(J) < 1-ε` (+ optional power-iter **37**) | **33–37** | `source-claim` |
| **A3** | Soft-project scale idea when `q > 1-ε` (**in-step C**, spec-adapt) | cousin of **43**; PRODUCTION §3 | `source-claim` + spec-adapt |
| **A4** | Recurrence carrier = Foundry affine form **only if** FoundryAdditive / `instance=Foundry` | **39** | `source-claim` (instance-gated) |
| **A5** | PMAT conservation on insert-set | **29** | `source-claim` |
| **A6** | Guardian: reject when spectral radius ≥ 1 or non-finite | **55** | `source-claim` |
| **A7** | Definition-records for Λm, Ξ, C, Tp are **SpecDefined** pointing at PRODUCTION.md | PRODUCTION.md | **SpecDefined** |

#### Lean L1–L7

| ID | Candidate | Kind | Note |
|----|-----------|------|------|
| **L1** | `P64 : Fin 64 → ℕ` (PROPERTIES **23** list) | definition (data) | No axiom if listed |
| **L2** | `gershgorinBound`, `contractiveG` | def + theorem | From **33–34** |
| **L3** | `FoundryStep Ξ Λ T g x` | definition | Exact **39**; ≠ `hcalcStep` |
| **L4** | `qEstimate` / `softProject` | definition | **42–43** as coded (Foundry); production C separate |
| **L5** | Banach unique FP under Hyp | **theorem** (dischargeable) | Narrative **41** + PRODUCTION Hyp |
| **L6** | `Λm`, `HCALC.Ξ`, `C`, `Tp` | **definitions** | PRODUCTION §§2–5 — not axioms |
| **L7** | `structure InstanceBridge` + dual-mode thms | **UNBLOCKED** | **NOT** `rfl`; **NOT** `FoundryStep = hcalcStep` |

### Noise (explicitly out of scope)

- UAC branding and product wrappers  
- Quantum / AI / cognitive marketing language  
- Ungrounded or Google-redirect citations  
- “Stability without hypotheses” claims  
- Equating Sedona Spine / PIRTM linker theater (**21**) with mathematical \(T_p\)  
- Silently identifying Foundry **39** with nested / claiming `rfl` ShapeMap  
- Tagging production `C` as Foundry **43** `source-claim` (it is **spec-adapt**)  
- Equating Spec \(\ell_\infty\) residual with Foundry **46** \(\ell_2\)

---

## Foundry instantiation map (cite-only)

Absorbed from `FOUNDRY_J_CROSSLINKS.md` §1. Production **uses** P64 + spectral + soft_project *scale idea* as coded hooks under PRODUCTION.md — Spec wiring / adapt, not Foundry-native identity of HCALC symbols.

### \(T_p\) (production uses P64 diagonal)

| Foundry surface | Role vs \(T_p\) | Cite |
|-----------------|----------------|------|
| **23** `P_64` | Prime table for \(\alpha_j\) (**source-claim**) | `types.h`; PROPERTIES 23; Lean L1 |
| α weight law | **spec-def** (not Foundry PROPERTY) | PRODUCTION §2 |
| `PrimeMask` / `ResonanceWord` | Representation over `P_64` — α schedule view | J_API.md |
| **26–32** PMAT | Sparse prime-monomial LA; **not** production Tp | PROPERTIES E |
| **1–17** Goldilocks \(\mathbb{F}_p\) | Optional future carrier | PROPERTIES A–C |
| **21** PIRTM_MAGIC / linker | Tooling ≠ math \(T_p\) | PROPERTIES 21 |

Core cite-only hooks: `P64`, `pmat_compose`, `spectral_analyze`, `soft_project`, `q_estimate`, `synth_weights`, `rec_step`, `rec_run`, `ace_certify`.

### Contraction / spectral measures

| Props | Measure |
|-------|---------|
| **33–34** | Gershgorin; `contractive ⟺ bound < 1-ε` |
| **35–37** | Power iteration + fallback |
| **38** | Contractive / expansive test matrices |
| **25** | Tier ε schedule (default T2=0.05) |
| **39–46** | Banach recurrence, \(q_t\), soft project, residual (\(\ell_2\)) |
| **55** | Guardian spectral legality |

---

## Invariant inventory (for Alloy)

Eight coherence obligations. Alloy encodes finite predicates / traces; production defs discharge former opaque gaps.

| # | Name | Informal statement | Alloy must check | Status |
|---|------|--------------------|------------------|--------|
| 1 | **Inv-StepForm** | Dual bridgeMode; forbid NestedFaithful = prop-**39** | Tag `bridgeMode ∈ {NestedFaithful, FoundryAdditive}` + InstanceBridge table; **forbid** symbol identity / `rfl` | **Defined** — L7 InstanceBridge |
| 2 | **Inv-P64** | If Foundry-backed prime-index, indices from `P_64` | **A1** | source-claim |
| 3 | **Inv-Contractive** | Modulus bound \(< 1-\varepsilon\) for declared ε | **A2**; ε from tier **25** | source-claim + production C |
| 4 | **Inv-QSoft** | Scale-or-id when Spec \(q>1-\varepsilon\) (in-step C) | **A3** (spec-adapt) | production C |
| 5 | **Inv-Residual** | Residual / convergence witness when claimed | Monitor; L5 under Hyp; Spec \(\ell_\infty\) | production Converge |
| 6 | **Inv-PMAT** | If PMAT used: conservation | **A5** | source-claim |
| 7 | **Inv-GapDecisions** | Honor Foundry `GAP_DECISIONS.md` until Spec overrides | Parameter/fixture consistency | PRODUCTION overrides written |
| 8 | **Inv-OpaqueGaps** | Λm, Ξ, C, Tp **SpecDefined** records | **A7** SpecDefined | **CLOSED** |

Additional: **A4** (Foundry carrier only if FoundryAdditive), **A6** (guardian).

---

## Axiom candidates (for Lean)

See [`AXIOMS.md`](AXIOMS.md) and [`PRODUCTION.md`](PRODUCTION.md). Summary:

- **L1–L4**: definitions from Foundry concrete data.  
- **L5**: theorem under Hyp — dischargeable; no silent-`sorry` as PASS.  
- **L6**: **defs** for Λm, Ξ, C, Tp (replace prior axioms).  
- **L7**: **UNBLOCKED** as `structure InstanceBridge` + dual NestedFaithful|FoundryAdditive theorems — **not** `FoundryStep = hcalcStep` / **not** `rfl`.  
- Named **Gap-*** domain: CLOSED — no new axioms.

---

## Open problems

Domain Gap-* closed. Remaining optional / infra only:

1. Optional Goldilocks \(\mathbb{F}_p\) carrier instance (Foundry **1–17**) — not required for ℝ path.  
2. Mathlib migration replacing RealStub / Gap-Foundry-* infra stubs.  
3. Empirical ε tier tuning beyond default T2=0.05.  
4. Optional Option C embedding morphism theorem (still not identity).

---

## Cross-links

- **Foundry J / PIRTM:** prime index set, Gershgorin, Banach step, soft_project — production **hooks** under PRODUCTION.md formulas. Primary note: [`FOUNDRY_J_CROSSLINKS.md`](FOUNDRY_J_CROSSLINKS.md). Foundry mirror: `/workspace/foundry-j/spec/HCALC_CROSSLINKS.md`.  
- **Core path:** `/workspace/hcalc/j/` (authoritative for HCALC verbs).  
- **Alapeno:** hardware stack; no Spec dependency for coherence math.  
- **Verify pattern:** [`PROPERTIES.md`](PROPERTIES.md), [`../verify/README.md`](../verify/README.md).  
- **Handoff:** [`HANDOFF_PRODUCTION.md`](HANDOFF_PRODUCTION.md).
