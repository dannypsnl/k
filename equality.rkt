#lang k

(provide ≡ refl
         cong)

(data (≡ [a : A] [b : A]) : Type
      [refl : (≡ a a)])

(def (cong [f : (-> A B)] [x : A] [y : A] 
           [P : (≡ x y)])
  : (≡ (f x) (f y))
  [f x y refl => refl])
