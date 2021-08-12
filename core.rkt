#lang racket

(provide (all-defined-out))

(require syntax/parse)

(struct t:the (value type) #:transparent)
(struct freevar (v) #:transparent)
(struct t:type (level) #:transparent)
(struct t:pi (tele+ body) #:transparent)
(struct telescope (name type) #:transparent)

(define (subst term occurs-map)
  (match term
    [`(,subterm ...)
     `(,(subst subterm occurs-map) ...)]
    [`,name
     (hash-ref occurs-map name name)]))

(define (unify? type-a type-b)
  (match* {type-a type-b}
    [{(struct* t:the ([value a] [type ta]))
      (struct* t:the ([value b] [type tb]))}
     (and (unify? a b)
          (unify? ta tb))]
    [{(freevar v) b}
     #t]
    [{a (freevar v)}
     (unify? type-a a)]
    [{(struct* t:type ([level a]))
      (struct* t:type ([level b]))}
     ; TODO: (record a = b)
     #t]
    [{a b} (equal? a b)]))

(define (core-check stx)
  (syntax-parse stx
    [(f args ...)
     (match (eval #'f)
       [(struct* t:the ([value value] [type type]))
        (match type
          [(struct* t:pi ([tele+ tele+] [body typ]))
           (define m (make-hash))
           (define result
             (for/list ([arg-stx (syntax->list #'(args ...))]
                        [tele tele+])
               (match-define (struct* t:the ([value value] [type arg-type]))
                 (core-check arg-stx))
               (match-define (struct* telescope ([name name] [type exp-type]))
                 tele)
               (unless (unify? exp-type arg-type)
                 (raise-syntax-error 'type-mismatched
                                     (format "expected: ~a, got: ~a"
                                             exp-type arg-type)
                                     arg-stx))
               (hash-set! m name value)
               value))
           (eval #`(t:the '#,(cons value result)
                          '#,(subst typ m)))]
          [else (raise-syntax-error 'not-a-function "not a function"
                                    #'f)])]
       [else (raise-syntax-error 'invalid-term "invalid term"
                                 #'f)])]
    [n (eval #'n)]))
