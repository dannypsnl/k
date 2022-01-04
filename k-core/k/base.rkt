#lang racket/base

(require "type.rkt"
         "typeof.rkt"
         "check.rkt"
         "def.rkt"
         "data.rkt")

(provide (all-from-out
          racket/base
          "type.rkt"
          "typeof.rkt"
          "check.rkt"
          "def.rkt"
          "data.rkt"))

(module reader syntax/module-reader k/base)
