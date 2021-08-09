#lang racket

(provide (except-out (all-from-out racket) #%module-begin)
         (rename-out [module-begin #%module-begin]))

(require syntax/parse/define
         (for-syntax syntax/parse))

(define-for-syntax (parse stx)
  (syntax-parse stx
    [(data name:id : typ:id
           constructor ...)
     (list #'name #'typ #'(constructor ...))]
    [else #'else]))

(define-syntax-parser module-begin
  [(statements ...)
   (for ([statement (syntax->list #'(statements ...))])
     (displayln (parse statement)))
   #'(#%module-begin)])

(module reader syntax/module-reader k)
