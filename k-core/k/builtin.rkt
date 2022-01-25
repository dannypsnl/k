#lang racket/base
(provide typeof
         (data-out Top)
         (data-out Bot)
         (rename-out
          [Top ⊤]
          [Bot ⊥]))

(require syntax/parse/define
         (for-syntax racket/base
                     "core.rkt")
         "data.rkt"
         "def.rkt")

(define-syntax-parser typeof
  [(_ stx) #`'#,(typeof-expanded #'stx)])

(data Top : Type
      [tt : Top])

(data Bot : Type)

(module+ test
  (def (true-to-true [x : Top]) : Top
    [x => x])
  (def (true-to-true2 [x : Top]) : Top
    [x => tt]))
