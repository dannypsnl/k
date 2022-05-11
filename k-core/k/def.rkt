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
      [x:id #:when (constructor? #'x)
            #'(~literal x)]
      [(x ...)
       (stx-map syntax->compute-pattern #'(x ...))]
      [x #'x]))
  (define-syntax-class def-clause
    (pattern [pat* ... => expr]
      #:attr pat #`(_ #,@(stx-map syntax->compute-pattern #'(pat* ...)))))

  (define (on-pattern pat exp-ty locals subst-map)
    (syntax-parse pat
      [x:id #:when (constructor? #'x)
            (check-type #'x exp-ty
                        subst-map
                        locals)]
      ; typeof x should be a Pi type here, then here are going to unify p*... with telescope of the Pi type
      ; we should use telescope to bind type to free variable
      [(x:id p* ...) #:when (constructor? #'x)
                     (syntax-parse (typeof #'x)
                       [(Pi ([x* : typ*] ...) _)
                        (for ([p (syntax->list #'(p* ...))]
                              [ty (syntax->list #'(typ* ...))])
                          (on-pattern p ty locals subst-map))]
                       [_ (raise-syntax-error 'bad-pattern
                                              "not an expandable constructor"
                                              #'x)])]
      ; bind pattern type to the free variable here
      ; and brings the binding to the end for return type unification
      [x:id (dict-set! locals #'x exp-ty)]
      [_ (raise-syntax-error 'bad-pattern
                             (format "pattern only allows to destruct on constructor")
                             pat)])))

(define-syntax-parser def
  #:datum-literals (:)
  [(_ name:id : ty #:postulate props ...) #'(define-syntax-parser name [_:id (syntax-property* #''name 'type #'ty props ...)])]
  [(_ name:id : ty #:constructor) #'(def name : ty #:postulate 'constructor #t)]
  [(_ name:id : ty expr)
   (check-type #'expr (normalize #'ty))
   #'(begin
       (void ty)
       (define-syntax name (make-variable-like-transformer #'expr)))]
  [(_ (name:id p*:bindings) : ty #:postulate props ...)
   #'(define-syntax-parser name
       [_:id
        (syntax-property*
         #''name
         'type
         #'(Pi ([p*.name : p*.ty] ...) ty)
         props ...)]
       ; full case: users provide implicit arguments
       ; application with implicit must provides all implicits
       ; NOTE: maybe this is not required, but need some researching
       [(_ p*.full-name ...)
        (define subst-map (make-hash))
        (check-type #'p*.full-name (subst #'p*.full-ty subst-map)
                    subst-map)
        ...
        (with-syntax ([e (stx-map local-expand-expr #'(list p*.full-name ...))])
          (syntax-property* #'`(name ,@e)
                            'type (subst #'ty subst-map)
                            props ...))]
       ; FIXME: might not correct implementation
       [(_:id p*.name ...) #'(name p*.full-name ...)])]
  [(_ (name:id p*:bindings) : ty #:constructor) #'(def (name [p*.name : p*.ty] ...) : ty #:postulate 'constructor #t)]
  [(_ (name:id p*:bindings) : ty
      clause*:def-clause ...)
   (define binds (make-hash))
   ; store implicit arguments
   (stx-map (lambda (k v)
              (hash-set! binds
                         (syntax->datum k)
                         (syntax-property k 'type v)))
            #'(p*.full-name ...) #'(p*.full-ty ...))

   (for ([pat* (syntax->list #'((clause*.pat* ...) ...))]
         [expr (syntax->list #'(clause*.expr ...))])
     ; locals stores local identifiers to it's type
     (define locals (make-mutable-id-hash))
     ; itself type need to be stored for later pattern check
     (dict-set! locals #'name #'(Pi ([p*.name : p*.ty] ...) (subst #'ty binds)))
     (define subst-map (make-hash))
     (for ([pat (syntax->list pat*)]
           [exp-ty (syntax->list #'(p*.ty ...))])
       (on-pattern pat exp-ty locals subst-map))
     ; check pattern's body has correct type
     (check-type expr (subst #'ty binds) subst-map))
   (with-syntax ([return-type (subst #'ty binds)]
                 ; FIXME: these should be implicit bindings
                 [(free-p-ty* ...)
                  (filter free-identifier? (syntax->list #'(p*.full-ty ...)))])
     #'(begin
         (void (let* ([free-p-ty* 'free-p-ty*] ...
                      [p*.name 'p*.name] ...)
                 return-type))
         ;;; computation definition
         (define-syntax-parser name
           [_:id (syntax-property*
                  #''name
                  'type
                  #'(Pi ([p*.name : p*.ty] ...) return-type))]
           [clause*.pat #'clause*.expr] ...)))])
