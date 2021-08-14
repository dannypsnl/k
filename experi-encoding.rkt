#lang racket

(require syntax/parse/define
         syntax/parse
         (for-syntax syntax/transformer
                     k/core)
         k
         k/data/nat)

(define-syntax-parser Vec
  [(_ E Len)
   (syntax-property #'(list 'Vec E Len) 'type #'Type)])
(define-syntax-parser vnil
  [_ (syntax-property #''vnil 'type #'(Vec (Freevar E) z))])
(define-syntax-parser v::
  ; TODO: write a version introduce implicit `{n}` automatically
  [(_ {n} e vec)
   (define subst-map (make-hash))
   (check-type #'n #'Nat
               subst-map)
   (check-type #'vec #`(Vec #,(typeof #'e) n)
               subst-map)
   (syntax-property #'(list 'v:: e vec) 'type #`(Vec #,(typeof #'e) (s n)))])

(def c : (Vec Nat z) vnil)
(v:: {(s z)} z (v:: {z} z vnil))
