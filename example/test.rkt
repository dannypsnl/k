#lang k

(require k/data/bool
         k/data/nat)

(data (≡ [a : A] [b : A]) : Type
      [refl : (≡ a a)])

(check (≡ z z)
       (refl))
(check (≡ (s z) (s z))
       (refl))
