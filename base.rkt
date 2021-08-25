#lang racket/base

(require "lib/type.rkt"
         "lib/typeof.rkt"
         "lib/check.rkt"
         "lib/def.rkt"
         "lib/data.rkt")

(provide (all-from-out racket/base)
         (all-from-out "lib/type.rkt")
         (all-from-out "lib/typeof.rkt")
         (all-from-out "lib/check.rkt")
         (all-from-out "lib/def.rkt")
         (all-from-out "lib/data.rkt"))

(module reader syntax/module-reader k/base)
