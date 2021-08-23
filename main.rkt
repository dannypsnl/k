#lang racket

(provide (except-out (all-from-out racket/base))
         ; builtin types
         Type Pi
         ; helpers
         typeof
         check
         data-out
         ; definition forms
         data
         def)

(require racket/base
         syntax/parse/define
         "lib/type.rkt"
         "lib/data.rkt"
         (for-syntax racket/base
                     syntax/parse
                     syntax/parse/define
                     syntax/transformer
                     syntax/stx
                     "lib/core.rkt"))

(define-syntax-parser typeof
  [(_ stx) #`'#,(typeof-expanded #'stx)])

(begin-for-syntax
  (define (convert pattern-stx)
    (syntax-parse pattern-stx
      [x:id #:when (bounded-identifier? #'x)
            #'(~literal x)]
      [(x ...)
       (stx-map convert #'(x ...))]
      [x #'x]))
  (define-syntax-class def-clause
    (pattern [pat* ... => expr]
             #:attr pat #`(_ #,@(stx-map convert #'(pat* ...))))))

(define-syntax-parser def
  [(_ name:id (~literal :) ty expr)
   (check-type #'expr (normalize #'ty))
   #'(begin
       (void ty)
       (define-syntax name (make-variable-like-transformer #'expr)))]
  [(_ (name:id [p-name* (~literal :) p-ty*] ...) (~literal :) ty
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
(define-syntax-parser check
  [(_ ty expr)
   (check-type #'expr (normalize #'ty))
   #'(begin
       (void ty)
       expr)])

(module reader syntax/module-reader k)
