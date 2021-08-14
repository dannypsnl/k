#lang racket

(provide (all-defined-out))

(require syntax/parse
         syntax/parse/define)

(define (unifier subst-map)
  (define (unify? t1 t2)
    (match (list t1 t2)
      [(list `(,a ...) `(,b ...))
       (map unify? a b)]
      [(list-no-order `(Freevar ,a) b)
       (define bounded? (hash-ref subst-map #'a #f))
       (unless bounded?
         (hash-set! subst-map a b))
       (not bounded?)]
      [(list a b)
       (equal? a b)]))
  unify?)
(define (check-type term type
                    [subst-map (make-hash)])
  (define unify? (unifier subst-map))
  (unless (unify? (syntax->datum (typeof term))
                  (syntax->datum type))
    (raise-syntax-error 'type-mismatch
                        (format "expect: `~a`, get: `~a`"
                                (syntax->datum type) (typeof-expanded term))
                        term)))

(define (local-expand-expr stx)
  (local-expand stx 'expression '()))
(define (typeof stx)
  (syntax-property (local-expand-expr stx) 'type))
(define (typeof-expanded stx)
  (syntax->datum (typeof stx)))
