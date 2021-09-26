#lang racket/base

(provide def)

(require syntax/parse/define
         (for-syntax racket/base
                     racket/list
                     syntax/parse
                     syntax/transformer
                     syntax/stx
                     "bind.rkt"
                     "core.rkt"))

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
   (define (find-frees stx)
     (syntax-parse stx
       [x:id #:when (free-identifier? #'x)
             stx]
       [(x ...)
        (map find-frees (syntax->list #'(x ...)))]
       [x #f]))
   (for ([pat* (syntax->list #'((clause*.pat* ...) ...))]
         [body (syntax->list #'(clause*.expr ...))])
     (define map (make-hash))
     (define (ss stx)
       (syntax-parse stx
         [x:id #:when (free-identifier? #'x)
               (hash-set! map (syntax->datum stx)
                          (syntax-property* #`#,(gensym 'F)
                                            'type #'Type))]
         [(x ...)
          (stx-map ss #'(x ...))]
         [else (void)]))
     (define (give-frees-type stx)
       (syntax-parse stx
         [x:id #:when (free-identifier? #'x)
               (syntax-property* stx
                                 'type (hash-ref map (syntax->datum stx)))]
         [(x ...)
          (stx-map give-frees-type #'(x ...))]
         [x stx]))
     (define subst-map (make-hash))
     (for ([pat (syntax->list pat*)]
           [exp-ty (syntax->list #'(p*.ty ...))])
       (ss pat)
       (parameterize ([skip-identifiers (filter identifier? (flatten (find-frees pat)))])
         (check-type (give-frees-type pat) exp-ty subst-map)))
     (parameterize ([skip-identifiers (filter identifier? (flatten (find-frees body)))])
       (check-type (give-frees-type body) #'ty subst-map)))
   (with-syntax ([def #'(define-syntax-parser name
                          [clause*.pat #'clause*.expr] ...)]
                 [(free-p-ty* ...)
                  (filter free-identifier? (syntax->list #'(p*.ty ...)))])
     #'(begin
         (void (let* ([free-p-ty* 'free-p-ty*] ...
                      [p*.name 'p*.name] ...)
                 ty))
         def))])
