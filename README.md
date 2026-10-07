<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC

Nested abstract dynamics for a coherence research object:

\[
X_{t+1} = \Xi\bigl(t,\; \Lambda_m \cdot C[T_p(X_t)]\bigr).
\]

Prose definitions live in `spec/`. Finite relational checks live in `alloy/`.
A Lean 4 library lives in `lean/`. Production J verbs live in `j/`. The
verify harness scores Core properties against `spec/PRODUCTION.md`.

This is **not** a product narrative and **not** a silent identification with
Foundry’s additive Banach step \(x'=\Xi x+\Lambda T(x)+g\). Spec records an
`InstanceBridge` with dual modes; the two shapes are not equated.

## Quick start

```bash
# Alloy (Java 21+; JAR under alloy/tools/)
cd alloy && ./run.sh          # writes logs/alloy-check.txt

# Lean 4 (elan; toolchain leanprover/lean4:v4.34.1)
export PATH="$HOME/.elan/bin:$PATH"
cd lean && lake build

# Verify (jconsole)
cd verify && ./run.sh
```

## Measured results

| Gate | Source | Result |
|------|--------|--------|
| Alloy production | `alloy/logs/alloy-check.txt` | 26 UNSAT (PASS), 0 FAIL; 2 optional SAT instance runs |
| Lean | `lean/build.log` | `lake build` completed; production cut has **0 `sorry`** |
| Verify | `verify/logs/run-20261007-093828.log` | **PASS=15 FAIL=0 SKIP=3 BLOCKED=0** |

Verify SKIP lines are only PMAT unused on the Core path (H-A5), no Core
guardian verb (H-A6), and Goldilocks16 cite-only (SKIP-Goldilocks16).

Production formulas and Gap disposition: [`spec/PRODUCTION.md`](spec/PRODUCTION.md).
Do not treat the gap map as runtime status theater.

## Layout

```
hcalc/
  LICENSE                 AGPL-3.0-only
  README.md
  spec/                   PRODUCTION.md, axioms, interfaces, crosslinks
  alloy/                  HCALC.als, modules/, run.sh, logs/
  lean/                   Lake project Hcalc (Lean 4)
  j/                      production Core verbs
  verify/                 jconsole harness, PROPERTY_MAP, logs/
  docs/                   Alloy↔Lean invariant map, remaining Lean notes
```

## Alloy

Finite signatures for time, state, P64, transforms, stabilization,
contraction, evolution, optimization, and convergence. Asserts A1–A7 and
INV_* must be UNSAT to pass. Optional `show_*` commands are SAT instance
runs.

```bash
cd alloy && ./run.sh
# or:
java -jar tools/org.alloytools.alloy.dist.jar exec -f -o logs/alloy-out -t text HCALC.als
```

## Lean

Project `Hcalc`, Lean 4 **v4.34.1**, no Mathlib in the production cut (opaque
`Real` stub). Prefer definitions from PRODUCTION; state convergence only
under hypotheses.

```bash
export PATH="$HOME/.elan/bin:$PATH"
cd lean && lake build
```

## Verify

`verify/run.sh` launches `run.ijs` against Core. FAIL-open: missing Core /
PRODUCTION, Alloy-style identity claims, or Foundry-as-Core load fail the
gate. See `verify/PROPERTY_MAP.md`.

## Related

- **foundry-j** — pure-J Goldilocks / PMAT / spectral / recurrence cores
  (instantiation hooks, not HCALC definitions of \(\Lambda_m\)/\(\Xi\)/\(C\)/\(T_p\))
- **sedona-k** — Layer-1 \(P_{64}\) Riemann-gas thermo in ngn/k

## License

Copyright © 2026 HCALC contributors. GNU Affero General Public License
**v3.0 only** — see [`LICENSE`](LICENSE). SPDX: `AGPL-3.0-only`.
