NB. Copyright (C) 2026 HCALC contributors
NB. SPDX-License-Identifier: AGPL-3.0-only
NB. HCALC Verify — scaffold harness (no HCALC Core; no Foundry load).

echo 'HCALC — Verification Harness (scaffold)'
echo '═══════════════════════════════════════'
echo 'jconsole: ' , 9!:14 ''
echo 'core: none (HCALC Core not present; Foundry cite-only)'
echo 'rule: no fake PASS; SKIP/BLOCKED until Core + Gap discharge'
echo ''

load 'harness.ijs'

echo '── H-* properties + SKIP registry ──'
load 'tests/props.ijs'

harness_finish ''
