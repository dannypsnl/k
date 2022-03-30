#lang racket/base

(provide data
         data-out)

(require syntax/parse/define
         (for-syntax racket/base
                     racket/provide-transform
                     syntax/parse
                     syntax/parse/define
                     syntax/stx
                     "bindings.rkt"
                     "core.rkt"))

(begin-for-syntax
  (define data-out-set (make-hash))
  (define (id->export id) (export id (syntax->datum id) 0 #f id))

  (define-syntax-class ctor-clause
    #:datum-literals (:)
    (pattern [name:id : ty]
             #:attr def
             #'(define-syntax-parser name
                 [_:id (syntax-property* #''name 'type #'ty)]))
    (pattern [name:id p*:bindings : ty]
             #:attr def
             #'(define-syntax-parser name
                 [_:id
                  (syntax-property*
                   #''name
                   'type
                   #'(Pi ([p*.name : p*.ty] ...) ty))]
                 [(_:id p*.name ...)
                  (define subst-map (make-hash))
                  (check-type #'p*.name (subst #'p*.ty subst-map)
                              subst-map)
                  ...
                  (with-syntax ([e (stx-map local-expand-expr #'(list p*.name ...))])
                    (syntax-property* #'`(name ,@e)
                                      'type (subst #'ty subst-map)))]))))

(define-syntax-parser data
  #:datum-literals (:)
  [(_ name:id : ty
      ctor*:ctor-clause ...)
   (hash-set! data-out-set (syntax->datum #'name) (map id->export (cons #'name (syntax->list #'(ctor*.name ...)))))
   (with-syntax ([def #'(define-syntax-parser name
                          [_:id (syntax-property* #''name 'type #'ty)])])
     #'(begin
         def
         ctor*.def ...))]
  [(_ (name:id p*:bindings) : ty
      ctor*:ctor-clause ...)
   (hash-set! data-out-set (syntax->datum #'name) (map id->export (cons #'name (syntax->list #'(ctor*.name ...)))))
   (with-syntax ([def #'(define-syntax-parser name
                          [(_ p*.name ...)
                           (define subst-map (make-hash))
                           (check-type #'p*.name (subst #'p*.ty subst-map)
                                       subst-map)
                           ...
                           (with-syntax ([e (stx-map local-expand-expr #'(list p*.name ...))])
                             (syntax-property* #'`(name ,@e)
                                               'type (subst #'ty subst-map)))])])
     #'(begin
         def
         ctor*.def ...))])

(define-syntax data-out
  (make-provide-transformer
   (lambda (stx modes)
     (unless (or (null? modes)
                 (equal? '(0) modes))
       (raise-syntax-error
        #f
        "allowed only for relative phase level 0"
        stx))
     (syntax-parse stx
       [(_ data-type:id)
        (define l (hash-ref data-out-set (syntax->datum #'data-type) #f))
        (unless l
          (raise-syntax-error #f "only data-type can be used in `data-out`" #'data-type))
        l]))))
