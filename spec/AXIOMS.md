<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Axiom Inventory

**Owner:** HCALC Spec agent  
**Consumers:** HCALC Lean (defs / theorems), HCALC Alloy (Provenance tags), Foundry J Verify (cite-only).  
**Rule:** Domain Gap-* are **CLOSED by definition** in [`PRODUCTION.md`](PRODUCTION.md). Prefer production defs over opaque axioms.  
**Source absorbed:** [`FOUNDRY_J_CROSSLINKS.md`](FOUNDRY_J_CROSSLINKS.md).  
**Production authority:** [`PRODUCTION.md`](PRODUCTION.md).

Provenance tags: `source-claim` | `axiom-gap` | `derived` | `SpecDefined`.

---

## Alloy A1–A7

| ID | Statement sketch | Kind | Lean link | Core / doc cite | Provenance |
|----|------------------|------|-----------|-----------------|------------|
| A1 | `#P_64=64`; elements = first-64 primes | assert | L1 | PROPERTIES **23**; Core `P64` | source-claim |
| A2 | `contractive(J,ε) ↔ gershgorin(J)<1-ε` (+ opt. power-iter 37) | assert | L2 | **33–37**; `spectral_analyze`, `gershgorin_*`, `power_iteration*` | source-claim |
| A3 | if `q>1-ε` then soft-projected scale used (**in-step C**) | assert | L4 | **43**; `soft_project`, `q_estimate`; PRODUCTION §3 | source-claim |
| A4 | affine Foundry recurrence **only if** `instance=Foundry` / FoundryAdditive diagnostic | assert | L3 | **39**; `rec_step`, `rec_run` | source-claim |
| A5 | PMAT conservation on insert-set | assert | (PMAT defs) | **29**; `pmat_compose` | source-claim |
| A6 | guardian rejects spectral_radius≥1 or non-finite | assert | — | **55** | source-claim |
| A7 | definition-records for Λm, Ξ, C, Tp present and **SpecDefined** | gate | L6 defs | [`PRODUCTION.md`](PRODUCTION.md) | **SpecDefined** (CLOSED) |

**A7 action:** Alloy must replace `Undefined` → `SpecDefined` on all four GapRecords, pointing at PRODUCTION.md formulas (not leave unconstrained).

---

## Lean L1–L7

| ID | Statement sketch | Kind | Why / status | Depends / dependents | Provenance |
|----|------------------|------|--------------|----------------------|------------|
| L1 | `P64 : Fin 64 → ℕ` = PROPERTIES 23 list | **def** | Data; no axiom if listed | Used by Tp indexing | source-claim |
| L2 | `gershgorinBound`, `contractiveG` | **def+thm** | From 33–34 | Contraction lemmas; A2 | source-claim |
| L3 | `FoundryStep Ξ Λ T g x` = prop 39 | **def** | Exact Foundry additive | A4; **≠** `hcalcStep` | source-claim |
| L4 | `qEstimate` / `softProject` | **def** | 42–43 as coded | A3; production C | source-claim |
| L5 | Unique FP when Hyp holds | **thm** (dischargeable) | Under PRODUCTION Hyp; Banach **41** + residual **46** | Convergence claims | derived |
| L6 | `Λm`, `HCALC.Ξ`, `C`, `Tp` | **defs** (not axioms) | PRODUCTION §§2–5 | Nested-form theorems | **SpecDefined** |
| L7 | `structure InstanceBridge` + Option B/C thms | **UNBLOCKED** | **NOT** `rfl`; **NOT** `FoundryStep = hcalcStep` | Instance proofs | **SpecDefined** |

---

## Named Gap-* (HCALC-native) — CLOSED

All domain gaps CLOSED — see [`PRODUCTION.md`](PRODUCTION.md) disposition table. Summary:

| GapId | Status | Definition pointer |
|-------|--------|-------------------|
| Gap-Carrier | **CLOSED — see PRODUCTION.md** | `HCALC.Carrier := Fin n → ℝ`, ℓ∞ |
| Gap-Tp-from-P64 | **CLOSED — see PRODUCTION.md** | `(Tp x)_j = α_j · x_j`, `α_j = 1/(1+log p_{j mod 64})` |
| Gap-C-wrapper | **CLOSED — see PRODUCTION.md** | soft_project-or-id on `q = ‖D(Tp)‖_est` (Spec wiring of Foundry-coded soft_project) |
| Gap-Λm-scalar | **CLOSED — see PRODUCTION.md** | `Λm = min(1, (1-ε)/(‖C∘Tp‖_op+δ))` |
| Gap-Ξ | **CLOSED — see PRODUCTION.md** | `Ξ(t,y) := ξ_t·y + g_t`; Uniform `ξ_t=1` |
| Gap-ShapeMap | **CLOSED — see PRODUCTION.md** | **`InstanceBridge` morphism** (NOT `rfl` / NOT Foundry39≡nested); L7 UNBLOCKED |
| Gap-ContractAlg | **CLOSED — see PRODUCTION.md** | Gershgorin → power-iter → soft_project (**33–43**) |
| Gap-Converge | **CLOSED — see PRODUCTION.md** | Hyp ⇒ Banach unique FP + residual→0; L5 dischargeable |
| Gap-OptObj | **CLOSED — see PRODUCTION.md** | `J(X)=‖X−Ξ(t,Λm·C(Tp(X)))‖_∞`; iterate to tol |

Provenance for all rows above: **SpecDefined** (not axiom-gap).

**ShapeMap / L7 rule (Foundry J Spec review):** REJECT identity `Foundry39 ≡ nested` and silent symbol swaps. ACCEPTED: non-identity `InstanceBridge` parameter table (`T := C∘Tp`, `Λ_vec := Λm·1`, `Ξ_vec := ξ_t`, `g := g_t`). Production Core implements **only** `hcalcStep` (Option B); `toFoundryStep` is cite-only diagnostic. Option C embedding optional later — still a morphism, never symbol identity.

---

## Theorems that may depend on production defs (Lean guidance)

| After closing | Dependent results (sketches) |
|---------------|------------------------------|
| L1 + Tp def | Well-definedness of prime-indexed diagonal layers |
| L2 + C def | Lip / non-expansive bound for nested step |
| Λm def + L2 | Stabilizing-range lemmas |
| Ξ def + InstanceBridge | Parameter-table theorems; **not** `hcalcStep = FoundryStep` |
| L7 InstanceBridge | Option B Core path; optional Option C embedding morphism |
| L5 under Hyp | Convergence monitors; uniqueness |



### Provenance (production close — Foundry J Spec pass-2)

- **Gap-Tp-from-P64** \(\alpha\) law: `spec-def` (P64 list alone is Foundry **source-claim** **23**).
- **Gap-C-wrapper**: `spec-adapt` — algorithmic cousin of Foundry soft_project **43**, **not** symbol identity (43 scales schedules; production C scales state under Spec \(q=\|D(T_p)\|\)).
- **Gap-ShapeMap / L7**: dual `bridgeMode` **NestedFaithful** | **FoundryAdditive**; InstanceBridge param table; morphism → FoundryAdditive only — never NestedFaithful = prop-**39** rfl.
- Residual \(J\): Spec \(\ell_\infty\); Foundry **46** is \(\ell_2\).

**FAIL-open:** `sorry` / Alloy `unsat` failure / missing SpecDefined A7 record ⇒ SKIP or FAIL — never PASS.

---

## Infrastructure Gap-* (Lean toolchain stubs) — ACCEPTED (not production blockers)

Provisional IDs from HCALC Lean first cut (`lake build` exit 0, Mathlib deferred). Spec **accepts these names as canonical**; do not rename without Spec update. They are **infrastructure only** — not HCALC domain axioms and **not production blockers** when nested defs use explicit Carrier ℝ^n. Closing path: replace with Mathlib `Real` / proven Foundry defs when ready; until then FAIL-open on infra (axioms OK, never silent PASS).

| GapId | Role | Lean surface | Status | Provenance |
|-------|------|--------------|--------|------------|
| Gap-Real-arith | Opaque `Real` + basic arith/order facts absent Mathlib | `Hcalc/RealStub.lean` | infra stub (Mathlib deferred) | infra-not-production-gap |
| Gap-Foundry-StateOps | Foundry recurrence carrier + add/smul/zero (≠ HCALC `State`) | `Hcalc/Foundry.lean` | infra stub | infra-not-production-gap |
| Gap-Foundry-FinMax | `finMax` for Gershgorin-style bounds | `Hcalc/Foundry.lean` | infra stub | infra-not-production-gap |
| Gap-Foundry-Norm | Opaque weight / nonlinear norms for coded q-estimate | `Hcalc/Foundry.lean` | infra stub | infra-not-production-gap |
| Gap-Foundry-Div | Real division for soft-project scale | `Hcalc/Foundry.lean` | infra stub | infra-not-production-gap |
| Gap-Foundry-SoftScale | Opaque soft-project scale + branch laws | `Hcalc/Foundry.lean` | infra stub | infra-not-production-gap |

**Rule:** Infra stubs must not leave unfinished *production* theorems depending on `sorry`. Production Carrier/Tp/C/Λm/Ξ/J path uses explicit ℝ^n defs in PRODUCTION.md. Do **not** use infra stubs to invent an `rfl` ShapeMap.

---

## Steering aliases (G-*)

Stable short aliases. Prefer these in tags; Spec GapIds remain canonical. **All CLOSED.**

| Alias | Canonical GapId | Statement | Status |
|-------|-----------------|-----------|--------|
| **G-SHAPE** | Gap-ShapeMap | `InstanceBridge` morphism (NOT `rfl`; NOT Foundry39≡nested) | **CLOSED** — PRODUCTION §6 |
| **G-Lm** | Gap-Λm-scalar | Scalar Λm formula (≠ vector schedule) | **CLOSED** — PRODUCTION §4 |
| **G-C** | Gap-C-wrapper | In-step soft_project-or-id as C (Spec wiring) | **CLOSED** — PRODUCTION §3 |
| **G-Tp** | Gap-Tp-from-P64 | Diagonal Tp from P64 α weights | **CLOSED** — PRODUCTION §2 |

Core cite-only (hooks, not alternate defs): `P64`, `pmat_compose`, `spectral_analyze`, `soft_project`, `q_estimate`, `synth_weights`, `rec_step`, `rec_run`, `ace_certify` — see foundry-j `spec/J_API.md`, `j/BOXING.md`, `spec/GAP_DECISIONS.md`.
