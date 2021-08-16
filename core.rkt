#lang racket

(provide unifier
         check-type
         subst
         typeof
         typeof-expanded)

(require syntax/parse)

(define (unifier subst-map)
  (define (unify? t1 t2)
    (syntax-parse (list t1 t2)
      [(a b) #:when (and (free-identifier? #'a)
                         (free-identifier? #'b))
             #t]
      [(a b) #:when (free-identifier? #'b)
             (unify? t2 t1)]
      [(a b) #:when (free-identifier? #'a)
             (define bounded? (hash-ref subst-map (syntax->datum #'a) #f))
             (unless bounded?
               (hash-set! subst-map (syntax->datum #'a) #'b))
             #t]
      [(((~literal Pi) [ta-name (~literal :) ta-typ] ... ta)
        ((~literal Pi) [tb-name (~literal :) tb-typ] ... tb))
       (and
        (andmap unify?
                (syntax->list #'(ta-typ ...))
                (syntax->list #'(ta-typ ...)))
        (unify? #'ta #'tb))]
      [((a ...) (b ...))
       (andmap unify?
               (syntax->list #'(a ...))
               (syntax->list #'(b ...)))]
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
    [name:id (hash-ref m (syntax->datum #'name) stx)]))

(define (typeof stx)
  (syntax-property (local-expand stx 'expression '()) 'type))
(define (typeof-expanded stx)
  (syntax->datum (typeof stx)))

(define (free-identifier? id-stx)
  (and (identifier? id-stx)
       (not (identifier-binding id-stx))))

(module+ test
  (require rackunit)

  (check-equal? (syntax->datum
                 (subst #'(List A) (make-hash '((A . Nat)))))
                '(List Nat)))
