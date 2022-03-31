#lang k
(require k/equality
         k/data/nat
         syntax/parse/define)

(begin-for-syntax
  (define (nat->unary n)
    (if (zero? n)
        #'z
        #`(s #,(nat->unary (sub1 n))))))

(define-syntax-parser #%datum
  [(_ . x:nat)
   (nat->unary (syntax->datum #'x))]
  [(_ . x) #'x])

(check (≡ (+ 1 2) (+ 2 1))
       refl)
