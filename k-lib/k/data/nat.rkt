#lang k/base

(provide (data-out Nat)
         + *
         Nat=?
         Nat<)

(require k/data/bool)

(data Nat : Type
      [z : Nat]
      [s (n : Nat) : Nat])

(def (+ [n m : Nat]) : Nat
  [z m => m]
  [(s n) m => (s (+ n m))])

(def (* [n m : Nat]) : Nat
  [z m => z]
  [(s n) m => (+ m (* n m))])

(def (Nat=? [n m : Nat]) : Bool
  [z z => true]
  [z (s m) => false]
  [(s n) z => false]
  [(s n) (s m) => (Nat=? n m)])

(def (Nat< [n m : Nat]) : Bool
  [n z => false]
  [z (s m) => true]
  [(s n) (s m) => (Nat< n m)])

(def (fib [n : Nat]) : Nat
  [z => z]
  [(s z) => (s z)]
  [(s (s n)) => (+ (fib (s n))
                   (fib n))])

(module+ test
  (require rackunit)

  (check-equal? Nat 'Nat)
  (check-equal? (typeof z) 'Nat)
  (check-equal? (typeof s) '(Pi ([n : Nat]) Nat))
  (check-equal? z 'z)
  (check-equal? (s (s (s z))) '(s (s (s z))))

  (def a : Nat (s (s z)))
  (check-equal? a (s (s z)))

  (def b : Nat (+ z (s (s z))))
  (check-equal? b (s (s z)))

  (check-equal? (+ z (s z)) '(s z))
  (check-equal? (+ (s z) (s z))
                '(s (s z)))
  (check-equal? (+ (s (s z)) (s z))
                '(s (s (s z))))

  (check-equal? (* (s (s z)) (s z))
                '(s (s z)))
  (check-equal? (* (s (s z)) (s (s z)))
                '(s (s (s (s z))))))
