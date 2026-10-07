NB. Copyright (C) 2026 HCALC contributors
NB. SPDX-License-Identifier: AGPL-3.0-only
NB. Load HCALC Core from /workspace/hcalc/j/ only (not Foundry-as-Core).
NB. Foundry is cite-only: Core may call Foundry hooks; we preload Foundry
NB. cwd-safe because Core's hcalc_ensure_foundry reloads via 4!:3 while
NB. hcalc.ijs is top script (would resolve types.ijs under hcalc/j).

CORE_LOADED =: 0
CORE_PATH   =: '/workspace/hcalc/j/hcalc.ijs'
PROD_PATH   =: '/workspace/hcalc/spec/PRODUCTION.md'
ALLOY_ALS   =: '/workspace/hcalc/alloy/HCALC.als'
LEAN_AXIOMS =: '/workspace/hcalc/lean/Hcalc/Axioms.lean'
LEAN_CONV   =: '/workspace/hcalc/lean/Hcalc/Convergence.lean'
LEAN_FOUND  =: '/workspace/hcalc/lean/Hcalc/Foundry.lean'
FOUNDRY_DIR =: '/workspace/foundry-j/j'

fexist =: 3 : '0 ~: # (1!:0 :: (''"_'')) < y'

core_available =: 3 : 0
  fexist CORE_PATH
)

fread_text =: 3 : 0
  p =. fread y
  if. p -: _1 do. '' else. p end.
)

prod_text =: 3 : 'fread_text PROD_PATH'
alloy_text =: 3 : 'fread_text ALLOY_ALS'
lean_axioms_text =: 3 : 'fread_text LEAN_AXIOMS'
lean_conv_text =: 3 : 'fread_text LEAN_CONV'
lean_found_text =: 3 : 'fread_text LEAN_FOUND'

has_substr =: 4 : 'x +./@E. y'

load_hcalc_core =: 3 : 0
  if. CORE_LOADED do. 1 return. end.
  if. -. core_available '' do. 0 return. end.
  if. -. fexist FOUNDRY_DIR , '/foundry.ijs' do. 0 return. end.
  cur =. 1!:43 ''
  1!:44 FOUNDRY_DIR
  load 'foundry.ijs'
  1!:44 cur
  src =. fread CORE_PATH
  if. src -: _1 do. 0 return. end.
  src =. ('hcalc_ensure_foundry ''''''';'NB. verify: Foundry preloaded — skip ensure') stringreplace src
  0!:0 src
  CORE_LOADED =: 1
  1
)
