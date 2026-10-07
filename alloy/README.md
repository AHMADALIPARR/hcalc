<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HCALC Alloy

**Owner:** HCALC Alloy agent.

Encode finite asserts **A1–A7** and coherence invariants from:

- [`../spec/COHERENCE.md`](../spec/COHERENCE.md)
- [`../spec/INTERFACES.md`](../spec/INTERFACES.md)
- [`../spec/AXIOMS.md`](../spec/AXIOMS.md)
- [`../spec/FOUNDRY_J_CROSSLINKS.md`](../spec/FOUNDRY_J_CROSSLINKS.md)

Use Provenance tags: `source-claim` | `axiom-gap` | `derived`, keyed by A*/Gap-*.

Do not put marketing here. Do not invent formulas for Λm, HCALC-Ξ, C, or T_p (A7 gate only). Do not equate Foundry additive prop 39 with HCALC nested form (Gap-ShapeMap).


## Alloy Analyzer CLI

Vendored JAR path (gitignored, ~21 MB): `tools/org.alloytools.alloy.dist.jar` (AlloyTools 6.2).

```bash
mkdir -p tools
curl -L -o tools/org.alloytools.alloy.dist.jar   https://github.com/AlloyTools/org.alloytools.alloy/releases/download/v6.2.0/org.alloytools.alloy.dist.jar
# or any AlloyTools 6.2 dist jar
./run.sh
```

Requires Java 21+. Headless: `java -jar tools/org.alloytools.alloy.dist.jar exec …` (GUI needs a display).
