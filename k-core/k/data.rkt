#lang racket/base

(provide data
         data-out)

(require syntax/parse/define
         "def.rkt"
         (for-syntax racket/base
                     racket/provide-transform
                     racket/dict
                     syntax/parse
                     "bindings.rkt"
                     "helper/id-hash.rkt"))

(begin-for-syntax
  (define data-out-set (make-mutable-id-hash))
  (define (id->export id) (export id (syntax->datum id) 0 #f id))

  (define-syntax-class ctor-clause
    #:datum-literals (:)
    (pattern [name:id : ty]
             #:attr def
             #'(def name : ty #:constructor))
    (pattern [name:id p*:bindings : ty]
             #:attr def
             #'(def (name [p*.name : p*.ty] ...) : ty #:constructor))))

(define-syntax-parser data
  #:datum-literals (:)
  [(_ name:id : ty
      ctor*:ctor-clause ...)
   (dict-set! data-out-set #'name (map id->export (cons #'name (syntax->list #'(ctor*.name ...)))))
   #'(begin
       (def name : ty #:postulate)
       ctor*.def ...)]
  [(_ (name:id p*:bindings) : ty
      ctor*:ctor-clause ...)
   (dict-set! data-out-set #'name (map id->export (cons #'name (syntax->list #'(ctor*.name ...)))))
   #'(begin
       (def (name [p*.name : p*.ty] ...) : ty #:postulate)
       ctor*.def ...)])

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
        (define l (dict-ref data-out-set #'data-type #f))
        (unless l
          (raise-syntax-error #f "only data-type can be used in `data-out`" #'data-type))
        l]))))
