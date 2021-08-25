#lang racket/base

(provide def)

(require syntax/parse/define
         (for-syntax racket/base
                     syntax/parse
                     syntax/transformer
                     syntax/stx
                     "core.rkt"))

(begin-for-syntax
  (define (syntax->compute-pattern pattern-stx)
    (syntax-parse pattern-stx
      [x:id #:when (bounded-identifier? #'x)
            #'(~literal x)]
      [(x ...)
       (stx-map syntax->compute-pattern #'(x ...))]
      [x #'x]))
  (define-syntax-class def-clause
    (pattern [pat* ... => expr]
             #:attr pat #`(_ #,@(stx-map syntax->compute-pattern #'(pat* ...))))))

(define-syntax-parser def
  #:datum-literals (:)
  [(_ name:id : ty expr)
   (check-type #'expr (normalize #'ty))
   #'(begin
       (void ty)
       (define-syntax name (make-variable-like-transformer #'expr)))]
  [(_ (name:id [p-name* : p-ty*] ...) : ty
      clause*:def-clause ...)
   (for ([pat* (syntax->list #'((clause*.pat* ...) ...))])
     (define subst-map (make-hash))
     (define unify? (unifier subst-map))
     (for ([pat (syntax->list pat*)]
           [exp-ty (syntax->list #'(p-ty* ...))])
       (syntax-parse pat
         [x:id #:when (bounded-identifier? #'x)
               (define pat-ty (typeof #'x))
               (unless (unify? pat-ty exp-ty)
                 (raise-syntax-error 'bad-pattern
                                     (format "expect: `~a`, get: `~a`"
                                             (syntax->datum exp-ty)
                                             (syntax->datum pat-ty))
                                     pat))]
         [(x:id p ...) #:when (bounded-identifier? #'x)
                       (void)]
         [x (void)])))
   (with-syntax ([def #'(define-syntax-parser name
                          [clause*.pat #'clause*.expr] ...)]
                 [(free-p-ty* ...)
                  (filter free-identifier? (syntax->list #'(p-ty* ...)))])
     #'(begin
         (void (let* ([free-p-ty* 'free-p-ty*] ...
                      [p-name* 'p-name*] ...)
                 ty))
         def))])
