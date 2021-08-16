#lang racket

(begin-for-syntax
  (define (bounded-identifier? id-stx)
    (and (identifier? id-stx)
         (identifier-binding id-stx (syntax-local-phase-level) #t)))
  (define (convert pattern-stx)
    (syntax-parse pattern-stx
      [x:id #:when bounded-identifier?
            #'(~literal x)]
      [(x ...)
       (map convert (syntax->list #'(x ...)))]
      [x #'x]))
  (define-syntax-class def-clause
    (pattern [pat* ... => expr]
             #:attr r #`[(_ #,@(map convert (syntax->list #'(pat* ...))))
                         #'expr])))

(define-syntax-parser def
  [(_ name:id : ty expr)
   (check-type #'expr #'ty)
   #'(begin
       (define-syntax name
         (make-variable-like-transformer
          #'expr))
       ; (void x) to use x, but slient
       (void ty))]
  [(_ name:id : ty clause*:def-clause ...)
   #'(begin
       (define-syntax-parser name
         clause*.r ...)
       ; (void x) to use x, but slient
       (void ty))])