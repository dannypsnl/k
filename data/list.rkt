#lang k

(provide List nil cons)

(data (List [A : Type]) : Type
      [nil : (List A)]
      [cons (a : A) (l : (List A)) : (List A)])
