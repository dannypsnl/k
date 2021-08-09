#lang racket

(provide (except-out (all-from-out racket) #%module-begin)
         (rename-out [module-begin #%module-begin]))

(require syntax/parse/define
         (for-syntax syntax/parse))

(begin-for-syntax
  (struct t:type (level) #:transparent)
  (struct t:pi (tele+ body) #:transparent)
  (struct s:constructor (name type) #:transparent)
  (struct telescope (name type) #:transparent)

  (define-syntax-class type
    (pattern Type
             #:attr value #`(t:type #,(gensym 'level)))
    (pattern name:id
             #:attr value #''name))

  (define-syntax-class bind
    (pattern [name:id : typ:type]
             #:attr value #`(telescope name typ)))
  (define-syntax-class constructor
    (pattern [name:id : typ:type]
             #:attr value #`(s:constructor name typ))
    (pattern [name:id binds:bind ... : typ:type]
             #:attr value #`(s:constructor name (t:pi (list binds.value ...) typ)))))

(define-for-syntax (parse stx)
  (syntax-parse stx
    [(data name:id : typ:type)
     (displayln #'typ.value)
     ]
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
