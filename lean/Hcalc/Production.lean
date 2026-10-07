/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

PRODUCTION surface re-exports (authority: ../spec/PRODUCTION.md).
Domain Gap-* defs live in Hcalc.Axioms / Hcalc.Carrier.
-/

import Hcalc.Axioms
import Hcalc.Carrier
import Hcalc.Pipeline
import Hcalc.Convergence

namespace Hcalc.Production

export Hcalc (Carrier Tp C LambdaM Xi InstanceBridge hcalcStepCore toFoundryStep
  epsProd deltaProd tolProd evalOptObj residualNorm
  definitionRecord_Tp definitionRecord_C definitionRecord_LambdaM definitionRecord_Xi
  definitionRecord_Carrier definitionRecord_OptObj definitionRecord_ContractAlg
  definitionRecord_ShapeMap definitionRecord_Converge)

export Hcalc.Pipeline (step stepProd J optimize done)
export Hcalc.Convergence (HypContractive unique_fixed_point)

end Hcalc.Production
