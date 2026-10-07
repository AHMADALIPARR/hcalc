<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Alloy (PRODUCTION)

**Owner:** HCALC Alloy agent.  
**License:** AGPL-3.0-only.  
**Authority:** [`../spec/PRODUCTION.md`](../spec/PRODUCTION.md).

Encode sealed asserts **A1–A7** (A7 = SpecDefined) and production **P1–P8** from PRODUCTION.md.

ShapeMap = **InstanceBridge** morphism — do **not** equate Foundry additive prop 39 with HCALC nested form. Spec C = scale-or-id; SoftProject/A3 remains Foundry schedule soft_project cite-only.

## Run

```bash
PATH=/usr/bin:$PATH
./run.sh
# or:
java -jar tools/org.alloytools.alloy.dist.jar exec -f -o logs/alloy-out -t text -q HCALC.als
```

Requires Java 21+. Vendored JAR: `tools/org.alloytools.alloy.dist.jar` (AlloyTools 6.2).
