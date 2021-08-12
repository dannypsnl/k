#lang racket

(provide (all-defined-out))

(require syntax/parse)

(struct t:the (value type) #:transparent)
(struct t:type (level) #:transparent)
(struct t:pi (tele+ body) #:transparent)
(struct telescope (name type) #:transparent)

(define (subst term occurs-map)
  (match term
    [`(,subterm ...)
     `(,(subst subterm occurs-map) ...)]
    [`,name
     (hash-ref occurs-map name name)]))

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
               (match-define (struct* telescope ([name name] [type expect-type]))
                 tele)
               (unless (equal? expect-type arg-type)
                 (raise-syntax-error 'type-mismatched
                                     (format "~a ~a"
                                             expect-type arg-type)
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
