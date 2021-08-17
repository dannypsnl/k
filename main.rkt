#lang racket

(provide (except-out (all-from-out racket))
         ; helpers
         typeof
         check
         ; builtin types
         Type Pi
         ; definition forms
         data
         def)

(require syntax/parse/define
         (for-syntax syntax/parse
                     syntax/parse/define
                     syntax/transformer
                     "core.rkt")
         (for-meta 2
                   racket/base
                   syntax/transformer
                   "core.rkt"))

(define-syntax-parser typeof
  [(_ stx) #`'#,(typeof-expanded #'stx)])

(define-syntax-parser Type
  [_ (syntax-property
      (syntax-property #'(list 'Type 0) 'type #'(Type 1))
      'level 0)]
  [(_ n)
   (syntax-property
    (syntax-property #'(list 'Type n) 'type #'(Type (add1 n)))
    'level (syntax->datum #'n))])

(define-syntax-parser Pi
  [(_ [tele-name* (~literal :) tele-typ*] ... result-ty)
   (define max-level
     (apply max
            (cons 0
                  (filter number?
                          (map (λ (stx)
                                 (syntax-property stx 'level))
                               (syntax->list #'(tele-typ* ...)))))))
   (syntax-property #'`(Pi ,`[tele-name* : ,tele-typ*] ...
                           ,result-ty)
                    'type #`(Type #,max-level))])

(begin-for-syntax
  (define-syntax-class ctor-clause
    (pattern [name:id (~literal :) ty]
             #:attr def
             #'(define-syntax-parser name
                 [_ (syntax-property #''name 'type #'ty)]))
    (pattern [name:id (p-name* (~literal :) p-ty*) ... (~literal :) ty]
             #:attr def
             #'(define-syntax-parser name
                 [(_ p-name* ...)
                  (define subst-map (make-hash))
                  (check-type #'p-name* (subst #'p-ty* subst-map)
                              subst-map)
                  ...
                  (syntax-property #'`(name ,p-name* ...)
                                   'type (subst #'ty subst-map))]))))

(define-syntax-parser data
  [(_ name:id (~literal :) ty
      ctor*:ctor-clause ...)
   (with-syntax ([def #'(define-syntax-parser name
                          [_ (syntax-property #''name 'type #'ty)])])
     #'(begin
         (begin-for-syntax
           def
           ctor*.def ...)
         def
         ctor*.def ...))]
  [(_ (name:id [p-name* (~literal :) p-ty*] ...) (~literal :) ty
      ctor*:ctor-clause ...)
   (with-syntax ([def #'(define-syntax-parser name
                          [(_ p-name* ...)
                           (define subst-map (make-hash))
                           (check-type #'p-name* (subst #'p-ty* subst-map)
                                       subst-map)
                           ...
                           (syntax-property #'`(name ,p-name* ...)
                                            'type (subst #'ty subst-map))])])
     #'(begin
         (begin-for-syntax
           def
           ctor*.def ...)
         def
         ctor*.def ...))])

(begin-for-syntax
  (define (bounded-identifier? id-stx)
    (and (identifier? id-stx)
         (identifier-binding id-stx (syntax-local-phase-level) #t)))
  (define (convert pattern-stx)
    (syntax-parse pattern-stx
      [x:id #:when (bounded-identifier? #'x)
            #'(~literal x)]
      [(x ...)
       (map convert (syntax->list #'(x ...)))]
      [x #'x]))
  (define-syntax-class def-clause
    (pattern [pat* ... => expr]
             #:attr r #`[(_ #,@(map convert
                                    (syntax->list #'(pat* ...))))
                         #'expr])))

(define-syntax-parser def
  [(_ name:id (~literal :) ty expr)
   (check-type #'expr #'ty)
   (with-syntax ([def #'(define-syntax name
                          (make-variable-like-transformer
                           #'expr))])
     #'(begin
         (begin-for-syntax
           def
           (void ty))
         def))]
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
                          clause*.r ...)])
     #'(begin
         (begin-for-syntax
           def
           (void p-ty* ... ty))
         def))])
(define-syntax-parser check
  [(_ ty expr)
   (check-type #'expr #'ty)
   #'(begin
       (begin-for-syntax
         (void ty))
       expr)])

(module reader syntax/module-reader k)
