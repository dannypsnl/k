#lang k

(provide ≡ refl
         (for-syntax ≡ refl))

(data (≡ [a : A] [b : A]) : Type
      [refl : (≡ a a)])
