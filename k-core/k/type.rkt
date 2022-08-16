#lang racket

(provide Type Pi)

(require syntax/parse/define)

(define-syntax-parser Pi
  #:datum-literals (:)
  [(_ ([tele-name* : tele-typ*] ...)
      result)
   (syntax-property #'`(Pi (,`[tele-name* : ,tele-typ*] ...)
                           ,result)
                    'type #'Type)])

(define-syntax-parser Type
  [_ (syntax-property #''Type 'type #'Type)])
