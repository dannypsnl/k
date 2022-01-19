#lang k/base
(provide (data-out Top)
         (data-out Bot)
         (rename-out
          [Top ⊤]
          [Bot ⊥]))

(data Top : Type
      [tt : Top])

(data Bot : Type)

(module+ test
  (def (true-to-true [x : Top]) : Top
    [x => x])
  (def (true-to-true2 [x : Top]) : Top
    [x => tt]))
