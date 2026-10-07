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

**Production choice:** **Option B** for Core verbs + Lean `InstanceBridge` record holding the parameter table; **Option C** optional later theorem. **L7 UNBLOCKED** as `structure InstanceBridge` + theorems about the table — **not** as `FoundryStep = hcalcStep`.

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

**Hyp:**

\[
\|\Lambda_m\cdot(C\circ T_p)\|_{\mathrm{op}} + \mathrm{margin}(\xi) < 1-\varepsilon
\]

with \(\mathrm{margin}(\xi)=0\) under Uniform \(\xi_t=1\) when using InstanceBridge (operator is exactly \(\Lambda_m(C\circ T_p)\) scaled by \(\xi_t\); require \(|\xi_t|\cdot\|\Lambda_m(C\circ T_p)\|_{\mathrm{op}} < 1-\varepsilon\)).

Then: Banach unique fixed point (Foundry narrative **41**) and residual (**46**) \(\to 0\) along iteration.  
**L5:** theorem under Hyp (prove in Lean or keep as named theorem with Hyp; not unfinished axiom).

### 9. Gap-OptObj — CLOSED

\[
J(X) \;=\; \bigl\| X - \Xi\bigl(t,\, \Lambda_m\cdot C(T_p(X))\bigr) \bigr\|_\infty
\]

(residual). **Optimize** = iterate the nested map until \(J(X)<\mathrm{tol}\).

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
| Gap-Tp-from-P64 | axiom-gap | **CLOSED** \((T_p x)_j=\alpha_j x_j\), \(\alpha_j=1/(1+\log p_{j\bmod 64})\) | Retire Undefined; encode diag Tp | `def Tp` from L1 P64 | Prime carrier + Tp law |
| Gap-C-wrapper | axiom-gap | **CLOSED** soft_project-or-id on \(q\) | C = scale-or-id pred | `def C` | Contraction spectral/q |
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
2. Keep A1–A6; rewire A2/A3/A4 to production C/Λm/ShapeMap.  
3. Assert InstanceBridge bridge; do **not** equate FoundryAdditive without bridgeMode.  
4. OptObj = residual; ContractAlg as above.  
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
