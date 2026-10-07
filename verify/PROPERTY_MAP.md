<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Verify — PROPERTY_MAP

Authoritative names: [`../spec/PROPERTIES.md`](../spec/PROPERTIES.md) **PROPERTY_MAP**.  
Log: `logs/run-20261007-090900.log` (PT).

Statuses below are **scaffold** only: **SKIP** / **BLOCKED** until HCALC Core exists and GapIds discharge. **Zero PASS** claimed here. Foundry props are cite-only.

## H-* properties

| id | check | status | harness id | reason / GapId |
|----|-------|--------|------------|----------------|
| H-A1 | A | **SKIP** | `H-A1` | Gap-Tp-from-P64 / no HCALC Core; Foundry P64 cite-only |
| H-A2 | B | **SKIP** | `H-A2` | no HCALC Core; Foundry spectral (33–34) cite-only |
| H-A3 | B/C | **SKIP** | `H-A3` | no HCALC Core; Foundry soft_project (43) cite-only |
| H-A4 | C | **SKIP** | `H-A4` | Gap-ShapeMap / no instance tag without HCALC Core; Foundry rec_step cite-only |
| H-A5 | A/E | **SKIP** | `H-A5` | PMAT unused / no HCALC Core; Foundry pmat_compose cite-only |
| H-A6 | B | **SKIP** | `H-A6` | no HCALC Core; Foundry guardian (55) cite-only |
| H-A7 | E | **SKIP** | `H-A7` | A7 definition-record absent: Gap-Λm-scalar, Gap-Ξ, Gap-C-wrapper, Gap-Tp-from-P64; no HCALC Core |
| H-SHAPE | C | **BLOCKED** | `H-SHAPE` | SKIP-ShapeBridge (L7 BLOCKED) / Gap-ShapeMap; additive ≠ nested |
| H-L5 | E | **SKIP** | `H-L5` | SKIP-L5-proof / L5 unfinished; Foundry prop 41 narrative cite-only |
| H-NEST | C | **SKIP** | `H-NEST` | L6 gaps (Λm, Ξ, C, Tp undefined); nested numeric tests deferred |

## SKIP registry (harness-visible)

| SKIP name | status | reason |
|-----------|--------|--------|
| SKIP-ShapeBridge | **SKIP** | Gap-ShapeMap / L7 blocked; additive ≠ nested |
| SKIP-Λm-formula | **SKIP** | Gap-Λm-scalar; no scalar formula |
| SKIP-C-instep | **SKIP** | Gap-C-wrapper; Foundry tests are post-hoc |
| SKIP-Tp-law | **SKIP** | Gap-Tp-from-P64; P_64 is index set only |
| SKIP-Ξ-op | **SKIP** | Gap-Ξ; schedule ≠ operator |
| SKIP-OptObj | **SKIP** | Gap-OptObj undefined |
| SKIP-L5-proof | **SKIP** | L5 unfinished |
| SKIP-Goldilocks16 | **SKIP** | Foundry prop **16** FAIL — do not claim PASS lift |

## Scaffold summary (expected before Core)

| Status | Count |
|--------|------:|
| PASS | **0** |
| FAIL | **0** |
| SKIP | **17** (9 H-* + 8 registry; H-SHAPE is BLOCKED not SKIP) |
| BLOCKED | **1** (`H-SHAPE`) |

H-* SKIP count in the H-* table is 9; plus 8 registry rows = 17 SKIP lines; H-SHAPE = BLOCKED.

## Notes

1. Do not load Foundry to invent HCALC PASS.
2. Do not invent Λm / Ξ / C / Tp formulas.
3. Update this table only from a real measured `logs/run-*.log` when Core lands.
