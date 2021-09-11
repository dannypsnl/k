#lang scribble/manual
@require[@for-label[(except-in k * + not true false)
                    k/data/nat
                    k/data/bool
                    k/data/list
                    k/data/fin
                    k/equality]
         "helper.rkt"]

@title[#:tag "library"]{Library}

@section{Nat}
@defmodule[k/data/nat]

@defidform[Nat]{
    type @code{Nat}
    @defsubidform[z]{constructor @code{z}}
    @defsubform[(s n)]{constructor @code{s}}
}

@defform[(+ n m)]{
    Plus @code{n} and @code{m}.
}

@defform[(* n m)]{
    Mutiply @code{n} and @code{m}.
}

@defform[(Nat=? n m)]{
    return @code{n} and @code{m} is same(@code{true}) or not(@code{false}).
}

@section{Bool}
@defmodule[k/data/bool]

@defidform[Bool]{
    type @code{Bool}
    @defsubidform[true]{constructor @code{true}}
    @defsubidform[false]{constructor @code{false}}
}

@section{List}
@defmodule[k/data/list]

@defform[(List A)]{
    type @code{List}
    @defsubidform[nil]{constructor @code{nil}}
    @defsubform[(:: e list)]{constructor @code{::}}
}

@section{Vector}
@defmodule[k/data/vec]

@defform[(Vec E Len)]{
    type @code{Vec}
    @defsubidform[nil]{constructor @code{nil}}
    @defsubform[(:: e vec)]{constructor @code{::}}
}

@section{Fin}
@defmodule[k/data/fin]

@defform[(Fin [n : Nat])]{
    type @code{Fin}
    @defsubidform[fzero]{constructor @code{fzero}}
    @defsubform[(fsuc f)]{constructor @code{fsuc}}
}

@section{Equality}
@defmodule[k/equality]

@defform[(≡ x y)]{
    type @code{≡} Martin-Löf identity
    @defsubidform[refl]{constructor @code{refl}}
}
