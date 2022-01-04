#lang info
(define collection 'multi)
(define deps '())
(define build-deps '("base"
                     "rackunit-lib"
                     "k-core"
                     "k-lib"))
(define update-implies '("k-core" "k-lib"))
(define pkg-desc "test of k")
(define pkg-authors '(dannypsnl cybai))
