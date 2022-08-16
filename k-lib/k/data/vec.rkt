#lang k/base

(provide (data-out Vec))

(data (Vec [E : Type] [Len : Nat]) : Type
      [nil : (Vec E z)]
      [:: (e : E) (vec : (Vec E n)) : (Vec E (s n))])

(module+ test
  (require rackunit
           k/data/bool)

  (check-equal? nil 'nil)
  (check-equal? (:: true nil) '(:: true nil)))
