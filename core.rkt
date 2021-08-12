#lang racket

(provide (all-defined-out))

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
