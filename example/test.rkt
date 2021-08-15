#lang k

(require k/data/bool
         k/data/nat)

(data (List [A : Type]) : Type
      [nil : (List A)]
      [cons (a : A) (l : (List A)) : (List A)])

(List Nat)
(cons (s z) (cons z nil))
; FIXME: this didn't get checked
(cons false (cons z nil))
