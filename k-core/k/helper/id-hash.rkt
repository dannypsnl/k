#lang racket/base
(provide make-mutable-id-hash)

(require racket/dict)

(define-custom-hash-types id-hash
  #:key? identifier?
  free-identifier=?)

(module+ test
  (require rackunit
           racket/dict)

  (define m (make-mutable-id-hash))
  (dict-set! m #'a 1)
  (check-equal? (dict-ref m #'a)
                1))
