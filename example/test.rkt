#lang k

(require k/data/bool
         k/data/nat)

(data (List [A : Type]) : Type
      [nil : (List A)]
      [cons (head : A) (tail : (List A)) : (List A)])

(List Nat)
(cons z nil)
