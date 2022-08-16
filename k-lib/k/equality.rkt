#lang k/base
(provide (data-out ≡)
         #;cong
         symm
         #;trans)

(data (≡ {A : Type}
         [a b : A])
      : Type
      [refl : (≡ A a a)])

#|
Congruence

TODO:
1. `cong` is not definable now, since our implementation didn't treat `f` as a procedure now
2. `A`, `B`, `x`, `y`, `z` should no need pattern(implicit)
(def (cong {A B : Type}
           [f : (Pi ([x : A]) B)]
           [x y : A]
           [P : (≡ x y)])
  : (≡ (f x) (f y))
  [A B f x y refl => refl])
|#

; Symmetry
(def (symm {A : Type}
           [x y : A]
           [p : (≡ x y)])
  : (≡ y x)
  [A x y refl => refl])

; Transitivity
(def (trans {A : Type}
            [x y z : A]
            [p : (≡ x y)]
            [q : (≡ y z)])
  : (≡ x z)
  [A x y z refl refl => refl])
