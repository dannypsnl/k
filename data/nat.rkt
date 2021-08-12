#lang k

(provide Nat z s
         (for-syntax Nat z s))

(data Nat : Type
      [z : Nat]
      [s (n : Nat) : Nat])
