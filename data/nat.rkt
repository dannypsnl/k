#lang k

(provide Nat z s)

(data Nat : Type
      [z : Nat]
      [s (n : Nat) : Nat])

(module+ test
  (require rackunit)

  (check-equal? Nat 'Nat)
  (check-equal? z 'z)
  (check-equal? (s (s (s z))) '(s (s (s z)))))
