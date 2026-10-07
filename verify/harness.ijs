NB. Copyright (C) 2026 HCALC contributors
NB. SPDX-License-Identifier: AGPL-3.0-only
NB. PASS/FAIL/SKIP/BLOCKED helpers for HCALC Verify.
NB. Foundry Core is cite-only — do not load Foundry here to mint HCALC PASS.

cocurrent 'z'

PASS_N  =: 0
FAIL_N  =: 0
SKIP_N  =: 0
BLOCK_N =: 0

pass =: 3 : 0
  PASS_N =: PASS_N + 1
  echo 'PASS ' , y
)

fail =: 4 : 0
  FAIL_N =: FAIL_N + 1
  echo 'FAIL ' , y , ': ' , x
)

skip =: 4 : 0
  SKIP_N =: SKIP_N + 1
  echo 'SKIP ' , y , ': ' , x
)

blocked =: 4 : 0
  BLOCK_N =: BLOCK_N + 1
  echo 'BLOCKED ' , y , ': ' , x
)

harness_finish =: 3 : 0
  echo ''
  echo '═══════════════════════════════════════'
  echo 'PASS=' , (": PASS_N) , ' FAIL=' , (": FAIL_N) , ' SKIP=' , (": SKIP_N) , ' BLOCKED=' , (": BLOCK_N)
  if. FAIL_N > 0 do. 2!:55 ] 1 else. 2!:55 ] 0 end.
)
