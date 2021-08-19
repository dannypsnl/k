#lang k

(provide List nil ::)

(data (List [A : Type]) : Type
      [nil : (List A)]
      [:: (a : A) (l : (List A)) : (List A)])
