#lang k

(provide Bool true false
         (for-syntax Bool true false))

(data Bool : Type
      [true : Bool]
      [false : Bool])
