#lang racket/base
(provide check)
(require syntax/parse/define
         "def.rkt"
         (for-syntax racket/base
                     racket/syntax))

(define-syntax-parser check
  [(_ ty expr)
   (with-syntax ([name (generate-temporary)])
     #'(def name : ty
         expr))])
