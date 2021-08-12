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
             #:attr value #'(f args ...)))

  (define-syntax-class bind
    (pattern [name:id : typ:type]
             #:attr value #'(telescope 'name typ.value)))
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
       ctors.define ...)])

(define-for-syntax (core-check stx)
  (syntax-parse stx
    [(f args ...)
     (match (eval #'f)
       [(struct* t:the ([value value] [type type]))
        (match type
          [(struct* t:pi ([tele+ tele+] [body typ]))
           (define m (make-hash))
           (define result
             (for/list ([arg-stx (syntax->list #'(args ...))]
                        [tele tele+])
               (match-define (struct* t:the ([value value] [type arg-type]))
                 (core-check arg-stx))
               (match-define (struct* telescope ([name name] [type expect-type]))
                 tele)
               (unless (equal? expect-type arg-type)
                 (raise-syntax-error 'type-mismatched "type mismatched"
                                     arg-stx))
               (hash-set! m name value)
               value))
           (eval #`(t:the '#,(cons value result)
                          '#,(subst typ m)))]
          [else (raise-syntax-error 'not-a-function "not a function"
                                    #'f)])]
       [else (void)])]
    [n (eval #'n)]))

(define-syntax-parser k-app
  [(_ f args ...)
   (core-check #'(f args ...))
   #'(#%app f args ...)])

(module reader syntax/module-reader k)
