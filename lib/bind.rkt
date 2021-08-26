#lang racket/base

(provide bind)

(require syntax/parse)

(define-syntax-class bind
  (pattern (name:id (~literal :) ty)))
