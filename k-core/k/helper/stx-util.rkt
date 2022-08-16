#lang racket/base
(provide (all-defined-out))
(require syntax/stx)

(define (stx-andmap f . stx-lst)
  (apply andmap f (map stx->list stx-lst)))
(define (stx-ormap f . stx-lst)
  (apply ormap f (map stx->list stx-lst)))

(define (stx-length stx) (length (stx->list stx)))
(define (stx-length=? stx1 stx2)   (= (stx-length stx1) (stx-length stx2)))
(define (stx-length>=? stx1 stx2)  (>= (stx-length stx1) (stx-length stx2)))
(define (stx-length<=? stx1 stx2)  (<= (stx-length stx1) (stx-length stx2)))

(module+ test
  (require rackunit)

  (check-true (stx-length=? #'(a b c) #'(1 2 3)))
  (check-true (stx-length<=? #'(a) #'(1 2 3)))
  (check-true (stx-length>=? #'(a b c d e) #'(1 2 3)))

  (check-true (stx-andmap identifier? #'(a b c)))
  (check-true (stx-ormap identifier? #'(1 b 3))))
