#lang k
(require k/equality)
#|
TODO:
1. `A`, `B` should be defined
2. `x`, `y`, `z` should be implicit(ignorable by pattern clause)
3. `cong` is not definable now, since our implementation didn't treat `f` as a procedure now
|#

; Symmetry
(def (symm [x y : A] [p : (≡ x y)]) : (≡ y x)
  [x y refl => refl])

; Transitivity
(def (trans [x y z : A]
            [p : (≡ x y)]
            [q : (≡ y z)])
  : (≡ x z)
  [x y z refl refl => refl])

#|
; Congruence
(def (cong [f : (Pi ([x : A]) B)]
           [x y : A]
           [P : (≡ x y)])
  : (≡ (f x) (f y))
  [f x y refl => refl])
|#
