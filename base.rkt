#lang racket/base

(require "lib/type.rkt"
         "lib/typeof.rkt"
         "lib/check.rkt"
         "lib/def.rkt"
         "lib/data.rkt")

(provide (all-from-out
          racket/base
          "lib/type.rkt"
          "lib/typeof.rkt"
          "lib/check.rkt"
          "lib/def.rkt"
          "lib/data.rkt"))

(module reader syntax/module-reader k/base)
