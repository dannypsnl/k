#lang racket

(provide (except-out (all-from-out racket))
         data)

(require syntax/parse/define
         (for-syntax syntax/parse))

(struct t:the (value type) #:transparent)
(struct t:type (level) #:transparent)
(struct t:pi (tele+ body) #:transparent)
(struct s:constructor (name type) #:transparent)
(struct telescope (name type) #:transparent)

(begin-for-syntax
  (define-syntax-class type
    (pattern name:id
             #:attr value (if (eq? (syntax->datum #'name) 'Type)
                              #`(t:type '#,(gensym 'level))
                              #''name)))

  (define-syntax-class bind
    (pattern [name:id : typ:type]
             #:attr value #`(telescope name typ)))
  (define-syntax-class constructor
    (pattern [name:id : typ:type]
             #:attr value #`(s:constructor name typ)
             #:attr define #'(define name (t:the 'name typ.value)))
    (pattern [name:id binds:bind ... : typ:type]
             #:attr value #`(s:constructor name (t:pi `(,binds.value ...) typ))
             #:attr define #'(define (name binds.name ...)
                               (t:the `(name ,binds.name ...) typ.value)))))

(define-syntax-parser data
  [(_ name:id : typ:type)
   #'(define name (t:the 'name typ.value))]
  [(_ name:id : typ:type
      ctors:constructor ...)
   #'(begin
       (define name (t:the 'name typ.value))
       ctors.define ...)])

(module reader syntax/module-reader k)
