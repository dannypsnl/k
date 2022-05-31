#lang racket/base
(provide bindings)

(require syntax/parse
         syntax/stx
         syntax/parse/class/paren-shape)

(define-splicing-syntax-class bindings
  (pattern (~seq b*:bind ...)
    #:with (name ...) #'(b*.explicit-name ... ...)
    #:with (ty ...) #'(b*.explicit-ty ... ...)
    #:with (implicit-name ...) #'(b*.implicit-name ... ...)
    #:with (implicit-ty ...) #'(b*.implicit-ty ... ...)
    #:with (full-name ...) #'(b*.name ... ...)
    #:with (full-ty ...) #'(b*.ty ... ...)))

(define-syntax-class bind
  #:datum-literals (:)
  (pattern {~braces name:id ... : type}
    #:with (ty ...) (stx-map (lambda (name) #'type) #'(name ...))
    #:with (implicit-name ...) #'(name ...)
    #:with (implicit-ty ...) #'(ty ...)
    #:with (explicit-name ...) #'()
    #:with (explicit-ty ...) #'())
  (pattern (name:id ... : type)
    #:with (ty ...) (stx-map (lambda (name) #'type) #'(name ...))
    #:with (implicit-name ...) #'()
    #:with (implicit-ty ...) #'()
    #:with (explicit-name ...) #'(name ...)
    #:with (explicit-ty ...) #'(ty ...)))
