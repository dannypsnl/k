#lang racket

(provide defsubidform)

(require scribble/core
         scribble/decode
         scribble/private/manual-form)

(define-syntax (defsubidform stx)
  (syntax-case stx ()
    [(_ . rest) #'(into-blockquote (defidform . rest))]))

(define (into-blockquote s)
  (make-nested-flow (make-style "leftindent" null)
                    (if (splice? s)
                        (decode-flow (splice-run s))
                        (list s))))
