#lang racket

(provide (except-out (all-from-out racket)
                     #%app)
         data)

(require syntax/parse/define
         (for-syntax syntax/parse
                     "core.rkt"))

(define-syntax-parser Type
  [_ (syntax-property #'(list 'Type 0) 'type #'(Type 1))]
  [(_ n)
   (syntax-property #'(list 'Type n) 'type #'(Type (add1 n)))])

(define-syntax-parser Freevar
  [(_ name:id ty)
   (syntax-property #'(list 'Freevar name) 'type #'ty)])

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
                  (check-type #'p-name* #'p-ty*) ...
                  (syntax-property #'(list 'ctor-name p-name* ...) 'type #'ctor-ty)]))))

(define-syntax-parser data
  [(_ name:id (~literal :) ty
      ctor*:clause ...)
   #'(begin
       (define-syntax-parser name
         [_ (syntax-property #''name 'type #'ty)])
       ctor*.def ...)])

(module reader syntax/module-reader k)
