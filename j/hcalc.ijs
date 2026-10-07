NB. =============================================================================
NB. HCALC — Production Core verbs (PURE J)
NB. Copyright (C) 2026 HCALC contributors
NB.
NB. This program is free software: you can redistribute it and/or modify
NB. it under the terms of the GNU Affero General Public License as published
NB. by the Free Software Foundation, version 3 of the License.
NB.
NB. This program is distributed in the hope that it will be useful,
NB. but WITHOUT ANY WARRANTY; without even the implied warranty of
NB. MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
NB. GNU Affero General Public License for more details.
NB.
NB. You should have received a copy of the GNU Affero General Public License
NB. along with this program.  If not, see <https://www.gnu.org/licenses/>.
NB. SPDX-License-Identifier: AGPL-3.0-only
NB. =============================================================================
NB.
NB. Formulas: ../spec/PRODUCTION.md ONLY (exact).
NB. Path: /workspace/hcalc/j/  (NOT foundry-j/j/)
NB. Cite Foundry: P64, spectral_analyze (load foundry-j). softProjectScale idea
NB.   from soft_project prop43 — do NOT call soft_project on (xi;lam) for C.
NB. ShapeMap = InstanceBridge (parameter table). hcalc_step ≠ rec_step / Foundry39.
NB.
NB. Verbs: tp_from_p64  c_wrap  lam_m_from_bound  hcalc_xi_apply
NB.        hcalc_step  hcalc_run
NB. Locale: hcalc

cocurrent 'hcalc'

NB. ── Defaults (PRODUCTION parameters) ────────────────────────────────────────
EPS_DEFAULT   =: 0.05        NB. tier T2
DELTA_DEFAULT =: 1e_12
TOL_DEFAULT   =: 1e_6
XI_UNIFORM    =: 1.
BRIDGE_MODE   =: 'InstanceBridge'

NB. Load Foundry cite hooks (idempotent)
hcalc_ensure_foundry =: 3 : 0
  NB. 4!:0 returns _1 if undefined; 0 if noun
  if. _1 = 4!:0 <'P64_foundry_' do.
    load '/workspace/foundry-j/j/foundry.ijs'
  end.
  cocurrent 'hcalc'
  i. 0 0
)
hcalc_ensure_foundry ''
cocurrent 'hcalc'

NB. ── Helpers ─────────────────────────────────────────────────────────────────

NB. tp_alpha n — α_j = 1 / (1 + ln p_{j mod 64})   [PRODUCTION §2]
NB. Use dyadic 1%z (not monadic %z) for clear RTL.
tp_alpha =: 3 : 0
  n =. <. 0 ". ": y
  if. n < 1 do. 0 $ 0. return. end.
  primes =. (64 | i. n) { P64_foundry_
  z =. 1 + ^. primes
  1 % z
)

NB. diag_from_alpha α — D(Tp)=diag(α)
diag_from_alpha =: 3 : 0
  a =. , y
  n =. # a
  if. 0 = n do. 0 0 $ 0. return. end.
  a * =/~ i. n
)

NB. soft_project_scale q,eps — s=(1-ε)/q if q>1-ε else 1
NB. Numeric softProjectScale (PRODUCTION §3). NOT Foundry soft_project verb.
soft_project_scale =: 3 : 0
  'q eps' =. 2 {. (, y) , 0 , EPS_DEFAULT
  target =. 1 - eps
  if. q > target do. target % q else. 1. end.
)

NB. q_of_tp n,eps — ‖D(Tp)‖_est via Foundry spectral_analyze on diag(α)
q_of_tp =: 3 : 0
  'n eps' =. 2 {. (, y) , 1 , EPS_DEFAULT
  n =. <. 0 ". ": n
  a =. tp_alpha n
  J =. diag_from_alpha a
  sr =. J spectral_analyze_foundry_ eps
  sr_radius_foundry_ sr
)

NB. c_op_norm n,eps — ‖C∘Tp‖_op = max_j |s·α_j| (diagonal)
c_op_norm =: 3 : 0
  'n eps' =. 2 {. (, y) , 1 , EPS_DEFAULT
  n =. <. 0 ". ": n
  a =. tp_alpha n
  q =. q_of_tp n , eps
  s =. soft_project_scale q , eps
  >./ | (s * a)
)

NB. residual_linf — ‖x-y‖_∞
residual_linf =: 4 : '>./ | (,x) - ,y'

NB. ── 1. tp_from_p64  (PRODUCTION §2) ─────────────────────────────────────────
NB. Monad: tp_from_p64 x → Tp(x)
tp_from_p64 =: 3 : 0
  xv =. , >^:L. y
  a =. tp_alpha # xv
  a * xv
)

NB. ── 2. c_wrap  (PRODUCTION §3) ──────────────────────────────────────────────
NB. Scales the STATE vector: C(x)=s·x. Does NOT call Foundry soft_project.
NB. Monad: c_wrap x (ε=T2).  Dyad: eps c_wrap x
c_wrap =: 3 : 0
  EPS_DEFAULT c_wrap y
:
  eps =. x
  xv =. , >^:L. y
  n =. # xv
  if. 0 = n do. xv return. end.
  q =. q_of_tp n , eps
  s =. soft_project_scale q , eps
  s * xv
)

NB. ── 3. lam_m_from_bound  (PRODUCTION §4) ────────────────────────────────────
NB. Λm = min(1, (1-ε) / (‖C∘Tp‖_op + δ))
NB. Monad: lam_m_from_bound n.  Dyad: eps lam_m_from_bound n
NB. Also accept boxed (opnorm;eps;delta) for direct bound form.
lam_m_from_bound =: 3 : 0
  EPS_DEFAULT lam_m_from_bound y
:
  eps =. x
  NB. If y is a length≥1 numeric list starting with op-norm (not a plain dim),
  NB. treat as (opn[,eps[,delta]]) when #y>1 or y is boxed.
  if. 32 = 3!:0 y do.
    args =. , > y
    opn =. 0 { args , 0
    if. 1 < # args do. eps =. 1 { args end.
    delta =. 2 { args , DELTA_DEFAULT
  else.
    n =. <. 0 ". ": y
    if. n < 1 do. 0. return. end.
    opn =. c_op_norm n , eps
    delta =. DELTA_DEFAULT
  end.
  1. <. (1 - eps) % (opn + delta)
)

NB. ── 4. hcalc_xi_apply  (PRODUCTION §5) ──────────────────────────────────────
NB. Ξ(t,y)=ξ_t·y+g_t. Default Uniform ξ=1, g=0.
NB. Monad: hcalc_xi_apply y → y
NB. Dyad: (xi;g) hcalc_xi_apply y  or  xi hcalc_xi_apply y
hcalc_xi_apply =: 3 : 0
  , y
:
  xv =. , y
  xb =. boxxopen x
  xi =. 0 ". ": > 0 { xb
  if. 1 < # xb do.
    g =. , > 1 { xb
  else.
    g =. (# xv) $ 0.
  end.
  if. 0 = # g do. g =. (# xv) $ 0. end.
  if. (# g) ~: # xv do. g =. (# xv) $ {. g , 0. end.
  (xi * xv) + g
)

NB. ── 5. hcalc_step  (PRODUCTION nested; ≠ rec_step) ──────────────────────────
NB. X' = Ξ(t, Λm·C(Tp(X))) = ξ·(Λm·C(Tp(X))) + g
NB. Monad: hcalc_step X
NB. Dyad: (eps;xi;g) hcalc_step X
NB. Returns xnext (vector). Info via hcalc_step_info if needed.
NB. bridgeMode=InstanceBridge — NOT FoundryAdditive identity.
hcalc_step =: 3 : 0
  (EPS_DEFAULT ; XI_UNIFORM ; '') hcalc_step y
:
  xv =. , >^:L. y
  xb =. boxxopen x
  eps =. 0 ". ": > 0 { xb , <EPS_DEFAULT
  xi  =. 0 ". ": > 1 { xb , <XI_UNIFORM
  if. 2 < # xb do. g =. , > 2 { xb else. g =. '' end.
  if. 0 = # g do. g =. (# xv) $ 0. end.
  if. (# g) ~: # xv do. g =. (# xv) $ {. g , 0. end.
  n =. # xv
  TpX =. tp_from_p64 xv
  CX  =. eps c_wrap TpX
  lam =. eps lam_m_from_bound n
  mid =. lam * CX
  (xi ; g) hcalc_xi_apply mid
)

NB. hcalc_step_info — same step, returns xnext ; <(q;eps;lam;xi;residual;BRIDGE_MODE)>
hcalc_step_info =: 3 : 0
  (EPS_DEFAULT ; XI_UNIFORM ; '') hcalc_step_info y
:
  xv =. , >^:L. y
  xb =. boxxopen x
  eps =. 0 ". ": > 0 { xb , <EPS_DEFAULT
  xi  =. 0 ". ": > 1 { xb , <XI_UNIFORM
  if. 2 < # xb do. g =. , > 2 { xb else. g =. '' end.
  if. 0 = # g do. g =. (# xv) $ 0. end.
  n =. # xv
  a =. tp_alpha n
  q =. q_of_tp n , eps
  TpX =. a * xv
  s =. soft_project_scale q , eps
  CX =. s * TpX
  lam =. eps lam_m_from_bound n
  mid =. lam * CX
  xnext =. (xi ; g) hcalc_xi_apply mid
  res =. xv residual_linf xnext
  info =. q ; eps ; lam ; xi ; res ; BRIDGE_MODE
  xnext ; <info
)

NB. ── 6. hcalc_run  (PRODUCTION §9) ───────────────────────────────────────────
NB. Iterate until J=‖X-step(X)‖_∞ < tol or max_steps.
NB. Monad: hcalc_run X0
NB. Dyad: (max_steps;tol;eps;xi;g) hcalc_run X0
NB. Returns: x_final ; converged ; steps ; <history>
hcalc_run =: 3 : 0
  (200 ; TOL_DEFAULT ; EPS_DEFAULT ; XI_UNIFORM ; '') hcalc_run y
:
  x0 =. , >^:L. y
  xb =. boxxopen x
  max_steps =. <. 0 ". ": > 0 { xb , <200
  tol       =. 0 ". ": > 1 { xb , <TOL_DEFAULT
  eps       =. 0 ". ": > 2 { xb , <EPS_DEFAULT
  xi        =. 0 ". ": > 3 { xb , <XI_UNIFORM
  if. 4 < # xb do. g =. , > 4 { xb else. g =. '' end.
  if. 0 = max_steps do. max_steps =. 200 end.
  if. 0 = tol do. tol =. TOL_DEFAULT end.
  if. 0 = # g do. g =. (# x0) $ 0. end.

  xc =. x0
  history =. 0 $ a:
  converged =. 0
  steps_done =. 0
  lam =. eps lam_m_from_bound # x0

  for_t. i. max_steps do.
    xnext =. (eps ; xi ; g) hcalc_step xc
    resid =. xc residual_linf xnext
    history =. history , <(t ; resid ; lam)
    xc =. xnext
    steps_done =. t + 1
    if. resid < tol do. converged =. 1 break. end.
  end.

  HCALC_STATE =: xc ; converged ; steps_done ; <history
  HCALC_STATE
)

hcalc_state_x         =: 0 {:: ]
hcalc_state_converged =: 1 {:: ]
hcalc_state_steps     =: 2 {:: ]
hcalc_state_history   =: 3 {:: ]

NB. ── Diagnostic only (PRODUCTION Option B) — NOT equal to hcalc_step ─────────
NB. InstanceBridge parameter table applied to Foundry additive shape:
NB.   toFoundryStep = ξ·x + Λm·(C∘Tp)(x) + g
NB. Nested hcalc_step = ξ·(Λm·C(Tp(x))) + g
NB. Different morphisms; no rfl / no symbol identity.
to_foundry_step_diagnostic =: 3 : 0
  (EPS_DEFAULT ; XI_UNIFORM ; '') to_foundry_step_diagnostic y
:
  xv =. , y
  xb =. boxxopen x
  eps =. 0 ". ": > 0 { xb , <EPS_DEFAULT
  xi  =. 0 ". ": > 1 { xb , <XI_UNIFORM
  if. 2 < # xb do. g =. , > 2 { xb else. g =. '' end.
  if. 0 = # g do. g =. (# xv) $ 0. end.
  n =. # xv
  lam =. eps lam_m_from_bound n
  Tx =. eps c_wrap tp_from_p64 xv
  (xi * xv) + (lam * Tx) + g
)

cocurrent 'base'
