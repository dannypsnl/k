#lang k

(provide Zero)

(require k/data/bool
         k/data/nat)

(data Zero : Type)
(data One : Type
      [one : One])

Zero
One
one
Bool
true
false
Nat
z
(s z)
