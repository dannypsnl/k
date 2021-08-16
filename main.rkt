#lang racket

(provide (except-out (all-from-out racket))
         typeof
         Type
         data
         def)

(require syntax/parse/define
         (for-syntax syntax/parse
                     syntax/transformer
                     "core.rkt"))

(define-syntax-parser typeof
  [(_ stx) #`'#,(typeof-expanded #'stx)])

(define-syntax-parser Type
  [_ (syntax-property #'(list 'Type 0) 'type #'(Type 1))]
  [(_ n)
   (syntax-property #'(list 'Type n) 'type #'(Type (add1 n)))])

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
                  (syntax-property #'(list 'name p-name* ...)
                                   'type (subst #'ty subst-map))]))))

(define-syntax-parser data
  [(_ name:id (~literal :) ty
      ctor*:ctor-clause ...)
   #'(begin
       (define-syntax-parser name
         [_ (syntax-property #''name 'type #'ty)])
       ctor*.def ...)]
  [(_ (name:id [p-name* (~literal :) p-ty*] ...) (~literal :) ty
      ctor*:ctor-clause ...)
   #'(begin
       (define-syntax-parser name
         [(_ p-name* ...)
          (define subst-map (make-hash))
          (check-type #'p-name* (subst #'p-ty* subst-map)
                      subst-map)
          ...
          (syntax-property #'(list 'name p-name* ...)
                           'type (subst #'ty subst-map))])
       ctor*.def ...)])

(begin-for-syntax
  (define (bounded-identifier? id-stx)
    (and (identifier? id-stx)
         (identifier-binding id-stx (syntax-local-phase-level) #t)))
  (define (convert pattern-stx)
    (syntax-parse pattern-stx
      [x:id #:when (bounded-identifier? #'x)
            #'(~literal x)]
      #;[(x ...)
         (map convert (syntax->list #'(x ...)))]
      [x #'x]))
  (define-syntax-class def-clause
    (pattern [pat* ... => expr]
             #:attr r #`[(_ #,@(map convert
                                    (syntax->list #'(pat* ...))))
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

(module reader syntax/module-reader k)
