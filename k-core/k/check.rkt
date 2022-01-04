#lang racket/base

(provide check)

(require syntax/parse/define
         (for-syntax racket/base
                     "core.rkt"))

(define-syntax-parser check
  [(_ ty expr)
   (check-type #'expr (normalize #'ty))
   #'(begin
       (void ty)
       expr)])
