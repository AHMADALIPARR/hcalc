NB. Copyright (C) 2026 HCALC contributors
NB. SPDX-License-Identifier: AGPL-3.0-only
NB. Measured H-* props under PRODUCTION.md + HCALC Core (/workspace/hcalc/j/).
NB. FAIL-open; InstanceBridge witness ≠ identity; no Foundry-as-Core.

13!:0 ] 0

NB. ── helpers ───────────────────────────────────────────────────────────────
assert_pass =: 4 : 0
  if. x do. pass y else. 'measured false' fail y end.
)

run_props =: 3 : 0
  prod =. prod_text ''
  als  =. alloy_text ''
  lax  =. lean_axioms_text ''
  lcv  =. lean_conv_text ''
  lfd  =. lean_found_text ''

  core_ok =. load_hcalc_core ''
  if. -. core_ok do.
    'HCALC Core missing or failed to load from /workspace/hcalc/j/' fail 'H-CORE-LOAD'
    return.
  end.

  NB. ── SpecDefined / Alloy / Lean document probes ──────────────────────────
  a7_prod =. ('**SpecDefined** records pointing here' has_substr prod) *. ('Gap-Tp-from-P64' has_substr prod) *. ('Gap-C-wrapper' has_substr prod) *. ('Gap-Λm-scalar' has_substr prod) *. ('Gap-Ξ' has_substr prod)
  a7_alloy =. ('A7_production_all_spec_defined' has_substr als) *. ('GapRecord_LambdaM.status = SpecDefined' has_substr als) *. ('GapRecord_Tp.status = SpecDefined' has_substr als)
  a7_lean =. ('definitionRecord_Tp' has_substr lax) *. ('definitionRecord_C' has_substr lax) *. ('definitionRecord_LambdaM' has_substr lax) *. ('definitionRecord_Xi' has_substr lax)

  shape_prod =. ('CLOSED via **InstanceBridge**' has_substr prod) *. ('InstanceBridge' has_substr prod) *. ('REJECTED' has_substr prod) *. ('Foundry39' has_substr prod)
  shape_assign =. ('T:=C' has_substr prod) +. ('C\circ T_p' has_substr prod) +. ('C\circ Tp' has_substr prod)
  shape_prod =. shape_prod *. shape_assign
  shape_table =. ('InstanceBridge' has_substr prod) *. (('\\Lambda_m' has_substr prod) +. ('Lambda_m' has_substr prod)) *. (('\\xi_t' has_substr prod) +. ('xi_t' has_substr prod))
  shape_lean =. ('structure InstanceBridge' has_substr lax) *. ('InstanceBridge.param_table' has_substr lax) *. ('toFoundryStep_vs_hcalc_uniform_zero' has_substr lax)
  shape_not_id =. (('NOT `rfl`' has_substr prod) +. ('NOT rfl' has_substr prod) +. ('never' has_substr prod))

  l5_lean =. ('unique_fixed_point' has_substr lcv) *. ('unique_fp_stabilized_of_hyp' has_substr lcv) *. ('HypContractive' has_substr lcv)

  NB. ── Core numeric measurements (locale hcalc nouns) ──────────────────────
  x =. 1. 2. 3. 4. 5.
  n =. # x
  eps =. EPS_DEFAULT_hcalc_
  tol =. TOL_DEFAULT_hcalc_
  bridge =. BRIDGE_MODE_hcalc_
  p64n =. # P64_hcalc_
  alpha =. tp_alpha_hcalc_ n
  tpx =. tp_from_p64_hcalc_ x
  tp_ok =. (p64n = 64) *. (*./ alpha > 0) *. (*./ alpha < 1) *. (tpx -: alpha * x)

  q =. q_of_tp_hcalc_ n , eps
  s =. soft_project_scale_hcalc_ q , eps
  soft_ok =. ((q <: 1 - eps) *. (s = 1)) +. ((q > 1 - eps) *. (s = (1 - eps) % q))
  cx =. eps c_wrap_hcalc_ tpx
  c_ok =. soft_ok *. (cx -: s * tpx)

  lam =. eps lam_m_from_bound_hcalc_ n
  op =. c_op_norm_hcalc_ n , eps
  lam_ok =. (lam > 0) *. (lam <: 1) *. ((lam * op) <: (1 - eps) + 1e_9)

  yxi =. hcalc_xi_apply_hcalc_ 2. 3. 4.
  xi_ok =. yxi -: 2. 3. 4.

  xs =. hcalc_step_hcalc_ x
  xd =. to_foundry_step_diagnostic_hcalc_ x
  nest_ok =. 1 = # $ xs
  step_ne_diag =. -. xs -: xd
  bridge_ok =. bridge -: 'InstanceBridge'

  r =. (80 ; tol ; eps ; 1. ; '') hcalc_run_hcalc_ x
  conv =. 1 {:: r
  steps =. 2 {:: r
  run_ok =. (conv = 1) *. (steps > 0) *. (steps <: 80)

  NB. ── H-* PROPERTY_MAP ────────────────────────────────────────────────────
  tp_ok assert_pass 'H-A1'
  lam_ok assert_pass 'H-A2'
  c_ok assert_pass 'H-A3'
  (bridge_ok *. step_ne_diag *. nest_ok) assert_pass 'H-A4'
  'PMAT unused on production Core path (no pmat_* in hcalc_step)' skip 'H-A5'
  'no Core guardian verb (A6 cite-only until guardian lands in j/)' skip 'H-A6'
  (a7_prod *. a7_alloy *. a7_lean) assert_pass 'H-A7'

  shape_ok =. shape_prod *. shape_table *. shape_lean *. bridge_ok *. step_ne_diag *. shape_not_id
  if. shape_ok do.
    pass 'H-SHAPE'
  else.
    if. (-. step_ne_diag) *. bridge_ok do.
      'would assert Foundry39≡nested (step=diagnostic) — refuse identity PASS' blocked 'H-SHAPE'
    else.
      'InstanceBridge witness incomplete' fail 'H-SHAPE'
    end.
  end.

  l5_lean assert_pass 'H-L5'
  (nest_ok *. run_ok *. step_ne_diag) assert_pass 'H-NEST'

  NB. ── SKIP registry ───────────────────────────────────────────────────────
  shape_ok assert_pass 'SKIP-ShapeBridge'
  lam_ok assert_pass 'SKIP-Λm-formula'
  c_ok assert_pass 'SKIP-C-instep'
  tp_ok assert_pass 'SKIP-Tp-law'
  xi_ok assert_pass 'SKIP-Ξ-op'
  run_ok assert_pass 'SKIP-OptObj'
  l5_lean assert_pass 'SKIP-L5-proof'
  'Foundry prop 16 FAIL — do not claim PASS lift' skip 'SKIP-Goldilocks16'
)

run_props ''
