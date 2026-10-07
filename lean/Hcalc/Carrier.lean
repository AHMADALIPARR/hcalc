/-
Copyright (C) 2026 HCALC contributors
SPDX-License-Identifier: AGPL-3.0-only

Gap-Carrier CLOSED (PRODUCTION.md §1): HCALC.Carrier = Fin n → ℝ with ℓ∞.
-/

import Hcalc.RealStub

namespace Hcalc

abbrev Carrier (n : Nat) : Type := Fin n → Real
abbrev Time : Type := Nat
abbrev Intermediate (n : Nat) : Type := Carrier n
abbrev State (n : Nat) : Type := Carrier n

noncomputable def vzero (n : Nat) : Carrier n := fun _ => (0 : Real)
noncomputable def vadd {n : Nat} (x y : Carrier n) : Carrier n := fun j => x j + y j
noncomputable def vneg {n : Nat} (x : Carrier n) : Carrier n := fun j => -(x j)
noncomputable def vsub {n : Nat} (x y : Carrier n) : Carrier n := fun j => x j - y j
noncomputable def vsmul {n : Nat} (a : Scalar) (x : Carrier n) : Carrier n := fun j => a * x j
noncomputable def linf {n : Nat} (x : Carrier n) : Scalar := finMax (fun j => ‖x j‖ᵣ)

notation "‖" x "‖∞" => linf x

axiom linf_all_zero_eq_zero (n : Nat) (x : Carrier n)
    (h : ∀ j, ‖x j‖ᵣ = (0 : Real)) : ‖x‖∞ = (0 : Real)

/-- ℓ∞ norm is nonnegative. -/
axiom linf_nonneg {n : Nat} (x : Carrier n) : (0 : Real) ≤ᵣ ‖x‖∞

theorem carrier_ext_of_linf_sub_eq_zero {n : Nat} (x y : Carrier n)
    (h : ‖vsub x y‖∞ = (0 : Real)) : x = y := by
  funext j
  have hj := finMax_abs_eq_zero_of (fun k => vsub x y k) h j
  have hsub : x j - y j = (0 : Real) := hj
  have : x j = (x j - y j) + y j := by
    have hcancel : (-(y j)) + y j = (0 : Real) := by
      rw [real_add_comm]
      exact real_neg_add_cancel (y j)
    calc
      x j = x j + (0 : Real) := (real_add_zero (x j)).symm
      _ = x j + ((-(y j)) + y j) := by rw [hcancel]
      _ = (x j + (-(y j))) + y j := (real_add_assoc (x j) (-(y j)) (y j)).symm
      _ = (x j - y j) + y j := rfl
  rw [this, hsub, real_zero_add]

theorem linf_vzero (n : Nat) : ‖vzero n‖∞ = (0 : Real) :=
  linf_all_zero_eq_zero n (vzero n) (fun _ => real_abs_zero)

theorem vsmul_zero_left {n : Nat} (x : Carrier n) : vsmul (0 : Real) x = vzero n := by
  funext j
  exact real_zero_mul (x j)

theorem vsmul_vadd {n : Nat} (a : Scalar) (x y : Carrier n) :
    vsmul a (vadd x y) = vadd (vsmul a x) (vsmul a y) := by
  funext j
  exact real_mul_add a (x j) (y j)

noncomputable abbrev scalarMul {n : Nat} (a : Scalar) (x : Intermediate n) : Intermediate n :=
  vsmul a x

end Hcalc
