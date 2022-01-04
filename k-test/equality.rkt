#lang k

(module+ test
  (require (only-in rackunit check-exn)
           syntax/macro-testing
           k/equality
           k/data/nat)

  (check-exn #rx"cannot-unified: `z` with `\\(s z\\)`"
             (lambda () (convert-compile-time-error
                         (check (≡ z (s z))
                                refl)
                         )))
  (check-exn #rx"cannot-unified: `\\(s \\(s z\\)\\)` with `\\(s z\\)`"
             (lambda () (convert-compile-time-error
                         (check (≡ (+ (s z) (s z)) (s z))
                                refl)
                         )))
  (check-exn #rx"cannot-unified: `\\(s \\(s \\(s \\(s z\\)\\)\\)\\)` with `z`"
             (lambda () (convert-compile-time-error
                         (check (≡ (* (s (s z)) (s (s z))) z)
                                refl)
                         )))
  )
