<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC J production Core

**Owner:** Foundry J Core (implements) / HCALC Spec (`../spec/PRODUCTION.md`).  
**Path (authoritative):** `/workspace/hcalc/j/`  
**Locale:** `hcalc` (load `hcalc.ijs`).

## Verbs (PRODUCTION.md)

| Verb | Role |
|------|------|
| `tp_from_p64` | Diagonal Tp from P64 α (**spec-def**) |
| `c_wrap` | State scale-or-id (**spec-adapt**; ≠ Foundry soft_project **43**) |
| `lam_m_from_bound` | Scalar Λm from op-norm bound |
| `hcalc_xi_apply` | Ξ(t,y)=ξ·y+g |
| `hcalc_step` | NestedFaithful one step (**≠** `rec_step`) |
| `hcalc_run` | Iterate until residual &lt; tol |

InstanceBridge parameter table is diagnostic (`instance_bridge_table`) for **FoundryAdditive** mode — never `rfl` / never NestedFaithful ≡ prop **39**.

## Smoke

```bash
/home/box/j/j9.7/bin/jconsole -js "load 'hcalc.ijs'" "cocurrent 'hcalc'" "echo smoke ''" "exit ''"
```
