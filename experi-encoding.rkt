#lang racket

(require syntax/parse/define
         (for-syntax syntax/transformer))

(define-for-syntax (type-equal? t1 t2)
  (equal? (syntax->datum t1) (syntax->datum t2)))
(define-for-syntax (check-type term type)
  (unless (type-equal? (typeof term) type)
    (raise-syntax-error 'type-mismatch
                        (format "expect: `~a`, get: `~a`"
                                (syntax->datum type) (typeof-expanded term))
                        term)))

(define-for-syntax (local-expand-expr stx)
  (local-expand stx 'expression '()))
(define-for-syntax (typeof stx)
  (syntax-property (local-expand-expr stx) 'type))
(define-for-syntax (typeof-expanded stx)
  (syntax->datum (typeof stx)))

(define-syntax-parser Type
  [_ (syntax-property #'(list 'Type 0) 'type #'(Type 1))]
  [(_ n)
   (syntax-property #'(list 'Type n) 'type #'(Type (add1 n)))])

(define-syntax-parser Bool
  [_ (syntax-property #''Bool 'type #'Type)])
(define-syntax-parser true
  [_ (syntax-property #''true 'type #'Bool)])
(define-syntax-parser false
  [_ (syntax-property #''false 'type #'Bool)])

(define-syntax-parser Nat
  [_ (syntax-property #''Nat 'type #'Type)])
(define-syntax-parser z
  [_ (syntax-property #''z 'type #'Nat)])
(define-syntax-parser s
  [(_ n)
   (check-type #'n #'Nat)
   (syntax-property #'(list 's n) 'type #'Nat)])

(define-syntax-parser Vec
  [(_ E Len)
   (syntax-property #'(list 'Vec E Len) 'type #'Type)])
(define-syntax-parser vnil
  [_ (syntax-property #''vnil 'type #'(Vec Nat z))])
(define-syntax-parser v::
  ; TODO: write a version introduce implicit `{n}` automatically
  [(_ {n} e vec)
   (check-type #'n #'Nat)
   (check-type #'vec #`(Vec #,(typeof #'e) n))
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

(s (s z))
Nat

(def a : Nat z)
a
(def b : Nat a)
b

(def + : (-> Nat Nat Nat)
  [(~literal z) m => m]
  [((~literal s) n) m => (s (+ n m))])
(+ (s z) (s z))

(def c : (Vec Nat z) vnil)
(v:: {(s z)} z (v:: {z} z vnil))
