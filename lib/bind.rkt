#lang racket/base

(provide bindings)

(require syntax/parse
         syntax/stx)

(define-splicing-syntax-class bindings
  (pattern (~seq b*:bind ...)
           #:with (name ...) #'(b*.name ... ...)
           #:with (ty ...) #'(b*.ty ... ...)))

(define-syntax-class bind
  #:datum-literals (:)
  (pattern (name:id ... : type)
           #:with (ty ...) (stx-map (lambda (name) #'type) #'(name ...))))
