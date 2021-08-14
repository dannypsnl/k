#lang racket

(require syntax/parse/define
         syntax/parse
         (for-syntax syntax/transformer
                     k/core)
         k
         k/data/nat)

(data (Vec [E : Type] [Len : Nat]) : Type
      [vnil : (Vec E z)]
      #;[v:: (e : E) (vec : (Vec E n)) : (Vec E (s n))])

(define-syntax-parser v::
  ; TODO: write a version introduce implicit `{n}` automatically
  [(_ {n} e vec)
   (define subst-map (make-hash))
   (check-type #'n #'Nat
               subst-map)
   (check-type #'vec #`(Vec #,(typeof #'e) n)
               subst-map)
   (displayln (typeof #'vec))
   (syntax-property #'(list 'v:: e vec) 'type #`(Vec #,(typeof #'e) (s n)))])

(def c : (Vec Nat z) vnil)
(v:: {(s z)} z (v:: {z} z vnil))
