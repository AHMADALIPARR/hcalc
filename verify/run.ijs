NB. Copyright (C) 2026 HCALC contributors
NB. SPDX-License-Identifier: AGPL-3.0-only
NB. HCALC Verify — measured harness (PRODUCTION.md + Core /workspace/hcalc/j/).

13!:0 ] 0

echo 'HCALC — Verification Harness'
echo '═══════════════════════════════════════'
echo 'jconsole: ' , 9!:14 ''
echo 'core: /workspace/hcalc/j/hcalc.ijs (HCALC Core; Foundry cite-only)'
echo 'rule: FAIL-open; InstanceBridge witness ≠ identity; no Foundry-as-Core'
echo ''

load 'harness.ijs'
load 'core_load.ijs'

echo 'PRODUCTION.md present: ' , ": 0 < # prod_text ''
echo 'Core present: ' , ": core_available ''
echo ''

echo '── H-* properties + SKIP registry ──'
load 'tests/props.ijs'

harness_finish ''
