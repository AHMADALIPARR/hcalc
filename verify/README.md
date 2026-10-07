<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Verify

**Owner:** Verify. **License:** AGPL-3.0-only.  
**Map:** [`PROPERTY_MAP.md`](PROPERTY_MAP.md) ← [`../spec/PROPERTIES.md`](../spec/PROPERTIES.md) + [`../spec/PRODUCTION.md`](../spec/PRODUCTION.md).  
**Core:** `../j/hcalc.ijs`.

## Run

```bash
./run.sh   # jconsole; writes logs/run-*.log
```

Latest measured: `logs/run-20261007-093541.log` — **PASS=9 FAIL=0 SKIP=9 BLOCKED=0**.

## Policy

Measured PASS only. No fake PASS. SKIP-Goldilocks16 remains (Foundry prop 16). Registry SKIP rows document closure pointing at H-* PASS.
