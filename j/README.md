<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC J production verbs

**Owner:** Foundry J Core (implements) / HCALC Spec (formulas in `../spec/PRODUCTION.md`).  
**Path (authoritative):** `/workspace/hcalc/j/`

Implement: `tp_from_p64`, `c_wrap`, `lam_m_from_bound`, `hcalc_xi_apply`, `hcalc_step`, `hcalc_run`  
per PRODUCTION.md. Cite Foundry hooks; do **not** equate `hcalc_step` with `rec_step` (InstanceBridge ≠ identity).
