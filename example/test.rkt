#lang k

(require k/data/nat
         k/equality)

(def (0+x [x : Nat]) : (≡ (+ z x) x)
  [x => refl])
