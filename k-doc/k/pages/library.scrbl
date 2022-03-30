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
    @defsubform[(s n)]{constructor @code{s},
     @code{n} is a @code{Nat}
     }
}

@defform[(+ n m)]{
    @code{n}, @code{m} are @code{Nat}, returns @code{Nat}.
    Plus @code{n} and @code{m}.
}

@defform[(* n m)]{
    @code{n}, @code{m} are @code{Nat}, returns @code{Nat}.
    Mutiply @code{n} and @code{m}.
}

#;@defform[(Nat=? n m)]{
    @code{n}, @code{m} are @code{Nat}, returns @code{Bool}.
    return @code{n} and @code{m} is same(@code{true}) or not(@code{false}).
}

@section{Bool}
@defmodule[k/data/bool]

@defidform[Bool]{
    type @code{Bool}
    @defsubidform[true]{constructor @code{true}}
    @defsubidform[false]{constructor @code{false}}
}

@defform[(not b)]{
    @code{b} is @code{Bool}, returns @code{Bool}.
    return @code{true} for @code{false},
    return @code{false} for @code{true}.
}

@section{List}
@defmodule[k/data/list]

@defform[(List A)]{
    type @code{List},
    @code{A} is a @code{Type}.
    @defsubidform[nil]{constructor @code{nil}}
    @defsubform[(:: e list)]{constructor @code{::}
     @code{e} is a @code{A},
     @code{list} is a @code{(List A)}
     }
}

@section{Vector}
@defmodule[k/data/vec]

@defform[(Vec E Len)]{
    type @code{Vec},
    @code{E} is a @code{Type},
    @code{Len} is a @code{Nat}.
    @defsubidform[nil]{constructor @code{nil}, @code{Len} is @code{z} for @code{nil}}
    @defsubform[(:: e vec)]{constructor @code{::},
     @code{e} is a @code{E},
     for @code{vec} is a @code{(Vec E n)}, @code{(:: e vec)} is a @code{(Vec E (s n))}
     }
}

@section{Fin}
@defmodule[k/data/fin]

@defform[(Fin n)]{
    type @code{Fin}, @code{n} is a @code{Nat}
    @defsubidform[fzero]{constructor @code{fzero}}
    @defsubform[(fsuc f)]{constructor @code{fsuc},
     for @code{f} is a @code{(Fin n)}, @code{(fsuc f)} is a @code{(Fin (s n))}
     }
}

@section{Equality}
@defmodule[k/equality]

@defform[(≡ x y)]{
    type @code{≡} Martin-Löf identity, since @code{x}, @code{y} will going to be unified by @code{refl},
    it provides definition equality.
    @defsubidform[refl]{constructor @code{refl}}
}
