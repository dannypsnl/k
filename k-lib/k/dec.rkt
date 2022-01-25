#lang k/base
(provide (data-out Dec)
         not)

(def (not [v : Type]) : Type
  [P => (-> P ⊥)])

(data (Dec [A : Type]) : Type
      [yes : (A . -> . (Dec A))]
      [no : ((not A) . -> . (Dec A))])
