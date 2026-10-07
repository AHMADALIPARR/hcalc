<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Production Definitions

**Owner:** HCALC Spec  
**License:** AGPL-3.0-only  
**Status:** PRODUCTION — all domain Gap-* CLOSED by definition (not opaque axioms).  
**Consumers:** Alloy, Lean, Foundry J Core/Verify/Spec.  
**Related:** [`AXIOMS.md`](AXIOMS.md), [`COHERENCE.md`](COHERENCE.md), [`FOUNDRY_J_CROSSLINKS.md`](FOUNDRY_J_CROSSLINKS.md).

Nested recurrence (canonical):

\[
X_{t+1} = \Xi\bigl(t,\; \Lambda_m \cdot C(T_p(X_t))\bigr).
\]

---

## Parameters (fixed for production)

| Symbol | Meaning | Default |
|--------|---------|---------|
| \(n\) | Carrier dimension | parameter \(\ge 1\) (Lean: free `n : ℕ`) |
| \(\varepsilon\) | Contraction margin | tier schedule Foundry **25**: T1→0.10, T2→0.05, T3→0.02, T4→0.01; **default T2 = 0.05** |
| \(\delta\) | Guard for Λm denominator | \(10^{-12}\) (positive) |
| \(\mathrm{tol}\) | Residual stop | \(10^{-6}\) |
| `xi_schedule` | \(\xi_t\) law | **Uniform**: \(\xi_t = 1\) for all \(t\) |
| `g_t` | Affine kick | default \(0\) (zero vector) unless instance supplies otherwise |

Foundry cites used below: PROPERTIES **23**, **25**, **33–43**, **39**, **41**, **46**.

---

## Closed definitions

### 1. Gap-Carrier → `HCALC.Carrier` — CLOSED

\[
\texttt{HCALC.Carrier} \;\equiv\; X \;:=\; \mathbb{R}^n \;=\; (\mathrm{Fin}\, n \to \mathbb{R})
\]

with \(\ell_\infty\) norm \(\|x\|_\infty = \max_{j} |x_j|\).  
Optional later instance: Goldilocks \(\mathbb{F}_p\) (Foundry **1–17**) — **not** required for production ℝ path.

### 2. Gap-Tp-from-P64 → `Tp` — CLOSED

Let \(P_{64} = (p_0,\ldots,p_{63})\) be the first-64 primes (Lean **L1** / Foundry prop **23**).  
For dimension \(n\), use primes \(p_{j \bmod 64}\).

**Exact formula (diagonal PrimeMask weights):**

\[
\alpha_j \;=\; \frac{1}{1 + \log p_{j\bmod 64}}, \qquad
(T_p\, x)_j \;=\; \alpha_j \cdot x_j.
\]

So \(\varphi\) is the **identity on coordinates** (diagonal action); \(\alpha\) is the synth_weights/primes-style schedule on `P64`.  
Equivalent view: \(T_p = \mathrm{diag}(\alpha)\).  
**Not** Sedona/PIRTM tooling; **not** full PMAT recursion.

**Provenance (§2):** `P64` list = Foundry **source-claim** (prop **23**). The weight law $\alpha_j=1/(1+\log p_{j\bmod 64})$ is **`spec-def`** — **not** a Foundry PROPERTY / not `source-claim` from foundry-j.

### 3. Gap-C-wrapper → `C` — CLOSED

Let \(D(T_p)\) be the Jacobian of \(T_p\) (here \(D(T_p)=\mathrm{diag}(\alpha)\)).  
Let \(q\) be the operator-norm estimate via Gershgorin, with power-iteration fallback (Foundry **33–37**):

\[
q \;:=\; \|D(T_p)\|_{\mathrm{est}}.
\]

**In-step governor** (soft_project wired as operator — **not** post-hoc `ace_certify`):

\[
C(x) \;=\;
\begin{cases}
\dfrac{1-\varepsilon}{q}\, x & \text{if } q > 1-\varepsilon, \\[6pt]
x & \text{otherwise.}
\end{cases}
\]

I.e. \(C = s\cdot\mathrm{id}\) with \(s=\mathrm{softProjectScale}(q,\varepsilon)\).

**Provenance (§3):** Production `C` is **`spec-adapt`**: it reuses the *scale-or-id* idea \((1-\varepsilon)/q\) as an **algorithmic cousin** of Foundry `soft_project` (prop **43**), but it is **not** symbol-identical to **43**. Foundry **43** scales schedule weights \(\Xi,\Lambda\) under Foundry \(q\) (prop **42**); production `C` scales the **state** under Spec \(q:=\|D(T_p)\|_{\mathrm{est}}\). Do **not** tag `C` as Foundry `source-claim` for **43**. Shared helper name `softProjectScale` OK; **Foundry `soft_project` API stays schedule-scaling** (prop **43**). Production `C` remains Spec-wiring / **spec-adapt** (state scale).

### 4. Gap-Λm-scalar → `Λm` — CLOSED

\(\Lambda_m \in \mathbb{R}_{\ge 0}\) is a **scalar** (not Foundry `lambda_schedule` vector):

\[
\Lambda_m \;=\; \min\Bigl(1,\; \frac{1-\varepsilon}{\|C\circ T_p\|_{\mathrm{op}} + \delta}\Bigr),
\]

ensuring \(\|\Lambda_m\cdot(C\circ T_p)\|_{\mathrm{op}} \le 1-\varepsilon\).

### 5. Gap-Ξ → `Ξ` — CLOSED

With \(\xi_t\) from `xi_schedule(t)` (default **Uniform**: \(\xi_t=1\)) and kick \(g_t\):

\[
\Xi(t,y) \;:=\; \xi_t\cdot y + g_t.
\]

Therefore

\[
X_{t+1} = \xi_t\cdot\bigl(\Lambda_m\cdot C(T_p(X_t))\bigr) + g_t.
\]

### 6. Gap-ShapeMap / L7 — CLOSED via **InstanceBridge** (NOT `rfl`)

**REJECTED (Foundry J Spec review):** identity `Foundry39 ≡ nested`; silent `Λ_t↔Λm`, `T↔T_p`, `Ξ_t↔Ξ(t,·)`, Gershgorin/`soft_project` measures ↔ in-step `C` as Foundry-native law.

**ACCEPTED:** Gap-ShapeMap is a **non-identity** morphism. soft_project remains **Foundry-coded** (props **42–43**) and is *used by* HCALC `C` under this Spec — that is Spec wiring, not a Foundry identity claim.

#### Explicit morphism `InstanceBridge`

Let HCALC state \(x\in\texttt{HCALC.Carrier}\). Define a **labeled instance map** (Lean: `InstanceBridge`, Alloy: `bridgeMode = InstanceBridge`):

\[
\texttt{toFoundryStep}(t,x)
\;:=\;
\texttt{FoundryStep}\bigl(
  \Xi_{\mathrm{vec}}:=\xi_t,\;
  \Lambda_{\mathrm{vec}}:=\Lambda_m\cdot\mathbf{1},\;
  T := C\circ T_p,\;
  g := g_t,\;
  x
\bigr)
\;=\;
\xi_t\cdot x + \Lambda_m\cdot(C\circ T_p)(x) + g_t.
\]

The **HCALC nested step** is separately:

\[
\texttt{hcalcStep}(t,x)
\;:=\;
\Xi\bigl(t,\, \Lambda_m\cdot C(T_p(x))\bigr)
\;=\;
\xi_t\cdot\bigl(\Lambda_m\cdot C(T_p(x))\bigr) + g_t.
\]

These are **different** morphisms in general (\(\xi_t\cdot x\) term present only on the Foundry side).  
**L7 theorem (production):** there exists an explicit Spec-named witness relating them — *not* `rfl`:

- **Option A (recommended default):** `bridgeWitness = Projective` — equality after applying the HCALC projection that discards the free \(\xi_t\cdot x\) drift, or equivalently require \(\xi_t=0\) on the identity channel (not used).  
- **Option B (operational default for Core):** implement **only** `hcalcStep` as the production verb; expose `toFoundryStep` as a **cite-only diagnostic** that uses Foundry `rec_step` shape with the parameter table above, **without claiming** `hcalcStep = toFoundryStep`.  
- **Option C:** when \(\xi_t = 1\) and one rewrites nested as additive on an extended state, document the embedding \(\iota\) and prove `toFoundryStep(t,ι(x)) = ι(hcalcStep(t,x))` — still a morphism, **never** symbol identity.

**Production bridgeMode (dual — Foundry J Spec ACCEPT):**

| bridgeMode | Meaning | vs Foundry **39** |
|------------|---------|-------------------|
| **FoundryAdditive** | `toFoundryStep` = classical **39**-shaped morphism with InstanceBridge params `T:=C∘Tp`, `Λ:=Λm·1`, `Ξ:=ξ_t` | **ACCEPT** morphism into additive shape — **not** nested |
| **NestedFaithful** / nested `hcalcStep` | `ξ·(Λm·(C∘Tp)(x))+g` | Spec definitional nested — **REJECT** as prop-**39** `rfl` / identity |

**InstanceBridge** = the explicit parameter table (morphism data), not an equality proof. Hilbert morphism \(T:=C\circ T_p\), \(\Lambda:=\Lambda_m\mathbf{1}\), \(\Xi:=\xi\) maps to **FoundryAdditive** shape only.

**Production choice for Core:** implement **`hcalc_step`** = nested (NestedFaithful semantics); expose `toFoundryStep` only as FoundryAdditive diagnostic. **L7 UNBLOCKED** as `structure InstanceBridge` + dual-mode theorems — **never** `FoundryStep = hcalcStep`.

| Foundry symbol (instance params) | HCALC production value | Identity? |
|----------------------------------|------------------------|-----------|
| \(T\) | \(C\circ T_p\) | **no** — assignment under InstanceBridge |
| \(\Lambda_{\mathrm{vec}}\) | \(\Lambda_m\cdot\mathbf{1}\) | **no** — scalar broadcast ≠ Foundry schedule vector law |
| \(\Xi_{\mathrm{vec}}\) | \(\xi_t\) from HCALC `xi_schedule` | **no** — not Foundry \(\Xi_t\) vector schedule identity |
| \(g\) | \(g_t\) | instance param |

### 7. Gap-ContractAlg — CLOSED

Algorithm (Foundry **33–43**):

1. Estimate \(q=\|D(T_p)\|_{\mathrm{est}}\) by Gershgorin; if tight, power-iteration fallback (**35–37**).  
2. Apply soft_project scale as in §3 (**42–43**).  
3. Form \(\Lambda_m\) as in §4.

### 8. Gap-Converge — CLOSED (L5 dischargeable)

**Hyp** (for iteration of **`hcalcStep`** — Option B / nested production path):

\[
|\xi_t|\cdot\|\Lambda_m\cdot(C\circ T_p)\|_{\mathrm{op}} < 1-\varepsilon.
\]

Under Uniform \(\xi_t=1\) this is \(\|\Lambda_m\cdot(C\circ T_p)\|_{\mathrm{op}} < 1-\varepsilon\).

Do **not** state Hyp on `toFoundryStep` / classical additive shape without an extra account of the free \(\xi_t\cdot x\) term (that diagnostic has a different operator).

Then: Banach unique fixed point (Foundry narrative **41**, spirit) and residual \(\to 0\) along **`hcalcStep`** iteration (stop spirit of **46**; metric is Spec \(\ell_\infty\)).  
**L5:** theorem under Hyp (prove in Lean; not unfinished axiom).

### 9. Gap-OptObj — CLOSED

\[
J(X) \;=\; \bigl\| X - \Xi\bigl(t,\, \Lambda_m\cdot C(T_p(X))\bigr) \bigr\|_\infty
\]

(residual). **Optimize** = iterate the nested map until \(J(X)<\mathrm{tol}\).

**Provenance (residual):** PRODUCTION \(J\) uses \(\ell_\infty\). Foundry prop **46** residual is \(\ell_2\). **ACCEPT Spec \(\ell_\infty\) choice**; do not claim metric identity with **46** — only stop-spirit / tolerance pattern.

---

## Infra gaps (not domain blockers)

| GapId | Disposition |
|-------|-------------|
| Gap-Real-arith | Infra stub OK (RealStub / future Mathlib). Must not leave unfinished *production* theorems depending on sorry. |
| Gap-Foundry-StateOps / FinMax / Norm / Div / SoftScale | Infra for Foundry mirrors; production HCALC path uses Carrier ℝ^n defs above. Replace with Mathlib when ready. |

---

## Gap disposition table

| GapId | Was | Now | Alloy action | Lean action | Verify action |
|-------|-----|-----|--------------|-------------|---------------|
| Gap-Carrier | axiom-gap | **CLOSED** `HCALC.Carrier = Fin n → ℝ`, ℓ∞ | Instance param → ℝ^n model / abstract n | `def Carrier` | Check A carrier |
| Gap-Tp-from-P64 | axiom-gap | **CLOSED** diag \(\alpha\) (**spec-def**); P64 list **source-claim** **23** | Retire Undefined; encode diag Tp | `def Tp` from L1 P64 | Prime carrier + Tp law |
| Gap-C-wrapper | axiom-gap | **CLOSED** scale-or-id on Spec \(q\) (**spec-adapt**; cousin of **43**, ≠ **43**) | C = scale-or-id | `def C` | Contraction spectral/q |
| Gap-Λm-scalar | axiom-gap | **CLOSED** scalar min formula | Λm scalar bound assert | `def LambdaM` | Stabilizing range |
| Gap-Ξ | axiom-gap | **CLOSED** \(\xi_t y + g_t\), Uniform default | Ξ affine | `def Xi` | Evolution step shape |
| Gap-ShapeMap / L7 | blocked | **CLOSED** `InstanceBridge` morphism (NOT rfl / NOT Foundry39≡nested) | Encode InstanceBridge table; forbid symbol identity | **L7** `structure InstanceBridge` + Option B/C thms | H-SHAPE → PASS only for InstanceBridge witness, never identity |
| Gap-ContractAlg | axiom-gap | **CLOSED** Gershgorin→power-iter→soft_project | A2/A3 production wiring | defs + thms | Checks B |
| Gap-Converge | axiom-gap | **CLOSED** Hyp ⇒ Banach + residual→0 | Guardian + residual | **L5** under Hyp | Residual discharge |
| Gap-OptObj | axiom-gap | **CLOSED** \(J=\) residual; iterate to tol | OptObj residual | `def J` + loop spec | Optimize/converge props |
| A7 | Undefined stubs | **SpecDefined** records pointing here | Replace Undefined→Defined | — | A7 gate PASS |
| L6 | uninterpreted axioms | **defs** | — | Replace axioms with defs | Seal Lean↔Alloy |
| Gap-Real-arith / Gap-Foundry-* | infra | infra OK | ignore | keep stubs or Mathlib | no false PASS |

---

## Alloy checklist

1. Retire all `Undefined` on Λm, Ξ, C, Tp → `SpecDefined` / production preds.  
2. Keep A1–A6; rewire A2/A3/A4 to production C/Λm/`InstanceBridge`.  
3. Encode **`bridgeMode`**: nested **`hcalcStep`** vs diagnostic **`toFoundryStep`** (InstanceBridge param table). Do **not** assert Foundry39≡nested; do **not** use a bare `FoundryAdditive` equate without InstanceBridge params.  
4. OptObj = residual (\(\ell_\infty\)); ContractAlg = Gershgorin→power-iter→Spec scale-or-id.  
5. Report check log green.


## Lean checklist

1. `Carrier`, `Tp`, `C`, `LambdaM`, `Xi`, `J` as **defs**.  
2. Unblock **L7** InstanceBridge (`def` / theorem).  
3. **L5** theorem under Hyp (0 sorry).  
4. Infra RealStub only if no production sorry.  
5. `lake build` exit 0.

## Verify checklist

1. Flip SKIP→PASS where hyps hold (A–E).  
2. H-SHAPE PASS under InstanceBridge.  
3. FAIL-open still if Lean sorry / Alloy unsat.  
4. Update `PROPERTY_MAP.md`.

## Core checklist (Foundry J)

Implement verbs: `Tp` from P64 α, in-step `C` soft_project, scalar `Λm`, `Xi` from `xi_schedule`, InstanceBridge step. Cite `P64`, `spectral_analyze`, `soft_project`, `q_estimate`, `synth_weights`, `rec_step`.

---


## Core implement path (AUTHORITATIVE)

**Path:** `/workspace/hcalc/j/` (HCALC research-center repo; AGPL-3.0-only).  
Foundry J Core implements production verbs **here**, calling Foundry cite hooks from `foundry-j` (`P64`, `spectral_analyze`, `soft_project`, `q_estimate`, `synth_weights`) without equating `hcalc_step` to `rec_step`.

| Verb | Formula source in this file |
|------|-----------------------------|
| `tp_from_p64` | §2 Gap-Tp-from-P64 |
| `c_wrap` | §3 Gap-C-wrapper (uses Foundry-coded soft_project) |
| `lam_m_from_bound` | §4 Gap-Λm-scalar |
| `hcalc_xi_apply` | §5 Gap-Ξ |
| `hcalc_step` | nested §5; **not** `rec_step` |
| `hcalc_run` | iterate `hcalc_step` until §9 residual < tol |

Draft names from `foundry-j/j/HCALC_API_DRAFT.md` are **accepted**. Leave Foundry additive API unchanged.

---
## Changelog

- 2026-10-07: Initial PRODUCTION close-all-gaps (USER mandate via Hilbert).
- 2026-10-07: ShapeMap → explicit **InstanceBridge** (Foundry J Spec review); Core path `/workspace/hcalc/j/`.
- 2026-10-07: Pass-3 nits — §3 schedule-scaling note; Alloy checklist InstanceBridge; §8 Hyp on hcalcStep.
- 2026-10-07: Pass-2 absorb — `C`/`q` **spec-adapt** (≠ Foundry **43**/**42**); \(\alpha\) **spec-def**; dual NestedFaithful|FoundryAdditive; residual \(\ell_\infty\neq\ell_2\) note.
