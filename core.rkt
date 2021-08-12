#lang racket

(provide (all-defined-out))

(struct t:the (value type) #:transparent)
(struct t:type (level) #:transparent)
(struct t:pi (tele+ body) #:transparent)
(struct telescope (name type) #:transparent)
