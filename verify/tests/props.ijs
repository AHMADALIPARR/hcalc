NB. Copyright (C) 2026 HCALC contributors
NB. SPDX-License-Identifier: AGPL-3.0-only
NB. HCALC property stubs — SKIP/BLOCKED until HCALC Core + Gap discharge.
NB. Reasons match spec/PROPERTIES.md SKIP registry and spec/AXIOMS.md GapIds.
NB. Do not load Foundry; do not invent Λm/Ξ/C/Tp formulas; no fake PASS.

run_props =: 3 : 0
  NB. ── H-* PROPERTY_MAP stubs ─────────────────────────────────────────────
  'Gap-Tp-from-P64 / no HCALC Core; Foundry P64 cite-only' skip 'H-A1'
  'no HCALC Core; Foundry spectral (33–34) cite-only' skip 'H-A2'
  'no HCALC Core; Foundry soft_project (43) cite-only' skip 'H-A3'
  'Gap-ShapeMap / no instance tag without HCALC Core; Foundry rec_step cite-only' skip 'H-A4'
  'PMAT unused / no HCALC Core; Foundry pmat_compose cite-only' skip 'H-A5'
  'no HCALC Core; Foundry guardian (55) cite-only' skip 'H-A6'
  'A7 definition-record absent: Gap-Λm-scalar Gap-Ξ Gap-C-wrapper Gap-Tp-from-P64; no HCALC Core' skip 'H-A7'
  'SKIP-ShapeBridge (L7 BLOCKED) / Gap-ShapeMap; additive ≠ nested' blocked 'H-SHAPE'
  'SKIP-L5-proof / L5 unfinished; Foundry prop 41 narrative cite-only' skip 'H-L5'
  'L6 gaps (Λm Ξ C Tp undefined); nested numeric tests deferred' skip 'H-NEST'

  NB. ── SKIP registry (harness-visible names) ──────────────────────────────
  'Gap-ShapeMap / L7 blocked; additive ≠ nested' skip 'SKIP-ShapeBridge'
  'Gap-Λm-scalar; no scalar formula' skip 'SKIP-Λm-formula'
  'Gap-C-wrapper; Foundry tests are post-hoc' skip 'SKIP-C-instep'
  'Gap-Tp-from-P64; P_64 is index set only' skip 'SKIP-Tp-law'
  'Gap-Ξ; schedule ≠ operator' skip 'SKIP-Ξ-op'
  'Gap-OptObj undefined' skip 'SKIP-OptObj'
  'L5 unfinished' skip 'SKIP-L5-proof'
  'Foundry prop 16 FAIL — do not claim PASS lift' skip 'SKIP-Goldilocks16'
)

run_props ''
