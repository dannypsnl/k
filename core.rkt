#lang racket

(provide (all-defined-out))

(require syntax/parse
         syntax/parse/define)

(define (unifier subst-map)
  (define (unify? t1 t2)
    (syntax-parse (list t1 t2)
      [((a ...) (b ...))
       (map unify?
            (syntax->list #'(a ...))
            (syntax->list #'(b ...)))]
      [(((~literal Freevar) a) ((~literal Freevar) b))
       #t]
      [(a ((~literal Freevar) b))
       (unify? t2 t1)]
      [(((~literal Freevar) a) b)
       (define bounded? (hash-ref subst-map #'a #f))
       (unless bounded?
         (hash-set! subst-map #'a #'b))
       (not bounded?)]
      [(a b) (equal? (syntax->datum t1) (syntax->datum t2))]))
  unify?)
(define (check-type term type
                    [subst-map (make-hash)])
  (define unify? (unifier subst-map))
  (unless (unify? (typeof term) type)
    (raise-syntax-error 'type-mismatch
                        (format "expect: `~a`, get: `~a`"
                                (syntax->datum type) (typeof-expanded term))
                        term)))

(define (subst stx m)
  (syntax-parse stx
    [(A a ...)
     #`(A #,@(map (λ (b) (subst b m)) (syntax->list #'(a ...))))]
    [name:id
     (if (identifier-binding stx)
         (hash-ref m #'name stx)
         #`(Freevar #,stx))]))

(define (local-expand-expr stx)
  (local-expand stx 'expression '()))
(define (typeof stx)
  (syntax-property (local-expand-expr stx) 'type))
(define (typeof-expanded stx)
  (syntax->datum (typeof stx)))
