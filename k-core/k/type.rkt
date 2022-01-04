#lang racket

(provide Type Pi)

(require syntax/parse/define)

(define-syntax-parser Pi
  #:datum-literals (:)
  [(_ [tele-name* : tele-typ*] ... result-ty)
   (define max-level
     (apply max
            (cons 0
                  (filter number?
                          (map (λ (stx)
                                 (syntax-property stx 'level))
                               (syntax->list #'(tele-typ* ...)))))))
   (syntax-property #'`(Pi ,`[tele-name* : ,tele-typ*] ...
                           ,result-ty)
                    'type #`(Type #,max-level))])

(define-syntax-parser Type
  [_ (syntax-property
      (syntax-property #'(list 'Type 0) 'type #'(Type 1))
      'level 0)]
  [(_ n)
   (syntax-property
    (syntax-property #'(list 'Type n) 'type #'(Type (add1 n)))
    'level (syntax->datum #'n))])
