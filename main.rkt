#lang racket

(provide (except-out (all-from-out racket)
                     #%app)
         data
         (rename-out [k-app #%app]))

(require syntax/parse/define
         "core.rkt"
         (for-syntax syntax/parse
                     racket/match
                     "core.rkt"))

(begin-for-syntax
  (define-syntax-class type
    (pattern name:id
             #:attr value (if (eq? (syntax->datum #'name) 'Type)
                              #`(t:type '#,(gensym 'level))
                              #'name))
    (pattern (f args ...)
             #:attr value #'(core-check #'(f args ...))))

  (define-syntax-class bind
    (pattern [name:id : typ:type]
             #:attr value #'(telescope 'name typ.value)
             #:attr define #'(define-for-syntax name
                               (t:the (freevar 'name) typ.value))))
  (define-syntax-class constructor
    (pattern [name:id : typ:type]
             #:attr define #'(begin
                               (define-for-syntax name (t:the 'name typ.value))
                               (define name 'name)))
    (pattern [name:id binds:bind ... : typ:type]
             #:attr define #'(begin
                               (define-for-syntax name
                                 (t:the 'name (t:pi `(,binds.value ...) typ.value)))
                               (define (name binds.name ...)
                                 `(name ,binds.name ...))))))

(define-syntax-parser data
  [(_ name:id : typ:type
      ctors:constructor ...)
   #'(begin
       (define-for-syntax name (t:the 'name typ.value))
       (define name 'name)
       ctors.define ...)]
  [(_ (name:id binds:bind ...) : typ:type
      ctors:constructor ...)
   #'(begin
       binds.define ...
       (define-for-syntax name
         (t:the 'name (t:pi `(,binds.value ...) typ.value)))
       (define (name binds.name ...)
         `(name ,binds.name ...))
       ctors.define ...)])

(define-syntax-parser k-app
  [(_ f args ...)
   (core-check #'(f args ...))
   #'(#%app f args ...)])

(module reader syntax/module-reader k)
