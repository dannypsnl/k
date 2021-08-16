#lang k

(require k/data/bool
         k/data/nat
         k/data/list)

(List Nat)
(typeof (cons (s z) (cons z nil)))
; FIXME: this didn't get checked
(cons false (cons z nil))
