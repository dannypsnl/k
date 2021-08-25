#lang k/base

(provide (data-out Bool)
         not)

(data Bool : Type
      [true : Bool]
      [false : Bool])

(def (not [b : Bool]) : Bool
  [false => true]
  [true => false])
