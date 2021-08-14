#lang racket

(provide (except-out (all-from-out racket))
         Type
         data
         def)

(require syntax/parse/define
         (for-syntax syntax/parse
                     syntax/transformer
                     "core.rkt"))

(define-syntax-parser Type
  [_ (syntax-property #'(list 'Type 0) 'type #'(Type 1))]
  [(_ n)
   (syntax-property #'(list 'Type n) 'type #'(Type (add1 n)))])

(begin-for-syntax
  (define-syntax-class clause
    (pattern [ctor-name:id (~literal :) ctor-ty]
             #:attr def
             #'(define-syntax-parser ctor-name
                 [_ (syntax-property #''ctor-name 'type #'ctor-ty)]))
    (pattern [ctor-name:id (p-name* (~literal :) p-ty*) ... (~literal :) ctor-ty]
             #:attr def
             #'(define-syntax-parser ctor-name
                 [(_ p-name* ...)
                  (define subst-map (make-hash))
                  (check-type #'p-name* #'p-ty* subst-map) ...
                  (syntax-property #'(list 'ctor-name p-name* ...) 'type #'ctor-ty)]))))

(define-syntax-parser data
  [(_ name:id (~literal :) ty
      ctor*:clause ...)
   #'(begin
       (define-syntax-parser name
         [_ (syntax-property #''name 'type #'ty)])
       ctor*.def ...)]
  [(_ (name:id [p-name* (~literal :) p-ty*] ...) (~literal :) ty
      ctor*:clause ...)
   #'(begin
       (define-syntax-parser name
         [(_ p-name* ...)
          (define subst-map (make-hash))
          (check-type #'p-name* #'p-ty* subst-map) ...
          (syntax-property #'(list 'name p-name* ...) 'type #'ty)])
       ctor*.def ...)])

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

(module reader syntax/module-reader k)
