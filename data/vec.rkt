#lang k

(provide Vec nil ::
         (for-syntax Vec nil ::))

(data (Vec [E : Type] [Len : Nat]) : Type
      [nil : (Vec E z)]
      [:: (e : E) (vec : (Vec E n)) : (Vec E (s n))])

(module+ test
  (require rackunit
           k/data/nat)

  (check-equal? nil 'nil)
  (check-equal? (:: z nil) '(:: z nil)))
