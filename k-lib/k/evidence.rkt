#lang k/base
(provide (data-out Top)
         (data-out Bot)
         (rename-out
          [Top ⊤]
          [Bot ⊥]))

(data Top : Type
      [tt : Top])

(data Bot : Type)
