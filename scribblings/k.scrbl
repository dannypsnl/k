#lang scribble/manual
@require[@for-label[k]]

@title{k}
@author{Lîm Tsú-thuàn/林子篆}

@defmodule[k]

k is a theorem prover that works under racket ecosystem, wants to interact with normal racket program, still in active development.

@section{Language}

This section introduces forms of the language.

@defform[(Type level)]{
    Type is builtin form to represent a type, for example, @code{Nat} has type @code{Type}, @code{(List Nat)} has type @code{Type}, and @code{(Type a)} has type @code{(Type (add1 a))}.
}


@defform[
    (data data-bind : type
          constructor ...)
    #:grammar
    [
        (data-bind name
                   (name bind ...))
        (constructor [name bind ... : type])
        (bind [name : type])
        (type name
              (name type ...))
    ]
]{
    Here list some classic definition to show how to use @code{data} form, you can get more in library: @code{k/data}.

    @racketblock[
        (data Nat : Type
              [z : Nat]
              [s (n : Nat) : Nat])
        (data (Pair [L : Type] [R : Type]) : Type
              [cons [l : L] [r : R] : (Pair L R)])
    ]
}

@defform[
    (check type term)
    #:grammar
    [
        (type term)
        (term name
              (name term ...))
    ]
]{
    For example, we can have:

    @racketblock[
        (check Nat
               (s (s z)))
        (check Bool
               false)
    ]

    If we using wrong type:

    @racketblock[
        (check Bool
               z)
    ]

    The syntax error will raise.
}

@defform[
    (typeof term)
    #:grammar
    [
        (term name
              (name term ...))
    ]
]{
    For example, we can have

    @codeblock{
        (typeof Nat) ; Type
        (typeof true) ; Bool
    }
}

@defform[
    (def def-bind : type
         clause ...)
    #:grammar
    [
        (def-bind name
                  (name bind ...))
        (clause [pat ... => term])
        (pat name
             (name pat ...))
        (bind [name : type])
        (type term)
        (term name
              (name term ...))
    ]
]{
    For example, we can have:

    @racketblock[
        (def a : Nat z)
    ]

    It can use to construct a proof

    @racketblock[
        (def (0+x [x : Nat]) : (≡ (+ z x) x)
          [x => refl])
    ]
}

@section{Library}

@subsection{k/data/nat}

@defidform[Nat]{type @code{Nat}}
@defidform[z]{constructor @code{z}}
@defform[(s n)]{constructor @code{s}}

@defform[(+ n m)]{
    Plus @code{n} and @code{m}.
}

@defform[(* n m)]{
    Mutiply @code{n} and @code{m}.
}

@defform[(Nat=? n m)]{
    return @code{n} and @code{m} is same(@code{true}) or not(@code{false}).
}

@subsection{k/data/bool}

@defidform[Bool]{type @code{Bool}}
@defidform[true]{constructor @code{true}}
@defidform[false]{constructor @code{false}}

@subsection{k/data/list}

@defform[(List A)]{type @code{List}}
@defidform[nil]{constructor @code{nil}}
@defform[(:: e list)]{constructor @code{::}}

@subsection{k/data/vec}

@defform[(Vec E Len)]{type @code{Vec}}
@defidform[nil]{constructor @code{nil}}
@defform[(:: e vec)]{constructor @code{::}}

@subsection{k/equality}

@defform[(≡ x y)]{type @code{≡}}
@defidform[refl]{constructor @code{refl}}