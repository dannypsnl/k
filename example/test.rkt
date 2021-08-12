#lang k

(provide Zero)

(require k/data/bool
         k/data/nat)

(data Zero : Type)
(data One : Type
      [one : One])

(data (List [A : Type]) : Type
      [nil : (List A)]
      [cons (head : A) (tail : (List A)) : (List A)])

(cons z (cons (s z) nil))
(cons true (cons z (cons z nil))) ; FIXME: this is a case shall get report
