#lang k

(module+ test
  (require (only-in rackunit check-exn)
           syntax/macro-testing
           k/data/bool
           k/data/nat)

  (check-exn #rx"cannot-unified: `Nat` with `Bool`"
             (lambda () (convert-compile-time-error
                         (def (foo [x : Nat]) : Bool
                            [x => x])
                         )))
  )
