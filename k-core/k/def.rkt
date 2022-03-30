#lang racket/base

(provide def)

(require syntax/parse/define
         (for-syntax racket/base
                     racket/dict
                     syntax/parse
                     syntax/transformer
                     syntax/stx
                     "bindings.rkt"
                     "core.rkt"
                     "helper/id-hash.rkt"))

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
  [(_ (name:id p*:bindings) : ty
      clause*:def-clause ...)
   (for ([pat* (syntax->list #'((clause*.pat* ...) ...))]
         [expr (syntax->list #'(clause*.expr ...))])
     ; locals stores local identifiers to it's type
     (define locals (make-mutable-id-hash))
     ; itself type need to be stored for later check
     (dict-set! locals #'name #'(Pi ([p*.name : p*.ty] ...) ty))
     (define subst-map (make-hash))
     (for ([pat (syntax->list pat*)]
           [exp-ty (syntax->list #'(p*.ty ...))])
       (syntax-parse pat
         [x:id #:when (bounded-identifier? #'x)
               (check-type #'x exp-ty
                           subst-map
                           locals)]
         ; typeof x should be a Pi type here, then here are going to unify p*... with telescope of the Pi type
         ; we should use telescope to bind type to free variable
         [(x:id p* ...) #:when (bounded-identifier? #'x)
                        (syntax-parse (typeof #'x)
                          [(Pi ([x* : typ*] ...) _)
                           (for ([p (syntax->list #'(p* ...))]
                                 [ty (syntax->list #'(typ* ...))])
                             (dict-set! locals p ty))]
                          [_ (raise-syntax-error 'bad-pattern
                                                 (format "~a is not a expandable constructor" #'x)
                                                 pat)])]
         ; bind pattern type to the free variable here
         ; and brings the binding to the end for return type unification
         [x:id (dict-set! locals #'x exp-ty)]
         [_ (raise-syntax-error 'bad-pattern
                                (format "pattern only allows to destruct on constructor")
                                pat)]))
     (check-type expr #'ty
                 subst-map
                 locals))
   (with-syntax ([definition #'(define-syntax-parser name
                                 [_:id (syntax-property*
                                        #''name
                                        'type
                                        #'(Pi ([p*.name : p*.ty] ...) ty))]
                                 [clause*.pat #'clause*.expr] ...)]
                 ; FIXME: these should be implicit bindings
                 [(free-p-ty* ...)
                  (filter free-identifier? (syntax->list #'(p*.ty ...)))])
     #'(begin
         (void (let* ([free-p-ty* 'free-p-ty*] ...
                      [p*.name 'p*.name] ...)
                 ty))
         definition))])
