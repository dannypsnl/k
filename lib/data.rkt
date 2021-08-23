#lang racket/base

(provide data)

(require syntax/parse/define
         (for-syntax racket/base
                     syntax/parse
                     syntax/parse/define
                     syntax/stx
                     "core.rkt"))

(begin-for-syntax
  (define-syntax-class ctor-clause
    (pattern [name:id (~literal :) ty]
             #:attr def
             #'(define-syntax-parser name
                 [_ (syntax-property* #''name 'type #'ty)]))
    (pattern [name:id (p-name* (~literal :) p-ty*) ... (~literal :) ty]
             #:attr def
             #'(define-syntax-parser name
                 [(_ p-name* ...)
                  (define subst-map (make-hash))
                  (check-type #'p-name* (subst #'p-ty* subst-map)
                              subst-map)
                  ...
                  (with-syntax ([e (stx-map local-expand-expr #'(list p-name* ...))])
                    (syntax-property* #'`(name ,@e)
                                      'type (subst #'ty subst-map)))]))))

(define-syntax-parser data
  [(_ name:id (~literal :) ty
      ctor*:ctor-clause ...)
   (with-syntax ([def #'(define-syntax-parser name
                          [_ (syntax-property* #''name 'type #'ty)])])
     #'(begin
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
                           (with-syntax ([e (stx-map local-expand-expr #'(list p-name* ...))])
                             (syntax-property* #'`(name ,@e)
                                               'type (subst #'ty subst-map)))])])
     #'(begin
         def
         ctor*.def ...))])
