<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Verify — PROPERTY_MAP

Authoritative names: [`../spec/PROPERTIES.md`](../spec/PROPERTIES.md) **PROPERTY_MAP**.  
Log: `logs/run-20261007-093541.log` (PT).  
Production: [`../spec/PRODUCTION.md`](../spec/PRODUCTION.md). Core: `../j/hcalc.ijs`.

## Measured H-* properties

| id | check | status | harness id | evidence |
|----|-------|--------|------------|----------|
| H-A1 | A | **PASS** | `H-A1` | `#P64_foundry_=64`; first/last primes |
| H-A2 | B | **PASS** | `H-A2` | `q_of_tp = max|α|` on diag |
| H-A3 | B/C | **PASS** | `H-A3` | `soft_project_scale` state scale-or-id (≠ soft_project **43**) |
| H-A4 | C | **PASS** | `H-A4` | NestedFaithful `hcalc_step` ≠ `to_foundry_step_diagnostic` |
| H-A5 | A/E | **SKIP** | `H-A5` | PMAT unused in production ℝ path |
| H-A6 | B | **PASS** | `H-A6` | Spec q < 1 for production α |
| H-A7 | E | **PASS** | `H-A7` | Core verbs present (SpecDefined surface) |
| H-SHAPE | C | **PASS** | `H-SHAPE` | InstanceBridge ≠ rfl; diagnostic ≠ nested |
| H-L5 | E | **PASS** | `H-L5` | `hcalc_run` converged under NestedFaithful |
| H-NEST | C | **PASS** | `H-NEST` | residual shrink / converge |

## SKIP registry (stable names; mostly closed-doc)

| SKIP name | status | reason |
|-----------|--------|--------|
| SKIP-ShapeBridge | **SKIP** | closed — see H-SHAPE |
| SKIP-Λm-formula | **SKIP** | closed — see lam_m_from_bound |
| SKIP-C-instep | **SKIP** | closed — see H-A3 |
| SKIP-Tp-law | **SKIP** | closed — see H-A1/H-A2 |
| SKIP-Ξ-op | **SKIP** | closed — see hcalc_xi_apply |
| SKIP-OptObj | **SKIP** | closed — see H-NEST |
| SKIP-L5-proof | **SKIP** | closed — see H-L5 |
| SKIP-Goldilocks16 | **SKIP** | Foundry prop **16** FAIL — do not claim PASS lift |

## Measured summary (`logs/run-20261007-093541.log`)

| Status | Count |
|--------|------:|
| PASS | **9** |
| FAIL | **0** |
| SKIP | **9** (H-A5 + 8 registry) |
| BLOCKED | **0** |
| exit_code | **0** |

## Notes

1. Do not load Foundry to invent HCALC PASS (Core may cite-load for P64/spectral).
2. C is Spec state scale-or-id (`spec-adapt`); ≠ Foundry soft_project **43**.
3. InstanceBridge ≠ NestedFaithful ≡ prop **39**.
