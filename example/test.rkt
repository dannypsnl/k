#lang k

(require k/data/bool
         k/data/nat
         k/equality)

(check (≡ true true)
       (refl))

(check (≡ (+ (s z) (s z))
          (s (s z)))
       (refl))
