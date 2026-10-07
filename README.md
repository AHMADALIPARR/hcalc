<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC

**A nested contraction recurrence, specified in prose, checked in Alloy, formalized in Lean 4, implemented in J, and scored by a fail-open harness.**

---

## Abstract

HCALC is a research object: a single discrete-time dynamical system on a finite-dimensional real carrier, written in *nested* form,

$$
X_{t+1} = \Xi\left(t,\ \Lambda_m \cdot C\left(T_p(X_t)\right)\right).
$$

Each symbol in that line is defined exactly once, in [`spec/PRODUCTION.md`](spec/PRODUCTION.md). The prime-weighted transform $T_p$ is built from the first sixty-four primes; $C$ is an in-step contraction governor; $\Lambda_m$ is a scalar stabilizer; $\Xi$ is an affine evolution operator. The repository carries four independent renderings of the same definitions — a prose specification, a bounded relational model, a machine-checked library, and an executable core — plus a verification harness that refuses to report a pass it cannot measure.

The point of the exercise is coherence. A definition that only lives in prose drifts; a definition that only lives in code hides its assumptions. HCALC keeps every rendering pinned to one production specification, records the provenance of each formula, and is explicit about where its recurrence differs from the closely related *additive* Banach recurrence implemented in the sibling repository [foundry-j](https://github.com/AHMADALIPARR/foundry-j). Those two shapes are related by a named, non-identity morphism called `InstanceBridge`. They are never silently equated.

This README explains the mathematical object, how the pieces of the repository fit together, how to reproduce each gate, what the gates measured on disk, and what is deliberately out of scope.

---

## 1. Why this repository exists

The Foundry F1 stack contains a classical additive Banach recurrence,

$$
x_{t+1} = \Xi_t \cdot x_t + \Lambda_t \cdot T(x_t) + g_t,
$$

governed by a spectral contraction check and a schedule-level soft projection. That form is well understood: the contraction factor is roughly $\lVert \Xi_t \rVert + \lVert \Lambda_t \rVert \cdot \lVert T \rVert$, and convergence follows from Banach's fixed-point theorem whenever the factor stays below $1 - \varepsilon$.

HCALC asks a different question. Suppose the governor is not applied to the *schedule* after the fact but *inside* the step, to the state itself, and suppose the weighting comes from a fixed prime spectrum rather than from a synthesized schedule. The result is a composition of operators rather than a sum of terms. Composition and addition are not interchangeable: a nested map has no free drift term $\Xi_t \cdot x_t$, its Lipschitz constant multiplies rather than adds, and its convergence hypothesis has a different form.

Because the two shapes look superficially similar and share vocabulary (a $\Xi$, a $\Lambda$, a $T$, a soft-projection idea), it is very easy to write documentation or code that quietly treats them as the same thing. HCALC exists to define the nested shape precisely, to exercise it in several formal systems, and to make the relationship to the additive shape an explicit object with its own tests.

---

## 2. The mathematical object

All formulas in this section are transcribed from `spec/PRODUCTION.md`. Section numbers in parentheses refer to that file.

### 2.1 Carrier (§1)

The state space is the real vector space of dimension $n \ge 1$,

$$
\mathcal{X} = \mathbb{R}^n = (\mathrm{Fin}\ n \to \mathbb{R}),
$$

equipped with the sup norm

$$
\lVert x \rVert_\infty = \max_{0 \le j < n} \lvert x_j \rvert .
$$

The choice of $\ell_\infty$ is deliberate. It matches the Gershgorin row-sum estimates used for the contraction measure, and it is the metric in which the residual objective of §9 is stated. A Goldilocks prime-field carrier $\mathbb{F}_p$ is noted in the specification as a possible later instance; it is not part of the production path.

### 2.2 Prime-weighted transform $T_p$ (§2)

Let $P_{64} = (p_0, p_1, \ldots, p_{63}) = (2, 3, 5, \ldots, 311)$ be the first sixty-four primes. For coordinate $j$ of an $n$-dimensional state, use the prime $p_{j \bmod 64}$ and define the weight

$$
\alpha_j = \frac{1}{1 + \ln p_{j \bmod 64}} .
$$

The transform is diagonal:

$$
(T_p x)_j = \alpha_j \, x_j, \qquad T_p = \mathrm{diag}(\alpha_0, \ldots, \alpha_{n-1}).
$$

Every weight lies strictly between $0$ and $1$. The largest is attained at $p_0 = 2$, where $\alpha_0 = 1/(1 + \ln 2) \approx 0.5906$; the smallest in the first block is at $p_{63} = 311$, where $\alpha_{63} \approx 0.1484$. The list $P_{64}$ itself is a Foundry source claim (Foundry property 23). The weight law is HCALC's own definition (provenance tag `spec-def`); it is not a Foundry property.

### 2.3 Contraction governor $C$ (§3)

Let $D(T_p)$ be the Jacobian of $T_p$, which for a diagonal map is $\mathrm{diag}(\alpha)$. Let $q$ be its operator-norm estimate, computed by a Gershgorin bound with power-iteration fallback (the spectral measures of Foundry properties 33–37):

$$
q = \lVert D(T_p) \rVert_{\mathrm{est}} .
$$

The governor is a state-level scale-or-identity map with margin $\varepsilon$:

```math
C(x) =
\begin{cases}
\dfrac{1-\varepsilon}{q}\, x, & q > 1 - \varepsilon, \\
x, & \text{otherwise.}
\end{cases}
```

Equivalently $C = s \cdot \mathrm{id}$ with $s = (1-\varepsilon)/q$ when the estimate exceeds the margin and $s = 1$ otherwise. The scale factor reuses the idea behind Foundry's `soft_project` (property 43), but the object scaled is different: Foundry scales the schedule vectors $\Xi$ and $\Lambda$; HCALC scales the state. The specification therefore tags $C$ as `spec-adapt` and explicitly rejects reading it as Foundry property 43.

### 2.4 Scalar stabilizer $\Lambda_m$ (§4)

$\Lambda_m$ is a non-negative scalar, not a schedule vector:

$$
\Lambda_m = \min\left(1,\ \frac{1 - \varepsilon}{\lVert C \circ T_p \rVert_{\mathrm{op}} + \delta}\right),
$$

with a small positive guard $\delta$ in the denominator. By construction,

$$
\lVert \Lambda_m \cdot (C \circ T_p) \rVert_{\mathrm{op}} \le 1 - \varepsilon .
$$

### 2.5 Evolution operator $\Xi$ (§5)

With a time-indexed scalar $\xi_t$ and an affine kick $g_t \in \mathbb{R}^n$,

$$
\Xi(t, y) = \xi_t \cdot y + g_t .
$$

The production schedule is uniform, $\xi_t = 1$ for all $t$, and the default kick is $g_t = 0$.

### 2.6 The step and the objective (§5, §9)

Substituting the definitions gives the production step,

$$
X_{t+1} = \xi_t \cdot \left(\Lambda_m \cdot C\left(T_p(X_t)\right)\right) + g_t,
$$

and the optimization objective is the sup-norm residual of one step,

$$
J(X) = \left\lVert X - \Xi\left(t,\ \Lambda_m \cdot C\left(T_p(X)\right)\right) \right\rVert_\infty .
$$

To optimize is to iterate the nested map until $J(X) < \mathrm{tol}$. Foundry's residual (property 46) is an $\ell_2$ norm; HCALC uses $\ell_\infty$ and claims only the stopping pattern, not metric identity.

### 2.7 Production parameters

| Symbol | Meaning | Production value |
|---|---|---|
| $n$ | carrier dimension | free parameter, at least 1 |
| $\varepsilon$ | contraction margin | tier T2, 0.05 (tiers T1–T4: 0.10, 0.05, 0.02, 0.01) |
| $\delta$ | guard in the $\Lambda_m$ denominator | $10^{-12}$ |
| tol | residual stop | $10^{-6}$ |
| $\xi_t$ | evolution schedule | uniform, 1 |
| $g_t$ | affine kick | zero vector |

### 2.8 What the definitions imply at production defaults

It is worth working the definitions through once, because the result is instructive. For any $n \ge 1$ the first coordinate uses $p_0 = 2$, so the Gershgorin estimate of the diagonal Jacobian is

$$
q = \max_j \alpha_j = \alpha_0 = \frac{1}{1 + \ln 2} \approx 0.5906 .
$$

With $\varepsilon = 0.05$ the margin is $1 - \varepsilon = 0.95$. Since $q < 0.95$, the governor takes its identity branch, $s = 1$, and $\lVert C \circ T_p \rVert_{\mathrm{op}} = q$. Then

$$
\Lambda_m = \min\left(1,\ \frac{0.95}{0.5906 + 10^{-12}}\right) = 1 .
$$

With $\xi_t = 1$ and $g_t = 0$, the production step collapses to the diagonal linear map $X \mapsto \mathrm{diag}(\alpha)\, X$, a strict $\ell_\infty$ contraction with modulus about $0.5906$ and unique fixed point $0$.

This is not a defect; it is what the definitions say. At production defaults the governor and the stabilizer are *inactive safeguards*: they activate only when a different transform, margin, or schedule pushes the estimate past $1 - \varepsilon$. The value of writing them out, checking them in Alloy, and proving properties about them in Lean is that the safeguards are specified and exercised before any instance needs them.

---

## 3. Nested versus additive: the `InstanceBridge`

This is the section that matters most for anyone reading HCALC alongside foundry-j.

### 3.1 Two different maps

Under the InstanceBridge parameter table, the Foundry-shaped diagnostic step is

$$
\mathrm{toFoundryStep}(t, x) = \xi_t \cdot x + \Lambda_m \cdot (C \circ T_p)(x) + g_t ,
$$

and the HCALC nested step is

$$
\mathrm{hcalcStep}(t, x) = \xi_t \cdot \left(\Lambda_m \cdot C\left(T_p(x)\right)\right) + g_t .
$$

Their difference is

$$
\mathrm{toFoundryStep}(t, x) - \mathrm{hcalcStep}(t, x) = \xi_t \cdot x + (1 - \xi_t)\,\Lambda_m \cdot (C \circ T_p)(x).
$$

Under the uniform schedule $\xi_t = 1$ this reduces to the free drift term $x$ itself. The two maps agree only where that term vanishes. They have different operators, different Lipschitz constants, and different fixed-point structure. Under uniform schedule and zero kick, for example, the additive diagnostic is $x \mapsto x + \mathrm{diag}(\alpha)\,x$, whose modulus exceeds $1$; the nested step is $x \mapsto \mathrm{diag}(\alpha)\,x$, whose modulus is below $1$.

### 3.2 The parameter table

`InstanceBridge` is a *parameter table*: data that says which HCALC quantity is plugged into which Foundry slot when one wants to evaluate the additive shape on HCALC inputs.

| Foundry slot | HCALC value under the bridge | Identity claimed? |
|---|---|---|
| nonlinear map $T$ | $C \circ T_p$ | no — assignment only |
| weight vector $\Lambda_{\mathrm{vec}}$ | $\Lambda_m \cdot \mathbf{1}$ | no — scalar broadcast, not a Foundry schedule |
| weight vector $\Xi_{\mathrm{vec}}$ | $\xi_t$ from the HCALC schedule | no — not Foundry's synthesized $\Xi_t$ |
| affine term $g$ | $g_t$ | instance parameter |

### 3.3 Two bridge modes

The specification keeps both readings alive and names them:

- **NestedFaithful.** The production verb is `hcalcStep`. This is the definitional HCALC recurrence and is explicitly *not* Foundry property 39.
- **FoundryAdditive.** The diagnostic `toFoundryStep` evaluates the additive shape of property 39 with the parameter table above. It is a morphism into the additive shape, not an equality with the nested one.

The production choice (Option B in the specification) is to implement only `hcalcStep` as a working verb and to expose `toFoundryStep` as a cite-only diagnostic. Option A (discard the drift by projection) and Option C (an explicit embedding $\iota$ into an extended state with a proved commuting square) are recorded as legitimate alternatives. In none of the three options is the relationship a symbol identity or a `rfl` proof of step equality.

### 3.4 How each layer enforces the distinction

- **Lean.** `structure InstanceBridge` records the table. `toFoundryStep_eq` and `hcalcStepCore_eq` unfold each map separately. `toFoundryStep_vs_hcalc_uniform_zero` proves that under $\xi = 1$, $g = 0$ the diagnostic equals $x + \mathrm{stabilized}(x)$ while the nested step equals $\mathrm{stabilized}(x)$. No theorem states `FoundryStep = hcalcStep`.
- **Alloy.** `P6_instance_bridge_morphism` and `INV_step_shape_bridge_instance` check the bridge as a labeled morphism; `A4_foundry_additive_only_if_Foundry_instance` confines the additive shape to Foundry instances.
- **J.** `hcalc_step` and `to_foundry_step_diagnostic` are separate verbs. The harness evaluates both on the same input and requires the outputs to differ.
- **Verify.** `H-SHAPE` passes only when the table, the Lean structure, and the numeric inequality are all present. If the step and the diagnostic ever coincided, the harness is written to report `BLOCKED` with the reason "would assert Foundry39 ≡ nested" rather than pass.

---

## 4. Convergence

The convergence hypothesis is stated for the nested step only (§8):

$$
\lvert \xi_t \rvert \cdot \lVert \Lambda_m \cdot (C \circ T_p) \rVert_{\mathrm{op}} < 1 - \varepsilon .
$$

Under the uniform schedule this is $\lVert \Lambda_m \cdot (C \circ T_p) \rVert_{\mathrm{op}} < 1 - \varepsilon$. The specification forbids stating the same hypothesis for `toFoundryStep` without separately accounting for its drift term, because that diagnostic has a different operator.

Under the hypothesis, the Banach contraction principle gives a unique fixed point, and the residual $J$ tends to zero along the iteration. In the Lean library this is packaged as `HypContractive`: a modulus $q$ with $q < 1 - \varepsilon$, $q < 1$, and the Lipschitz inequality

$$
\lVert F(x) - F(y) \rVert_\infty \le q \cdot \lVert x - y \rVert_\infty \quad \text{for all } x, y .
$$

What the library proves, precisely:

| Lean theorem | Statement |
|---|---|
| `unique_fixed_point` | a map satisfying `HypContractive` has at most one fixed point |
| `step_fixes_zero` | the nested step with uniform schedule and zero kick fixes $0$ |
| `unique_fp_step_of_hyp` | under `HypContractive`, $0$ is *the* fixed point of the nested step |
| `residual_at_fixed_point`, `J_at_zero` | the residual objective vanishes at a fixed point, in particular at $0$ |
| `contractiveG_from_bound` | a Gershgorin bound below $1 - \varepsilon$ yields Foundry's contractive predicate |

The library does not prove a rate of convergence or a limit statement for the iterates; those would require a completed real-analysis layer (see §8 below).

---

## 5. Provenance discipline

Every formula carries one of three tags, and the tags are load-bearing:

| Tag | Meaning | Examples |
|---|---|---|
| `source-claim` | a fact read from the Foundry sources and inventoried as a numbered Foundry property | $P_{64}$ (property 23), tier epsilons (property 25), Gershgorin and power-iteration measures (33–37) |
| `spec-def` | a definition owned by the HCALC specification with no Foundry counterpart | the weight law $\alpha_j = 1/(1 + \ln p_{j \bmod 64})$; the $\ell_\infty$ residual |
| `spec-adapt` | an HCALC definition that reuses an idea from Foundry but is not symbol-identical to it | the state-level governor $C$ (cousin of property 43, scaling state rather than schedules) |

The tags stop a common failure mode: crediting a Foundry property for an HCALC definition, then citing the Foundry verification as if it covered HCALC. Foundry's review of the HCALC specification, recorded in `spec/FOUNDRY_J_PRODUCTION_REVIEW.md` and mirrored in the foundry-j repository, accepts the specification on exactly these terms.

---

## 6. Repository layout

```
hcalc/
  LICENSE                 GNU AGPL v3 (AGPL-3.0-only)
  README.md               this document
  spec/
    PRODUCTION.md         authoritative production definitions
    AXIOMS.md             original axiom-level statement of the object
    COHERENCE.md          cross-layer coherence notes
    PROPERTIES.md         property names used by Alloy, Lean, Verify
    INTERFACES.md         symbol interfaces between layers
    FOUNDRY_J_CROSSLINKS.md          mapping to Foundry property numbers
    FOUNDRY_J_PRODUCTION_REVIEW.md   Foundry review of PRODUCTION.md
  alloy/
    HCALC.als             top-level model: gap records, checks, runs
    modules/              State, PrimeIndex, Transform, Recursion,
                          Stabilize, Contract, Evolve, Optimize, Converge
    run.sh                exec all commands, raw receipt
    run-production.sh     per-command checks, summary to logs/alloy-check.txt
    logs/                 Alloy output
  lean/
    lakefile.toml, lean-toolchain
    Hcalc.lean            library root
    Hcalc/                RealStub, Carrier, Foundry, Axioms,
                          Pipeline, Convergence, Invariants, Production
  j/
    hcalc.ijs             production Core verbs (locale hcalc)
  verify/
    run.sh, run.ijs       jconsole harness entry
    harness.ijs, core_load.ijs, tests/props.ijs
    PROPERTY_MAP.md       harness ids and their meaning
    logs/                 timestamped harness runs
  docs/
    INVARIANTS.md         Alloy-to-Lean invariant map
    REMAINING.md          historical list of open Lean items
```

---

## 7. The five layers

### 7.1 Specification (`spec/`)

`PRODUCTION.md` is the single source of truth. It closes each historical design gap (carrier, transform, governor, stabilizer, evolution operator, shape map, contraction algorithm, convergence, objective) by *definition* rather than by opaque axiom, and records a disposition table saying what each downstream layer must do with each definition. The other files in `spec/` record earlier axiom-level statements and cross-references; where they disagree with `PRODUCTION.md`, `PRODUCTION.md` wins.

### 7.2 Alloy (`alloy/`)

The Alloy model is a bounded relational rendering of the object. Signatures cover time, state, the prime carrier, transforms, stabilization, contraction, evolution, optimization, and convergence. A set of gap-record singletons carries a `DefStatus` that must be `SpecDefined` for every production symbol, so an undefined placeholder cannot survive silently.

Three families of assertions are checked; each must be **UNSAT** (no counterexample in scope) to pass:

- **A1–A7**: structural properties sealed from the property map — prime-carrier cardinality and distinctness, Gershgorin contractivity, governor activation over margin, additive shape confined to Foundry instances, PMAT conservation gating, guardian rejection, and the production-defined records.
- **P1–P8**: one check per production definition — carrier, diagonal transform, scale-or-identity governor, scalar stabilizer bound, uniform affine evolution, bridge morphism, residual objective, and the Gershgorin-then-governor contraction algorithm.
- **INV_***: cross-module invariants such as prime-index boundedness, measure non-increase under contraction, totality of evolution on states, and production convergence hypotheses.

Two `run` commands (`show_hcalc_trace`, `show_foundry_trace`) are expected to be **SAT**: they exhibit instances and confirm the model is not vacuous. Scopes are small (typically `for 5 but 8 Int`); an UNSAT result is a statement about that bound, not an unbounded proof.

### 7.3 Lean 4 (`lean/`)

The Lean project `Hcalc` targets `leanprover/lean4:v4.34.1`. The committed `lakefile.toml` declares no dependencies and `lake-manifest.json` lists no packages, so the production cut builds without Mathlib. Real arithmetic is supplied by `Hcalc/RealStub.lean`, which introduces an opaque type `Real` with the operations and elementary laws the proofs need as axioms. (The file `lean/README.md` describes a Mathlib-backed variant; the committed build does not use it.)

On top of that stub:

- `Carrier.lean` defines `Carrier n := Fin n → Real`, vector operations, and $\ell_\infty$.
- `Foundry.lean` defines $P_{64}$ as a concrete list with decided facts (length 64, $P_{64}(0) = 2$, $P_{64}(63) = 311$), the Gershgorin bound, and Foundry's additive `FoundryStep` over an opaque Foundry state.
- `Axioms.lean` — despite its historical name — contains *definitions*: `Tp`, `C`, `LambdaM`, `Xi`, the objective, the contraction algorithm, `InstanceBridge`, and `toFoundryStep`.
- `Pipeline.lean` defines the nested `step`, `J`, `optimize`, and the stop predicate, with `step_eq_stabilized` showing the uniform zero-kick reduction.
- `Convergence.lean` contains the L5 results summarized in §4.

The production definitions and theorems contain no `sorry` and no `admit`. The trusted base consists of the infrastructure axioms: 55 top-level `axiom` declarations (47 in `RealStub.lean`, 6 in `Foundry.lean` for the opaque Foundry state and norms, 2 in `Carrier.lean` for $\ell_\infty$ facts). Replacing the stub with Mathlib's real numbers is the obvious way to shrink that base.

### 7.4 J Core (`j/hcalc.ijs`)

The executable core lives in locale `hcalc` and implements exactly the verbs named in the specification:

| Verb | Specification | Role |
|---|---|---|
| `tp_from_p64` | §2 | apply $\mathrm{diag}(\alpha)$ |
| `c_wrap` | §3 | state scale-or-identity, using `q_of_tp` and `soft_project_scale` |
| `lam_m_from_bound` | §4 | scalar $\Lambda_m$ from the operator-norm bound |
| `hcalc_xi_apply` | §5 | $\xi_t \cdot y + g_t$ |
| `hcalc_step` | §5 | one nested step |
| `hcalc_run` | §9 | iterate until $J < \mathrm{tol}$ or a step cap |
| `to_foundry_step_diagnostic` | §6, Option B | additive diagnostic; never used as the step |

The core reads two things from Foundry: the prime list `P64` and the spectral estimator `spectral_analyze`, which it uses to compute $q$ on $\mathrm{diag}(\alpha)$. It never calls Foundry's `soft_project` or `rec_step`. Defaults are `EPS_DEFAULT = 0.05`, `DELTA_DEFAULT = 1e_12`, `TOL_DEFAULT = 1e_6`, `XI_UNIFORM = 1`, and the bridge tag `'InstanceBridge'`. A companion verb `hcalc_step_info` returns the next state together with $q$, $\varepsilon$, $\Lambda_m$, $\xi$, the residual, and the bridge tag, for inspection.

### 7.5 Verify (`verify/`)

The harness is a jconsole program that loads the core, reads `PRODUCTION.md`, the Alloy model, and the Lean sources, and emits one line per property: `PASS`, `FAIL`, `SKIP` with a reason, or `BLOCKED` with a reason. It is fail-open in the strict sense: the core is loaded only from `j/hcalc.ijs` (never from Foundry); a missing core or a failed load is reported as `FAIL H-CORE-LOAD`; and every property whose evidence is absent evaluates false and is reported as `FAIL`, never as a silent skip.

The checks are of two kinds, and it is important to know which is which:

- **Numeric checks on the core.** On the input $x = (1, 2, 3, 4, 5)$ the harness confirms that $P_{64}$ has 64 entries, every $\alpha_j$ lies in $(0, 1)$, $T_p x = \alpha \cdot x$, the governor matches its scale-or-identity rule, $\Lambda_m \in (0, 1]$ with $\Lambda_m \cdot \lVert C \circ T_p \rVert \le 1 - \varepsilon$, the evolution operator is the identity at default parameters, the nested step differs from the additive diagnostic, and `hcalc_run` converges within 80 steps at tolerance $10^{-6}$.
- **Document probes.** For properties whose authority is a proof or a model (for example `H-L5`, `H-A7`, parts of `H-SHAPE`), the harness checks that the required Lean theorems, Alloy facts, and specification clauses are present in the source files. These probes confirm that the artefacts exist and are wired; the proofs themselves are checked by `lake build`, and the models by the Alloy run.

---

## 8. Building and running

### Prerequisites

| Tool | Used for | Notes |
|---|---|---|
| Java 21 or later | Alloy 6.2.0 CLI | the Alloy JAR is expected at `alloy/tools/org.alloytools.alloy.dist.jar` and is not committed |
| elan with `leanprover/lean4:v4.34.1` | Lean library | no Mathlib needed for the committed cut |
| J 9.7 (`jconsole`) | Core and Verify | the harness defaults to `/home/box/j/j9.7/bin/jconsole`; override with `JCONSOLE` |
| foundry-j checkout | Core cite hooks | `j/hcalc.ijs` loads `/workspace/foundry-j/j/foundry.ijs` |

### Alloy

```bash
cd alloy
./run-production.sh     # per-command checks; writes logs/alloy-check.txt
./run.sh                # all commands in one exec; raw receipt in logs/alloy-out/
```

`run-production.sh` enumerates commands with `java -jar … commands`, executes each with `exec -c NAME`, classifies checks as `UNSAT (PASS)` or `FAIL` and runs as `SAT (instance)`, prints a summary line, and exits non-zero on any failed check. The committed `logs/alloy-check.txt` presents the same per-command results grouped by family (A, P, INV, runs).

### Lean

```bash
export PATH="$HOME/.elan/bin:$PATH"
cd lean
lake build
grep -rn "sorry\|admit" Hcalc Hcalc.lean   # expected: no matches
```

### Verify

```bash
cd verify
./run.sh                # writes logs/run-YYYYMMDD-HHMMSS.log
```

The wrapper records the jconsole path, working directory, Pacific timestamp, and whether the core is present, then runs `run.ijs` and appends the exit code.

---

## 9. Measured results

Every number in this section is copied from a log on disk. Nothing is estimated.

### 9.1 Alloy — `alloy/logs/alloy-check.txt`

Alloy 6.2.0, production check stamped 2026-10-07 09:41 PT.

| Family | Checks | Result |
|---|---|---|
| A1–A7 (including A1b) | 8 | all UNSAT (PASS) |
| P1–P8 | 8 | all UNSAT (PASS) |
| INV_* | 10 | all UNSAT (PASS) |
| optional runs | 2 | both SAT (instance found, as expected) |

Summary line: `checks_UNSAT_PASS=26 checks_FAIL=0 runs_SAT=2`.

### 9.2 Lean — `lean/build.log`

`lake build` completes with `Build completed successfully`. A search of `Hcalc/` and `Hcalc.lean` for `sorry` and `admit` returns nothing. The production cut therefore has **0 `sorry`**; its trusted base is the infrastructure axioms described in §7.3.

### 9.3 Verify — `verify/logs/run-20261007-093828.log`

J 9.7.1, run stamped 2026-10-07 09:38:28 PDT.

```
PASS=15 FAIL=0 SKIP=3 BLOCKED=0
exit_code=0
```

| Harness id | Result |
|---|---|
| H-A1, H-A2, H-A3, H-A4, H-A7 | PASS |
| H-SHAPE, H-L5, H-NEST | PASS |
| SKIP-ShapeBridge, SKIP-Λm-formula, SKIP-C-instep, SKIP-Tp-law, SKIP-Ξ-op, SKIP-OptObj, SKIP-L5-proof | PASS (registry names for gaps now closed by definition) |
| H-A5 | SKIP — PMAT is not used on the production core path |
| H-A6 | SKIP — no guardian verb exists in the core yet |
| SKIP-Goldilocks16 | SKIP — the harness declines to lift Foundry's Fermat-inverse property into HCALC |

On the last line: the HCALC production carrier is $\mathbb{R}^n$, so no Goldilocks field property is needed on the production path. The reason string in the harness still cites an earlier Foundry failure of property 16; the current foundry-j log (`verify/logs/run-20261007-080122.log` in that repository) records `PASS prop_16`. The SKIP stands either way, because HCALC makes no claim that depends on it.

`verify/PROPERTY_MAP.md` also documents an earlier run (`run-20261007-093541.log`, PASS=9, SKIP=9) from before the SKIP-registry entries were converted into measured checks; the run above is the current one.

---

## 10. Relationship to sibling repositories

| Repository | Relationship |
|---|---|
| [foundry-j](https://github.com/AHMADALIPARR/foundry-j) | Pure-J math cores of Foundry F1: Goldilocks field, PMAT, spectral governor, additive Banach recurrence. HCALC cites `P64` and `spectral_analyze` from it and evaluates the additive shape only through the `InstanceBridge` diagnostic. foundry-j does **not** define $\Lambda_m$, $\Xi$, $C$, or $T_p$ in the HCALC sense, and its verification does not certify HCALC. |
| [sedona-k](https://github.com/AHMADALIPARR/sedona-k) | Layer-1 Riemann-gas thermodynamics over the same $P_{64}$ in ngn/k. It shares the prime spectrum but none of the recurrence machinery. |
| [david](https://github.com/AHMADALIPARR/david) | An unrelated product (sparse agent routing in J, PostgreSQL/pgvector, and Prolog). It shares only the J toolchain and the licensing posture. |

---

## 11. Limitations and out of scope

- **Bounded models.** Alloy results hold within the declared scopes. They catch specification errors cheaply; they are not unbounded proofs.
- **Axiomatized reals.** The Lean trusted base includes an axiomatic `Real`. Results are as sound as those axioms. A Mathlib port would remove most of them.
- **No convergence rate in Lean.** The library proves uniqueness of the fixed point and identifies it; it does not prove that the iterates converge or bound how fast.
- **Hard-coded paths.** The core loads Foundry from an absolute path, and the harness reads the core, specification, Alloy model, and Lean sources from absolute paths under `/workspace`; a portable loader is not provided.
- **Document probes are not proofs.** Several harness properties confirm the presence of theorems and clauses, not their validity; validity comes from `lake build` and the Alloy run.
- **Optional surfaces.** PMAT conservation (A5) and the guardian (A6) are modelled in Alloy but have no production core verbs; the harness skips them rather than inventing passes.
- **Not in this repository:** the Goldilocks-field carrier instance, Foundry's audit, seal, gate, and certification machinery, any product or service wrapper, and continuous-integration workflows.

---

## 12. License

Copyright © 2026 HCALC contributors.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, **version 3 only**. See [`LICENSE`](LICENSE). SPDX identifier: `AGPL-3.0-only`.
