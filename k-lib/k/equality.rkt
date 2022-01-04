#lang k/base

(provide (data-out ≡))

(data (≡ [a b : A]) : Type
      [refl : (≡ a a)])
