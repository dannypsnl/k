#lang info
(define collection "k")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/k.scrbl" (multi-page) (tool))))
(define pkg-desc "k theorem prover")
(define version "0.0")
(define license '(Apache-2.0 OR MIT))
(define pkg-authors '(dannypsnl))

(define compile-omit-paths '("example" "test"))
