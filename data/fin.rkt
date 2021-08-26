#lang k/base

(provide (data-out Fin))

(require k/data/nat)

(data (Fin [n : Nat]) : Type
      [fzero : (Fin (s n))]
      [fsuc (x : (Fin n)) : (Fin (s n))])
