#lang racket

(provide (except-out (all-from-out racket) #%module-begin)
         (rename-out [module-begin #%module-begin]))

(require syntax/parse/define
         (for-syntax syntax/parse))

(begin-for-syntax
  (struct s:type (level) #:transparent)
  (struct s:constructor (name type) #:transparent)

  (define-syntax-class type
    (pattern Type
             #:attr value #`(s:type #,(gensym 'level)))
    (pattern name:id
             #:attr value #''name))

  (define-syntax-class constructor
    (pattern [name:id binds ... : typ:type]
             #:attr value #`(s:constructor name typ))))

(define-for-syntax (parse stx)
  (syntax-parse stx
    [(data name:id : typ:type
           ctors:constructor ...)
     (displayln #'typ.value)
     (displayln #'(ctors.value ...))
     ]
    [else #'else]))

(define-syntax-parser module-begin
  [(statements ...)
   (for ([statement (syntax->list #'(statements ...))])
     (parse statement))
   #'(#%module-begin)])

(module reader syntax/module-reader k)
