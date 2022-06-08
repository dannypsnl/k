# k theorem prover

Notes for k theorem prover.

### Introduction

A theorem prover based on type theory, means a programming language that implies dependent type, then do not allow some illed-types by checking the definition. To get start, famous [Mini-TT](http://www.cse.chalmers.se/~bengt/papers/GKminiTT.pdf) is a great resource, it demonstrate a very simple language that can be understood by many.

#### Peano axioms

Peano is a formation about natural number, in **k** you can define a **data type** like the following

```racket
(data Nat : Type
  [z : Nat]
  [s (n : Nat) : Nat])
```
