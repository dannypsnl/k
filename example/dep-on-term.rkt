#lang k

(require k/data/nat
         k/data/bool)

(def (Nat-or-Bool [x : Bool]) : Type
  [true => Nat]
  [false => Bool])

(check (Nat-or-Bool true) z)
(check (Nat-or-Bool false) true)
