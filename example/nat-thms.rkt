#lang k

(require k/data/nat
         k/equality)

(def (0+x [x : Nat]) : (≡ (+ z x) x)
  [x => refl])

#;(def (x+0 [x : Nat]) : (≡ (+ x z) x)
    [zero => refl]
    [(s x) => (cong s x+0)])
