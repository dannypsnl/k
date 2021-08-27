#lang k/base

(provide (data-out Fin))

(require k/data/nat)

(data (Fin [n : Nat]) : Type
      [fzero : (Fin (s n))]
      [fsuc (x : (Fin n)) : (Fin (s n))])

(module+ test
  (check (Fin (s z))
         fzero)

  (check (Fin (s (s z)))
         fzero)
  (check (Fin (s (s z)))
         (fsuc fzero))

  (check (Fin (s (s (s z))))
         (fsuc (fsuc fzero))))
