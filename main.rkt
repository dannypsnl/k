#lang racket

(provide (all-from-out racket)
         (all-from-out "base.rkt"))

(require "base.rkt")

(module reader syntax/module-reader k)
