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
    @defsubform[(s [n : Nat])]{constructor @code{s}}
}

@defform[(+ [n m : Nat])]{
    Plus @code{n} and @code{m}.
}

@defform[(* [n m : Nat])]{
    Mutiply @code{n} and @code{m}.
}

@defform[(Nat=? [n m : Nat])]{
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

@defform[(List [E : Type])]{
    type @code{List}
    @defsubidform[nil]{constructor @code{nil}}
    @defsubform[(:: [e : E] [list : (List E)])]{constructor @code{::}}
}

@section{Vector}
@defmodule[k/data/vec]

@defform[(Vec [E : Type] [Len : Nat])]{
    type @code{Vec}
    @defsubidform[nil]{constructor @code{nil}}
    @defsubform[(:: [e : E] [vec : (Vec E n)])]{constructor @code{::}}
}

@section{Fin}
@defmodule[k/data/fin]

@defform[(Fin [n : Nat])]{
    type @code{Fin}
    @defsubidform[fzero]{constructor @code{fzero}}
    @defsubform[(fsuc [f : (Fin n)])]{constructor @code{fsuc}}
}

@section{Equality}
@defmodule[k/equality]

@defform[(≡ [x y : A])]{
    type @code{≡} Martin-Löf identity
    @defsubidform[refl]{constructor @code{refl}}
}
