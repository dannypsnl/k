#lang racket/base

(provide bind)

(require syntax/parse)

(define-syntax-class bind
  #:datum-literals (:)
  (pattern (name:id : ty)))
