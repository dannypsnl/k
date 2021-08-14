#lang racket

(provide (all-defined-out))

(require syntax/parse)

(define (type-equal? t1 t2)
  (equal? (syntax->datum t1) (syntax->datum t2)))
(define (unifier subst-map)
  (define (unify? t1 t2)
    (syntax-parse #'(t1 t2)
      #;[((A:id a ...) (B:id b ...))
         (and (type-equal? #'A #'B)
              (unify? #'(a ...)
                      #'(b ...)))]
      [((Freevar a) b)
       (unify? t2 t1)]
      [(b (Freevar a))
       (define bounded? (hash-ref subst-map #'a #f))
       (unless bounded?
         (hash-set! subst-map #'a t1))
       (not bounded?)]
      [(a b) (type-equal? t1 t2)]))
  unify?)
(define (check-type term type
                    [subst-map (make-hash)])
  (define unify? (unifier subst-map))
  (unless (unify? (typeof term) type)
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
