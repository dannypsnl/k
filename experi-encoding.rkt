#lang racket

(require syntax/parse/define
         syntax/parse
         (for-syntax syntax/transformer
                     k/core)
         k)

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

(define-syntax-parser def
  [(_ name:id : ty expr)
   (check-type #'expr #'ty)
   #'(begin
       (define-syntax name
         (make-variable-like-transformer
          #'expr))
       ; (void x) to use x, but slient
       (void ty))]
  [(_ name:id : ty
      [pat* ... => expr*] ...)
   #'(begin
       (define-syntax-parser name
         [{_ pat* ...} #'expr*] ...)
       (void ty))])

(def c : (Vec Nat z) vnil)
(v:: {(s z)} z (v:: {z} z vnil))
