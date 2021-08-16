#lang k

(require k/data/bool
         k/data/nat)

(def identity : (-> Nat Nat)
  [true => z])
