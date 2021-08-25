#lang racket/base

(provide typeof)

(require syntax/parse/define
         (for-syntax racket/base
                     "core.rkt"))

(define-syntax-parser typeof
  [(_ stx) #`'#,(typeof-expanded #'stx)])
