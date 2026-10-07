<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Verify (stub)

**Owner:** Verify / Foundry J Verify (harness not written yet).  
**License:** AGPL-3.0-only.

## Gate proposal (Foundry Verify pattern)

Authoritative outline for HCALC: [`../spec/PROPERTIES.md`](../spec/PROPERTIES.md).

Foundry J Verify (cite-only; do not copy bodies into HCALC):

| Artifact | Path under `/workspace/foundry-j/verify/` | Role |
|----------|------------------------------------------|------|
| PROPERTIES | paired with `../spec/PROPERTIES.md` | Numbered math properties |
| PROPERTY_MAP | `PROPERTY_MAP.md` | Authoritative prop↔test map |
| INVENTORY | `INVENTORY.md` | Named tests + PASS/FAIL/SKIP |
| prop_N logs | `logs/` | Per-run evidence |
| Core surface | `../j/foundry.ijs` + `spec/J_API.md` | Verbs under test |

**Policy:** `sorry` (Lean) / Alloy `unsat` failure / missing definition-record (**A7**) ⇒ **SKIP** or **FAIL-open** — never PASS.  
Match Foundry: SKIP registry names + reason; seal Lean↔Alloy↔J when claimed.

## Out of scope for this stub

- Full J harness / `prop_N` scripts for HCALC nested form  
- Closing **G-SHAPE** / L7 without Spec  
- Invented Λm / Ξ / C / Tp formulas  

Do not implement the full harness here. Point Core/Verify work at Foundry first; HCALC Verify inherits the gate once Spec freezes nested-form monitors.
