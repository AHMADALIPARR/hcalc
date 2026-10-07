<!--
  Copyright (C) 2026 HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# HANDOFF — Production close (copy-paste for Alloy / Lean / Verify / Core)

**Authority:** [`PRODUCTION.md`](PRODUCTION.md) @ commit with InstanceBridge + Pass-2 provenance.  
**Do not invent** beyond PRODUCTION / AXIOMS. Spec does not edit `.als` / `.lean` bodies.

---

## Alloy

1. Replace A7 GapRecord status `Undefined` → `SpecDefined` for Λm, Ξ, C, Tp; point comments at PRODUCTION.md.  
2. Encode production preds: Carrier ℝ^n / abstract n; diag Tp α; C scale-or-id; Λm scalar min formula; Ξ = ξ·y+g (Uniform).  
3. Add `bridgeMode ∈ {NestedFaithful, FoundryAdditive}` + `InstanceBridge` param table.  
4. **Forbid** NestedFaithful = Foundry prop-**39** / `rfl` / silent symbol identity.  
5. Keep A1–A6; rewire A3 to Spec q / in-step C (**spec-adapt** ≠ Foundry **43** schedule soft_project).  
6. OptObj = residual \(\ell_\infty\); ContractAlg = Gershgorin→power-iter→scale-or-id.  
7. Re-run `alloy/run.sh`; expect green with SpecDefined A7.

## Lean

1. Replace L6 axioms with **defs**: `Carrier`, `Tp`, `C`, `LambdaM`, `Xi`, `J`.  
2. Unblock L7: `structure InstanceBridge` holding param table; dual-mode theorems — **never** `FoundryStep = hcalcStep` / **never** `rfl`.  
3. L5: theorem under PRODUCTION Hyp (0 sorry).  
4. Keep infra Gap-Real-* / Gap-Foundry-* stubs labeled infra-not-production-gap.  
5. Tag α as **spec-def**; C as **spec-adapt**.  
6. `lake build` exit 0.

## Verify

1. Flip SKIP→PASS where hyps hold (PROPERTY_MAP H-A7, H-SHAPE, H-NEST, H-OPT, H-L5).  
2. H-SHAPE PASS **only** for InstanceBridge witness — never identity PASS.  
3. Note Spec residual \(\ell_\infty\) ≠ Foundry **46** \(\ell_2\).  
4. FAIL-open still if Lean sorry / Alloy unsat / Undefined A7.  
5. Update `verify/PROPERTY_MAP.md` to match `spec/PROPERTIES.md`.

## Core (`/workspace/hcalc/j/`)

1. Implement Option B verbs: `tp_from_p64`, `c_wrap`, `lam_m_from_bound`, `hcalc_xi_apply`, `hcalc_step`, `hcalc_run`.  
2. Cite Foundry hooks (`P64`, `spectral_analyze`, `soft_project`, `q_estimate`, `synth_weights`) — do **not** equate `hcalc_step` with `rec_step`.  
3. Expose `toFoundryStep` only as FoundryAdditive diagnostic.  
4. Leave Foundry additive API unchanged.

## Push gate

Do **not** push until Alloy + Lean + Verify are green.
