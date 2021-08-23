#lang k

(provide (data-out List))

(data (List [A : Type]) : Type
      [nil : (List A)]
      [:: (a : A) (l : (List A)) : (List A)])
