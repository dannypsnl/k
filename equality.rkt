#lang k

(provide ≡ refl)

(data (≡ [a : A] [b : A]) : Type
      [refl : (≡ a a)])
