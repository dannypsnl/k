#lang scribble/manual
@require[@for-label[k]
         "helper.rkt"]

@title[#:tag "library"]{Library}

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

@defmodule[k/data/bool]

@defidform[Bool]{
    type @code{Bool}
    @defsubidform[true]{constructor @code{true}}
    @defsubidform[false]{constructor @code{false}}
}

@defmodule[k/data/list]

@defform[(List A)]{
    type @code{List}
    @defsubidform[nil]{constructor @code{nil}}
    @defsubform[(:: e list)]{constructor @code{::}}
}

@defmodule[k/data/vec]

@defform[(Vec E Len)]{
    type @code{Vec}
    @defsubidform[nil]{constructor @code{nil}}
    @defsubform[(:: e vec)]{constructor @code{::}}
}

@defmodule[k/equality]

@defform[(≡ x y)]{
    type @code{≡}: Martin-Löf identity
    @defsubidform[refl]{constructor @code{refl}}
}
