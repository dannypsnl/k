#lang k

(module+ test
  (require (only-in rackunit check-exn)
           syntax/macro-testing
           k/data/nat
           k/data/bool)

  (check-exn #rx"type-mismatch"
             (lambda () (convert-compile-time-error
                         ; A definitely wrong definition
                         (def (foo [x : Nat]) : Bool
                           [x => x])
                         ))))
