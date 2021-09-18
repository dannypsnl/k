#lang racket

(provide (all-from-out
          racket
          "base.rkt"))

(require "base.rkt")

(module reader syntax/module-reader k)
