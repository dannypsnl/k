#lang k

(provide Nat z s)

(data Nat : Type
      [z : Nat]
      [s (n : Nat) : Nat])

(def + : (-> Nat Nat Nat)
  [z m => m]
  [(s n) m => (s (+ n m))])

(module+ test
  (require rackunit)

  (check-equal? Nat 'Nat)
  (check-equal? z 'z)
  (check-equal? (s (s (s z))) '(s (s (s z))))

  (def a : Nat z)
  (check-equal? a z)

  (check-equal? (+ z (s z)) '(s z))
  (check-equal? (+ (s z) (s z))
                '(s (s z)))
  (check-equal? (+ (s (s z)) (s z))
                '(s (s (s z)))))
